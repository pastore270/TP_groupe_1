CREATE TABLE Clients (
    id_client INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ville VARCHAR(50) NOT NULL,
    date_inscription DATE NOT NULL
);

CREATE TABLE Produits ( 
    id_produit INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    prix_actuel DECIMAL(10,2) NOT NULL CHECK (prix_actuel >= 0),
    stock_disponible INT NOT NULL CHECK (stock_disponible >= 0)
);

CREATE TABLE Commandes (
    id_commande INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_client INT NOT NULL,
    date_commande DATE NOT NULL,
    statut ENUM('payee', 'expediee', 'livree', 'annulee') NOT NULL,

    CONSTRAINT fk_commande_client
        FOREIGN KEY (id_client)
        REFERENCES clients(id_client)
);

CREATE TABLE Lignes_commande (
    id_ligne INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_commande INT NOT NULL,
    id_produit INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire_paye DECIMAL(10,2) NOT NULL CHECK (prix_unitaire_paye >= 0),

    CONSTRAINT fk_ligne_commande
        FOREIGN KEY (id_commande)
        REFERENCES commandes(id_commande),

    CONSTRAINT fk_ligne_produit
        FOREIGN KEY (id_produit)
        REFERENCES produits(id_produit)
);