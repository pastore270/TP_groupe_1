from pathlib import Path

from src.database import get_connection


def execute_sql_file(file_path: str):

    path = Path(file_path).resolve()

    print(f"\n→ Exécution du fichier : {path}")

    sql = path.read_text(encoding="utf-8")

    if not sql.strip():
        raise ValueError(f"Le fichier SQL est vide : {path}")

    requetes = sql.split(";")

    with get_connection() as connection:
        with connection.cursor() as cursor:

            for numero, requete in enumerate(requetes, start=1):

                requete = requete.strip()

                if not requete:
                    continue

                cursor.execute(requete)

                if cursor.description:

                    print(f"\n===== Résultat requête {numero} =====")

                    colonnes = [
                        colonne[0]
                        for colonne in cursor.description
                    ]

                    print(" | ".join(colonnes))
                    print("-" * 80)

                    resultats = cursor.fetchall()

                    for ligne in resultats:
                        print(
                            " | ".join(
                                str(valeur)
                                for valeur in ligne
                            )
                        )

        connection.commit()