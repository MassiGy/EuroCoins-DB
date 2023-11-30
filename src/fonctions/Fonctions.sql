CREATE OR REPLACE PROCEDURE EditerDonnees(
    p_CollectionneurID IN INTEGER,
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
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite : ' || SQLERRM);
        ROLLBACK;
END;
/


CREATE OR REPLACE FUNCTION ObtenirValeur(
    p_PieceID IN INTEGER
)
RETURN INTEGER
IS
    v_Valeur INTEGER;
BEGIN
    SELECT PieceValeur INTO v_Valeur
    FROM P06_PieceModele
    WHERE PieceID = p_PieceID;

    RETURN v_Valeur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        -- Gestion des exceptions : affichage de l'erreur ou traitement spécifique
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite : ' || SQLERRM);
        RETURN NULL;
END;
/


CREATE OR REPLACE FUNCTION ObtenirPiecesParPays(
    p_PaysNom IN VARCHAR
)
RETURN SYS_REFCURSOR
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
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite : ' || SQLERRM);
        RETURN NULL;
END;
/


CREATE OR REPLACE FUNCTION ObtenirPiecesParTaille(
    p_TailleMin IN INTEGER,
    p_TailleMax IN INTEGER
)
RETURN SYS_REFCURSOR
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
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite : ' || SQLERRM);
        RETURN NULL;
END;
/
