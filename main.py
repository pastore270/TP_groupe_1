from utils.execute_sql_file import execute_sql_file
from src.database import get_connection


def main():

    print("Test de la connexion:")
    try:
        connection = get_connection()
        print("Connexion à PostgreSQL réussie !")
        print("Base :", connection.info.dbname)
        print("Utilisateur :", connection.info.user)
        print("Hôte :", connection.info.host)
        print("Port :", connection.info.port)

        connection.close()

    except Exception as e:
        print("Échec de la connexion.")
        print(f"Erreur : {e}")
        print("Vérifiez votre fichier .env et que PostgreSQL est démarré.")
        quit()


    print("Création des tables :")
    execute_sql_file("sql/create_schema.sql")
    print("Insertion des données...")
    execute_sql_file("sql/seed_ecommerce.sql")
    print("Base de données initialisée avec succès.")
    execute_sql_file("sql/analysis.sql")
    print("Base de données analysée avec succès.")


if __name__ == "__main__":
    main()
