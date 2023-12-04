CREATE OR REPLACE PROCEDURE PO6_EditerDonnees(
    p_CollectionneurID INTEGER,
    p_NouveauNom VARCHAR,
    p_NouveauPrenom VARCHAR
) AS $$
BEGIN
    UPDATE P06_Collectionneur
    SET CollectionneurNom = p_NouveauNom, CollectionneurPrenom = p_NouveauPrenom
    WHERE CollectionneurID = p_CollectionneurID;

EXCEPTION 
    WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de la modification. Operation/Transaction ignorée';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION P06_ObtenirValeur(
    p_PieceID INTEGER
)
RETURNS INTEGER AS $$ 
DECLARE 
    v_Valeur INTEGER;
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
        RAISE NOTICE 'Erreur lors de la selection.';
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParPays(
    p_PaysNom VARCHAR
)
RETURNS SETOF P06_PieceModele AS $$
DECLARE
    row P06_PieceModele;
BEGIN

    FOR row IN (SELECT * FROM P06_PieceModele  
                WHERE PieceID IN (
                    SELECT PieceID
                    FROM P06_PiecePays 
                    WHERE PaysNom = p_PaysNom
                 )
             ) 
    LOOP 
        RETURN NEXT row;
    END LOOP;

    RETURN;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Aucun enregistrements trouvés avec le pays indiqué.';
        RETURN;        -- retrouner un ensemble vide
    WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de la selection.';
        RETURN;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParTaille(
    p_TailleMin INTEGER,
    p_TailleMax INTEGER
)
RETURNS SETOF P06_PieceModele AS $$

DECLARE
    row P06_PieceModele ;
    cursor CURSOR (tmin INTEGER, tmax INTEGER) FOR (
        SELECT * 
        FROM P06_PieceModele
        WHERE PieceID IN (
            SELECT PieceID
            FROM P06_PieceCaracteristique
            WHERE PieceTaille BETWEEN tmin AND tmax;
        )
    );
    
BEGIN

    OPEN 







END;
$$ LANGUAGE plpgsql;






CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParTaille(
    p_TailleMin IN INTEGER,
    p_TailleMax IN INTEGER
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









