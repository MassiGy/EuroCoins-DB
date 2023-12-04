CREATE OR REPLACE PROCEDURE P06_EditerDonnees(
    p_CollectionneurID IN NUMBER,
    p_NouveauNom IN VARCHAR,
    p_NouveauPrenom IN VARCHAR
)
IS
BEGIN
    UPDATE P06_Collectionneur
    SET CollectionneurNom = p_NouveauNom, CollectionneurPrenom = p_NouveauPrenom
    WHERE CollectionneurID = p_CollectionneurID;
    COMMIT;
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


CREATE OR REPLACE FUNCTION P06_ObtenirValeur(
    p_PieceID IN NUMBER
)
RETURNS NUMBER
IS
    v_Valeur NUMBER;
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


CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParPays(
    p_PaysNom IN VARCHAR
)
RETURNS SYS_REFCURSOR
IS
    v_Cursor SYS_REFCURSOR;
BEGIN
    OPEN v_Cursor FOR
    SELECT pm.*
    FROM P06_PieceModele pm
    JOIN P06_PiecePays pp ON pm.PieceID = pp.PieceID
    WHERE pp.PaysNom = p_PaysNom;

    RETURN v_Cursor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la selection.');
        RETURN NULL;
END;
/


CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParTaille(
    p_TailleMin IN NUMBER,
    p_TailleMax IN NUMBER
)
RETURNS SYS_REFCURSOR
IS
    v_Cursor SYS_REFCURSOR;
BEGIN
    OPEN v_Cursor FOR
    SELECT *
    FROM P06_PieceCaracteristique
    WHERE PieceTaille BETWEEN p_TailleMin AND p_TailleMax;

    RETURN v_Cursor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite lors de la selection.');
        RETURN NULL;
END;
/
