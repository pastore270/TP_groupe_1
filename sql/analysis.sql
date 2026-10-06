--1.1 Liste de tous les produits
SELECT nom, categorie, prix, stock FROM produit;
--1.2 Produits dont le prix est supérieur à 100 €
SELECT nom, categorie, prix, stock FROM produit WHERE prix > 100;
--2.1 Clients habitant dans une ville donnée
SELECT * FROM client WHERE ville = 'Paris';
--2.2 Nombre de clients dans chaque ville
SELECT ville, COUNT(id) AS nombre_clients FROM client GROUP BY ville ORDER BY nombre_clients DESC;
--3 Explorer les commandes
SELECT c.id AS commande_id,
    c.date_commande,
    c.statut,
    cl.id AS client_id,
    cl.nom AS client_nom,
    cl.prenom AS client_prenom,
    cl.email AS client_email,
    cl.ville AS client_ville,
    cl.date_inscription
FROM commande AS c
JOIN client AS cl
    ON cl.id = c.client_id
ORDER BY c.date_commande DESC, c.id DESC;
--4 Calculer le montant d'une ligne
SELECT lc.id AS ligne_id,
    lc.commande_id,
    lc.produit_id,
    p.nom AS produit,
    lc.quantite,
    lc.prix_unitaire,
    ROUND(lc.quantite * lc.prix_unitaire, 2) AS montant_ligne
FROM ligne_commande AS lc
JOIN produit AS p
    ON p.id = lc.produit_id
ORDER BY lc.commande_id, lc.id;
--5.1 Toutes les commandes
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
ORDER BY c.date_commande, c.id;
--5.2 Version avec LEFT JOIN
SELECT
    c.id AS commande_id,
    c.date_commande,
    c.statut,
    COALESCE(ROUND(SUM(lc.quantite * lc.prix_unitaire), 2),0) AS montant_total
FROM commande AS c
LEFT JOIN ligne_commande AS lc ON lc.commande_id = c.id
GROUP BY c.id, c.date_commande, c.statut ORDER BY c.date_commande, c.id;
--Exercice 6 — Chiffre d’affaires par catégorie
SELECT
    p.categorie,
    ROUND(SUM(lc.quantite * lc.prix_unitaire), 2) AS chiffre_affaires,
    SUM(lc.quantite) AS quantite_totale_vendue
FROM commande AS c
JOIN ligne_commande AS lc ON lc.commande_id = c.id
JOIN produit AS p ON p.id = lc.produit_id
WHERE c.statut <> 'annulée'
GROUP BY p.categorie ORDER BY chiffre_affaires DESC;
-- exo 7 les 10 produits les plus vendus
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
LIMIT 10;

<<<<<<< HEAD
<<<<<<< HEAD
-- Exercice 8 — Produits générant le plus de chiffre d'affaires
SELECT produit.nom, produit.categorie, SUM(ligne_commande.quantite * ligne_commande.prix_unitaire) AS CA
FROM produit
JOIN ligne_commande ON produit.id = ligne_commande.produit_id
GROUP BY produit.nom, produit.categorie
ORDER BY CA DESC;
=======






=======
>>>>>>> 6758406301bcef84d286718f246bedbce0e3c684
--Exercice-9 Client 
SELECT 
    c.id,
    c.nom,
    c.prenom,
    COUNT(DISTINCT cmd.id) AS nb_commandes,
    COALESCE(SUM(lc.quantite * lc.prix_unitaire), 0) AS total_depense,
    (COUNT(cmd.id) = 0) AS jamais_commande
FROM client c
LEFT JOIN commande cmd ON c.id = cmd.client_id
LEFT JOIN ligne_commande lc ON cmd.id = lc.commande_id
GROUP BY c.id;
<<<<<<< HEAD
>>>>>>> b35902b1c04922bd877ef011c5c0b2a25254b290
=======


--Exercice-10 Panier Moyen
--Plateforme 
SELECT 
    ROUND(SUM(lc.quantite * lc.prix_unitaire) / COUNT(DISTINCT c.id), 2) AS panier_moyen
FROM commande c
JOIN ligne_commande lc ON c.id = lc.commande_id;

--Mensuel 
SELECT 
    COALESCE(TO_CHAR(c.date_commande, 'YYYY-MM'), 'GLOBAL') AS periode,
    ROUND(SUM(lc.quantite * lc.prix_unitaire) / COUNT(DISTINCT c.id), 2) AS panier_moyen
FROM commande c
JOIN ligne_commande lc ON c.id = lc.commande_id
GROUP BY ROLLUP(TO_CHAR(c.date_commande, 'YYYY-MM'))
ORDER BY periode;
<<<<<<< HEAD
>>>>>>> b24b6f5cd825c23a481acab9938340539e9aab43
=======

--Exercice-11 Catégoriser les commandes

SELECT
    co.id AS id_commande,
    SUM(lico.quantite * lico.prix_unitaire) AS montant_total,

    CASE
        WHEN SUM(lico.quantite * lico.prix_unitaire) < 500
            THEN 'Petit panier'

        WHEN SUM(lico.quantite * lico.prix_unitaire) < 1500
            THEN 'Panier moyen'

        ELSE 'Gros panier'
    END AS categorie

FROM commande co
JOIN ligne_commande lico
    ON co.id = lico.commande_id

GROUP BY co.id
ORDER BY montant_total;

--Exercice-12 Analyse temporelle
SELECT
    EXTRACT(MONTH FROM co.date_commande) AS mois,
    SUM(lico.quantite * lico.prix_unitaire) AS chiffre_affaires
FROM commande co
JOIN ligne_commande lico
    ON co.id = lico.commande_id
GROUP BY EXTRACT(MONTH FROM co.date_commande)
ORDER BY mois;

--Exercice-13 Détecter une incohérence

SELECT
    co.id AS id_commande,
    cl.id AS id_client,
    co.date_commande,
    cl.date_inscription
FROM commande co
JOIN client cl
    ON co.client_id = cl.id
WHERE co.date_commande < cl.date_inscription;

SELECT
    COUNT(*) AS nombre_anomalies
FROM commande co
JOIN client cl
    ON co.client_id = cl.id
WHERE co.date_commande < cl.date_inscription;

--Exercice-14 Produits sans vente

SELECT
    pr.id,
    pr.nom,
    pr.categorie,
    pr.prix,
    pr.stock
FROM produit pr
LEFT JOIN ligne_commande lico
    ON pr.id = lico.produit_id
WHERE lico.produit_id IS NULL;
<<<<<<< HEAD
>>>>>>> 6758406301bcef84d286718f246bedbce0e3c684
=======





--Exercice-15 Indicateur Clé 
--Nombre de ligne a chque table
SELECT 'client' AS table_name, COUNT(*) AS nb_lignes FROM client
UNION                                                                  
SELECT 'produit', COUNT(*) FROM produit
UNION    
SELECT 'commande', COUNT(*) FROM commande
UNION                                               
SELECT 'ligne_commande', COUNT(*) FROM ligne_commande;


--Colones et type de données 
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name;


--B.1 analyse commerciale en une seule requete 
WITH montant_commandes AS (
    SELECT
        c.id AS commande_id,
        c.client_id,
        c.statut,
        SUM(lc.quantite * lc.prix_unitaire) AS montant_commande
    FROM commande AS c
    JOIN ligne_commande AS lc
        ON lc.commande_id = c.id
    GROUP BY
        c.id,
        c.client_id,
        c.statut
)
SELECT
    ROUND(SUM(montant_commande), 2)
        AS chiffre_affaires_total,
    COUNT(*) AS nombre_commandes,
    ROUND(AVG(montant_commande), 2)
        AS panier_moyen,
    COUNT(DISTINCT client_id)
        AS nombre_clients_actifs
FROM montant_commandes
WHERE statut <> 'annulée';

--B.2 Taux annulation des commandes
SELECT
    COUNT(*) AS nombre_total_commandes,
    COUNT(*) FILTER (
        WHERE statut = 'annulée'
    ) AS nombre_commandes_annulees,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE statut = 'annulée')
        / NULLIF(COUNT(*), 0),
        2
    ) AS taux_annulation_pourcentage
FROM commande;

>>>>>>> d9e5dd7e7e0a4be27a80f4c69174dc41bdb43ffb


-- D. Synthèse mensuelle

CREATE TABLE synthese_mensuelle AS
SELECT
    DATE_FORMAT(c.date_commande, '%Y-%m') AS mois,
    COUNT(DISTINCT c.id) AS nombre_commandes,
    SUM(lc.quantite * lc.prix_unitaire) AS chiffre_affaires,
    ROUND(
        SUM(lc.quantite * lc.prix_unitaire) / COUNT(DISTINCT c.id),
        2
    ) AS panier_moyen
FROM commandes c
JOIN lignes_commande lc
    ON c.id = lc.commande_id
WHERE c.statut <> 'annulée'
GROUP BY DATE_FORMAT(c.date_commande, '%Y-%m')
ORDER BY mois;



--Partie 7

-- 1) Quel est le prix moyen payé par catégorie ?

--Certaines catégorie sont-elles plus attractive que d'autres

--Pour réaliser cette analyse, on aurait besoin de la table produit et de la table ligne_commande

SELECT
pr.categorie,
ROUND(AVG(lico.prix_unitaire), 2) AS prix_moyen_paye
FROM produit pr
JOIN ligne_commande lico
ON pr.id = lico.produit_id
GROUP BY pr.categorie
ORDER BY prix_moyen_paye DESC;

--Certaines catégories on des produits plus cher que d'autres tandis que certaines catégorie vendent plus de produits.

--Cela permet à l'entreprise de prioriser les catégories les plus rentables.


-- 2) Quels clients commandent le plus souvent ?

--Pour réaliser cette analyse il nous faut le table client ainsi que la table commande.

SELECT
cl.id,
cl.nom,
cl.prenom,
COUNT(co.id) AS nombre_commandes
FROM client cl
LEFT JOIN commande co
ON cl.id = co.client_id
GROUP BY cl.id, cl.nom, cl.prenom
ORDER BY nombre_commandes DESC;

--On observe qu'il y a des clients beaucoup plus actif que d'autres, on peut faire trois catégorie de clients :
--clients actif, client occasionnels et première commande.

--Cela peut permettre à l'entreprise de mettre en place un programme de fidélité ou de faire des promotions pours les premières commande ou clients peu actif pour les insister à consommer.


-- 1)Quels produits sont le plus souvent commandés ensemble ?

--Pour cette analyse on aurait besoin de la table ligne_commande et produit.

SELECT
    p1.nom AS produit_1,
    p2.nom AS produit_2,
    COUNT(*) AS nombre_associations
FROM ligne_commande lico1
JOIN ligne_commande lico2
    ON lico1.commande_id = lico2.commande_id
    AND lico1.produit_id < lico2.produit_id
JOIN produit p1
    ON lico1.produit_id = p1.id
JOIN produit p2
    ON lico2.produit_id = p2.id
GROUP BY p1.nom, p2.nom
ORDER BY nombre_associations DESC; 	

--Cela permet à l'entreprise de crée des packages deal et optimiser les recommandations du site