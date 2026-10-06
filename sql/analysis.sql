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
