def test_produits_plus_de_100_euros(curseur):
    curseur.execute(
        "SELECT nom, categorie, prix, stock FROM produit WHERE prix > 100"
    )
    lignes = curseur.fetchall()

    assert lignes

    for ligne in lignes:
        prix = ligne[2]
        assert prix > 100


def test_clients_par_ville(curseur):
    curseur.execute(
        """
        SELECT ville, COUNT(id) AS nombre_clients
        FROM client
        GROUP BY ville
        ORDER BY nombre_clients DESC
        """
    )
    lignes = curseur.fetchall()
    effectifs = []

    for ligne in lignes:
        nombre_clients = ligne[1]
        effectifs.append(nombre_clients)

    assert len(lignes) == 10
    assert effectifs == [10] * 10
    assert sum(effectifs) == 100


def test_montant_total_commandes(curseur):
    curseur.execute(
        """
        SELECT
            c.id AS commande_id,
            c.date_commande,
            c.statut,
            ROUND(SUM(lc.quantite * lc.prix_unitaire), 2) AS montant_total
        FROM commande AS c
        JOIN ligne_commande AS lc
            ON lc.commande_id = c.id
        GROUP BY
            c.id,
            c.date_commande,
            c.statut
        ORDER BY c.date_commande, c.id
        """
    )
    lignes = curseur.fetchall()

    assert lignes

    for ligne in lignes:
        montant = ligne[3]
        assert montant >= 0


def test_chiffre_affaires_par_categorie(curseur):
    curseur.execute(
        """
        SELECT
            p.categorie,
            ROUND(SUM(lc.quantite * lc.prix_unitaire), 2) AS chiffre_affaires,
            SUM(lc.quantite) AS quantite_totale_vendue
        FROM commande AS c
        JOIN ligne_commande AS lc ON lc.commande_id = c.id
        JOIN produit AS p ON p.id = lc.produit_id
        WHERE c.statut <> 'annulée'
        GROUP BY p.categorie
        ORDER BY chiffre_affaires DESC
        """
    )
    lignes = curseur.fetchall()
    montants = []

    for ligne in lignes:
        chiffre_affaires = ligne[1]
        montants.append(chiffre_affaires)

    assert montants == sorted(montants, reverse=True)

    for chiffre_affaires in montants:
        assert chiffre_affaires >= 0


def test_produits_les_plus_vendus(curseur):
    curseur.execute(
        """
        SELECT
            p.id AS produit_id,
            p.nom AS produit,
            p.categorie,
            SUM(lc.quantite) AS quantite_totale_vendue
        FROM produit AS p
        JOIN ligne_commande AS lc ON lc.produit_id = p.id
        JOIN commande AS c ON c.id = lc.commande_id
        WHERE c.statut <> 'annulée'
        GROUP BY p.id, p.nom, p.categorie
        ORDER BY quantite_totale_vendue DESC, p.nom
        LIMIT 10
        """
    )
    lignes = curseur.fetchall()
    quantites = []

    for ligne in lignes:
        quantite = ligne[3]
        quantites.append(quantite)

    assert len(lignes) <= 10
    assert quantites == sorted(quantites, reverse=True)


def test_anomalies_de_date(curseur):
    curseur.execute(
        """
        SELECT
            co.id AS id_commande,
            cl.id AS id_client,
            co.date_commande,
            cl.date_inscription
        FROM commande co
        JOIN client cl
            ON co.client_id = cl.id
        WHERE co.date_commande < cl.date_inscription
        """
    )
    lignes = curseur.fetchall()

    for ligne in lignes:
        date_commande = ligne[2]
        date_inscription = ligne[3]
        assert date_commande < date_inscription


def test_produits_jamais_vendus(curseur):
    curseur.execute(
        """
        SELECT
            pr.id,
            pr.nom,
            pr.categorie,
            pr.prix,
            pr.stock
        FROM produit pr
        LEFT JOIN ligne_commande lico
            ON pr.id = lico.produit_id
        WHERE lico.produit_id IS NULL
        """
    )
    lignes = curseur.fetchall()
    identifiants = []

    for ligne in lignes:
        identifiant = ligne[0]
        identifiants.append(identifiant)

    identifiants_attendus = [61, 62, 63, 64, 65]

    for identifiant in identifiants_attendus:
        assert identifiant in identifiants
