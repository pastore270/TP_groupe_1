from pathlib import Path

from src.database import get_connection


def execute_sql_file(file_path: str):

    path = Path(file_path).resolve()

    print(f"\n→ Exécution du fichier : {path}")
    print(f"→ Fichier existe : {path.exists()}")

    sql = path.read_text(encoding="utf-8")

    print(f"→ Taille du fichier : {len(sql)} caractères")

    if not sql.strip():
        raise ValueError(f"Le fichier SQL est vide : {path}")

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(sql)

        connection.commit()
