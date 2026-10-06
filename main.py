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
    execute_sql_file("sql/seed.sql")
    print("Base de données initialisée avec succès.")

    try:

        connection = get_connection()

        with connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM proprietaire;")
            print("Propriétaires :", cursor.fetchone()[0])

            cursor.execute("SELECT COUNT(*) FROM logement;")
            print("Logements :", cursor.fetchone()[0])

            cursor.execute("SELECT COUNT(*) FROM locataire;")
            print("Locataires :", cursor.fetchone()[0])

            cursor.execute("SELECT COUNT(*) FROM location;")
            print("Locations :", cursor.fetchone()[0])

        connection.close()

    except Exception as e:
        print(f"Erreur lors de la vérification : {e}")


if __name__ == "__main__":
    main()
