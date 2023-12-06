-- NOTE: Since Databases are not set the same way in PostgreSQL and Oracle, we
-- can not create a database as easily as we've been able to do in PostgreSQL
-- and Mysql. Thereafter CREATE DATABASE CLAUSE in the current Oracle script
-- will be omitted, and thus the use|\i equivalent will be discarded too.

-- for more: 
-- https://stackoverflow.com/questions/10461861/use-database-command-on-sql-plus-oracle-11gr1

/** Works only on SQLPlus command prompt but not on DataGrip IDE

-- CREATE THE TABLES;
@../tables/Oracle/P06_PieceModele.sql;
@../tables/Oracle/P06_PieceCaracteristique.sql;
@../tables/Oracle/P06_PieceTranche.sql;
@../tables/Oracle/P06_PiecePays.sql;
@../tables/Oracle/P06_Collectionneur.sql;



-- CREATE THE JUNCTION TABLES;
@../tables/Oracle/P06_Collectionner.sql;

-- CREATE THE VIEWS
@../views/Oracle/views.sql;

-- CREATE THE FUNCTIONS
@../functions/Oracle/functions.sql;

-- CREATE THE TRIGGERS
@../triggers/Oracle/triggers.sql;


-- INSERT THE DATA (note: you can insert before
-- creating the triggers to speed things up)
@../inserts/P06_AlimentationOracle.sql;

*/

-- Instead on DataGrip IDE, we just put all the creations scripts in raw
-- on one file without the insertions cause we already have one

CREATE SEQUENCE seq_pieceModele;

CREATE TABLE P06_PieceModele (
    PieceID INT DEFAULT seq_pieceModele.nextval PRIMARY KEY,
    PieceVersion VARCHAR(250) NOT NULL,
    PieceValeur INTEGER CHECK (0 < PieceValeur) NOT NULL,
    PieceDateFrappee DATE NOT NULL,
    PieceQuantiteFrappee NUMBER NOT NULL
);

CREATE SEQUENCE seq_caracteristique;

CREATE TABLE P06_PieceCaracteristique (
    CaracteristiqueID INT DEFAULT seq_caracteristique.nextval PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceFaceCommune VARCHAR(250) NOT NULL,
    PieceMasse INTEGER CHECK (0 < PieceMasse) NOT NULL,
    PieceTaille INTEGER CHECK (0 < PieceTaille) NOT NULL,
    PieceMateriau VARCHAR(250) NOT NULL
);

CREATE SEQUENCE seq_pays;

CREATE TABLE P06_PiecePays(
    PaysID INT DEFAULT seq_pays.nextval PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PaysNom VARCHAR(250) NOT NULL
);

CREATE SEQUENCE seq_tranche;

CREATE TABLE P06_PieceTranche (
    TrancheID INT DEFAULT seq_tranche.nextval PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceTranche VARCHAR(250) NOT NULL
);

CREATE SEQUENCE seq_collectionneur;

CREATE TABLE P06_Collectionneur (
    CollectionneurID INT DEFAULT seq_collectionneur.nextval PRIMARY KEY,
    CollectionneurNom VARCHAR(250) NOT NULL,
    CollectionneurPrenom VARCHAR(250) NOT NULL
);

CREATE TABLE P06_Collectionner (
    CollectionneurID INTEGER REFERENCES P06_Collectionneur(CollectionneurID),
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    QteCollection INTEGER CHECK (0 < QteCollection) NOT NULL,

    PRIMARY KEY(CollectionneurID, PieceID)
);

-- Cette vue donne les informations sur les collectionneurs associé à leur nombre de pièces
CREATE OR REPLACE VIEW P06_CollectionneursInfos AS
    SELECT C.*, SUM(CN.QteCollection) AS NbPiece
    FROM P06_Collectionneur C
    LEFT JOIN P06_Collectionner CN
        ON C.CollectionneurID = CN.CollectionneurID
    GROUP BY C.CollectionneurID, C.CollectionneurNom, C.CollectionneurPrenom;

-- Cette vue donne toutes les informations d'une pièce
CREATE OR REPLACE VIEW P06_PieceInfos AS
    SELECT PM.*, PC.PieceFaceCommune, PC.PieceMasse, PC.PieceTaille, PC.PieceMateriau, PT.PieceTranche, PP.PaysNom
        FROM P06_PieceModele PM
        INNER JOIN P06_PieceCaracteristique PC ON PM.PieceID = PC.PieceID
        INNER JOIN P06_PieceTranche PT ON PM.PieceID = PT.PieceID
        INNER JOIN P06_PiecePays PP ON PM.PieceID = PP.PieceID
    ORDER BY PM.PieceID;

-- Cette vue donne les modeles de pieces qui ne sont pas en possession d'un collectionneur.
CREATE OR REPLACE VIEW P06_PiecesNonPossedees AS
    SELECT *
    FROM P06_PieceModele
    WHERE PieceID NOT IN    (SELECT P06_Collectionner.PieceID
                             FROM P06_Collectionner);



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


/************************************* TRIGGER SUR TOUTE LA LIGNE EDITÉE             */

-- Trigger avant INSERT sur P06_Collectionneur
CREATE OR REPLACE TRIGGER P06_before_insert_collectionneur_trigger
BEFORE INSERT ON P06_Collectionneur
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertion d''un nouveau collectionneur avec nom : ' || :NEW.CollectionneurNom || ' et prénom : ' || :NEW.CollectionneurPrenom);
    RETURN;
END;
/


-- Créer le trigger avant UPDATE
CREATE OR REPLACE TRIGGER P06_before_update_piece_modele_trigger
BEFORE UPDATE ON P06_PieceModele
FOR EACH ROW
BEGIN
    -- Actions avant la mise à jour d'une ligne
    -- Exemple : vérifications ou modifications des valeurs

    -- Pour l'exemple, afficher un message avant la mise à jour
    DBMS_OUTPUT.PUT_LINE('Mise à jour de la pièce avec ID : ' || :NEW.PieceID);

    -- Vous pouvez effectuer d'autres opérations ici

    -- Renvoyer la ligne à mettre à jour
    RETURN;
END;
/


/************************************* TRIGGER SUR TOUTES LES LIGNES    ***********/

-- Trigger après INSERT sur P06_PieceModele
CREATE OR REPLACE TRIGGER P06_after_insert_piecemodele_trigger
AFTER INSERT ON P06_PieceModele
-- FOR EACH STATEMENT           -- pas besoin, ceci est l'action par défaut.
DECLARE
    moyenneVals REAL;
BEGIN
    -- recalcule de la moyenne des valeurs.
    SELECT AVG(PieceValeur)
    INTO moyenneVals
    FROM P06_PieceModele;

    -- afficher cela dans un message
    DBMS_OUTPUT.PUT_LINE('Nouvelle moyenne des valeurs: ' || moyenneVals);
    RETURN;
END;
/

