
DROP TABLE IF EXISTS ligne_commande CASCADE;
DROP TABLE IF EXISTS commande CASCADE;
DROP TABLE IF EXISTS produit CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TYPE IF EXISTS statut CASCADE;


CREATE TYPE statut AS ENUM (
    'payée',
    'expédiée',
    'livrée',
    'annulée'
);


CREATE TABLE client (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ville VARCHAR(50) NOT NULL,
    date_inscription DATE NOT NULL
);



CREATE TABLE produit (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    categorie VARCHAR(50) NOT NULL,
    prix DECIMAL(10,2) NOT NULL CHECK (prix >= 0),
    stock INT NOT NULL CHECK (stock >= 0)
);


CREATE TABLE commande (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INT NOT NULL,
    date_commande DATE NOT NULL,
    statut statut NOT NULL,

    CONSTRAINT fk_commande_client
        FOREIGN KEY (client_id)
        REFERENCES client(id)
);



CREATE TABLE ligne_commande (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    commande_id INT NOT NULL,
    produit_id INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire DECIMAL(10,2) NOT NULL CHECK (prix_unitaire >= 0),

    CONSTRAINT fk_ligne_commande
        FOREIGN KEY (commande_id)
        REFERENCES commande(id),

    CONSTRAINT fk_ligne_produit
        FOREIGN KEY (produit_id)
        REFERENCES produit(id)
);