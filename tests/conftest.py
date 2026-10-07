import pytest

from src.database import get_connection


@pytest.fixture(scope="session")
def connexion():
    connection = get_connection()
    yield connection
    connection.close()


@pytest.fixture
def curseur(connexion):
    with connexion.cursor() as cursor:
        yield cursor
    connexion.rollback()
