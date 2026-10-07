Projet e-commerce SQL

Ce projet met en place une base de données PostgreSQL pour une boutique en ligne simple et l'alimente avec des données de démonstration. Il contient aussi une série de requêtes SQL d'analyse métier permettant d'explorer les ventes, les clients, les produits et les commandes.

Objectif

L'objectif principal est de :

- créer le schéma de données d'un e-commerce,
- alimenter la base avec des données de test,
- vérifier la connexion à PostgreSQL,
- exécuter des requêtes analytiques pour répondre à des besoins métiers.

Structure du projet

TP_groupe/
├── .env.example
├── main.py
├── pyproject.toml
├── src/
│ └── database.py
├── sql/
│ ├── create_schema.sql
│ ├── seed_ecommerce.sql
│ └── analysis.sql
├── utils/
│ └── execute_sql_file.py
├── README.md
└── uv.lock

Base de données

Le schéma comprend 4 tables principales :

- client
- produit
- commande
- ligne_commande

Les scripts SQL permettent de :

1. supprimer et recréer les tables ;
2. charger des données de test ;
3. lancer des analyses de ventes et de comportement client.
Prérequis

- Python 3.13+
- PostgreSQL installé et démarré
- un utilisateur PostgreSQL valide
- un fichier .env configuré

Installation

Avec uv

uv sync

Avec pip

pip install -r requirements.txt

Configuration de la base

cp .env.example .env

Puis modifiez .env :

DB_HOST=localhost
DB_PORT=5432
DB_NAME=nom_de_la_base
DB_USER=votre_utilisateur
DB_PASSWORD=votre_mot_de_passe

Lancement du projet

python main.py

Ou :

uv run python main.py

Requêtes d'analyse incluses

Le fichier analysis.sql couvre :

- stock des produits
- produits > 100 €
- clients par ville
- détails des commandes
- montant total
- chiffre d'affaires par catégorie
- produits les plus vendus
- analyse mensuelle
- anomalies de date
- produits jamais vendus

Exemples SQL

Clients par ville

SELECT ville, COUNT(id) AS nombre_clients
FROM client
GROUP BY ville
ORDER BY nombre_clients DESC;

SELECT
c.id AS commande_id,
c.date_commande,
c.statut,
ROUND(SUM(lc.quantite \* lc.prix_unitaire), 2) AS montant_total
FROM commande AS c
JOIN ligne_commande AS lc ON lc.commande_id = c.id
GROUP BY c.id, c.date_commande, c.statut
ORDER BY c.date_commande, c.id;

Dépannage

Connexion PostgreSQL

- PostgreSQL démarré
- nom de base correct
- identifiants valides
- présence du .env

Erreurs SQL

- droits PostgreSQL
- existence de la base
- compatibilité de version

Technologies

- Python 3.13
- PostgreSQL
- psycopg
- python-dotenv
- pytest

Licence

Projet pédagogique.

Auteurs : GROUPE 1
Benjamin, Mohamed, Mehdi, Steven, Dioman et Houcham
Projet réalisé dans le cadre d'un travail d'équipe sur l'analyse de données et la gestion SQL.
