-- procedure pour changer le nom et le prenom d'un collectionneur partant de son ID
CREATE OR REPLACE PROCEDURE P06_EditerDonnees(
    p_CollectionneurID IN INT,
    p_NouveauNom IN VARCHAR,
    p_NouveauPrenom IN VARCHAR
)
IS
BEGIN
    UPDATE P06_Collectionneur
    SET CollectionneurNom = p_NouveauNom, CollectionneurPrenom = p_NouveauPrenom
    WHERE CollectionneurID = p_CollectionneurID;

EXCEPTION
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la modification.');
        -- si exception, garder la base de donnée dans l'état d'avant (ne pas
        -- appliquer
        -- les changement)
        ROLLBACK;
END;
/


-- function qui retourne la valeur d'un modele de piece partant de son ID
CREATE OR REPLACE FUNCTION P06_ObtenirValeur(
    p_PieceID IN INT
)
RETURN NUMBER
IS
    v_Valeur INT;
BEGIN
    SELECT PieceValeur INTO v_Valeur
    FROM P06_PieceModele
    WHERE PieceID = p_PieceID;

    RETURN v_Valeur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
        -- ou bien on retourne -1
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la selection.');
        RETURN NULL;
END;
/

-- pour les fonction "table" on doit créer un type sous oracle
CREATE TYPE rec_P06_PieceModele AS OBJECT(PieceID INT, PieceVersion VARCHAR(200), PieceValeur INTEGER, PieceDateFrappee DATE, PieceQuantiteFrappee NUMBER);
CREATE TYPE set_piece_modele AS TABLE OF rec_P06_PieceModele;

-- function qui retroune un ensemble de piece produite dans un pays donnée
CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParPays(
    p_PaysNom IN VARCHAR
)
RETURN set_piece_modele PIPELINED
IS
    line P06_PieceModele%ROWTYPE;
    row rec_P06_PieceModele := rec_P06_PieceModele(NULL, NULL, NULL, NULL, NULL);
BEGIN
    FOR line IN (
        SELECT *
        FROM P06_PieceModele
        WHERE PieceID IN (
            SELECT PieceID
            FROM P06_PiecePays
            WHERE PaysNom = p_PaysNom
        )
    ) LOOP
        row.PieceID := line.PieceID;
        row.PieceVersion := line.PieceVersion;
        row.PieceValeur := line.PieceValeur;
        row.PieceDateFrappee := line.PieceDateFrappee;
        row.PieceQuantiteFrappee := line.PieceQuantiteFrappee;
        PIPE ROW (row);
    END LOOP;

    RETURN;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN;
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la selection.');
        RETURN;
END;
/

-- fonction qui retourne un ensemble de piece par interval de taille
CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParTaille(
    p_TailleMin IN NUMBER,
    p_TailleMax IN NUMBER
)
RETURN set_piece_modele PIPELINED
IS
    line P06_PieceModele%ROWTYPE;
    row rec_P06_PieceModele := rec_P06_PieceModele(NULL, NULL, NULL, NULL, NULL);

    CURSOR v_Cursor (tmin NUMBER, tmax NUMBER) IS (
        SELECT *
        FROM P06_PieceModele
        WHERE PieceID IN (
            SELECT PieceID
            FROM P06_PieceCaracteristique
            WHERE PieceTaille BETWEEN tmin AND tmax
        )
    );

BEGIN

    FOR line in v_Cursor(p_TailleMin, p_TailleMax)
    LOOP
        row.PieceID := line.PieceID;
        row.PieceVersion := line.PieceVersion;
        row.PieceValeur := line.PieceValeur;
        row.PieceDateFrappee := line.PieceDateFrappee;
        row.PieceQuantiteFrappee := line.PieceQuantiteFrappee;
        PIPE ROW(row);
    END LOOP;

    RETURN;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN;
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la selection.');
        RETURN;
END;
/