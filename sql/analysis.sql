SELECT nom, categorie, prix, stock FROM produit;
SELECT nom, categorie, prix, stock FROM produit WHERE prix > 100;
SELECT * FROM client WHERE ville = 'Paris';
SELECT ville, COUNT(id) AS nombre_clients FROM client GROUP BY ville ORDER BY nombre_clients DESC;
