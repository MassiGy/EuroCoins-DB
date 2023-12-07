-- Start by creating the database
-- CREATE DATABASE IF NOT EXISTS P06_Euro;

-- switch to it
-- \c P06_Euro;

/** Works only on PostgreSQL command prompt but not on DataGrip IDE

-- CREATE THE TABLES;
\i  ../tables/PostgreSQL/P06_PieceModele.sql;
\i  ../tables/PostgreSQL/P06_PieceCaracteristique.sql;
\i  ../tables/PostgreSQL/P06_PieceTranche.sql;
\i  ../tables/PostgreSQL/P06_PiecePays.sql;
\i  ../tables/PostgreSQL/P06_Collectionneur.sql;



-- CREATE THE JUNCTION TABLES;
\i  ../tables/PostgreSQL/P06_Collectionner.sql;

-- CREATE THE VIEWS
\i  ../views/PostgreSQL/views.sql;

-- INSERT THE DATA (note: you can insert before
-- creating the triggers to speed things up)
\i  ../inserts/P06_AlimentationPostgresql.sql;

-- CREATE THE FUNCTIONS
\i  ../functions/PostgreSQL/functions.sql;

-- CREATE THE TRIGGERS
\i  ../triggers/PostgreSQL/triggers.sql;

*/

-- Instead on DataGrip IDE, we just put all the creations scripts in raw
-- on one file without the insertions cause we already have one

DROP TABLE IF EXISTS P06_PieceModele CASCADE;

CREATE TABLE P06_PieceModele (
    PieceID SERIAL PRIMARY KEY,
    PieceVersion VARCHAR(250) NOT NULL,
    PieceValeur INTEGER CHECK (0 < PieceValeur) NOT NULL,
    PieceDateFrappee DATE NOT NULL,
    PieceQuantiteFrappee BIGINT NOT NULL
);

DROP TABLE IF EXISTS P06_PieceCaracteristique CASCADE;

CREATE TABLE P06_PieceCaracteristique (
    CaracteristiqueID SERIAL PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceFaceCommune VARCHAR(250) NOT NULL,
    PieceMasse INTEGER CHECK (0 < PieceMasse) NOT NULL,
    PieceTaille INTEGER CHECK (0 < PieceTaille) NOT NULL,
    PieceMateriau VARCHAR(75) NOT NULL
);

DROP TABLE IF EXISTS P06_PiecePays CASCADE;

CREATE TABLE P06_PiecePays(
    PaysID SERIAL PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PaysNom VARCHAR(250) NOT NULL
);

DROP TABLE IF EXISTS P06_PieceTranche CASCADE;

CREATE TABLE P06_PieceTranche (
    TrancheID SERIAL PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceTranche VARCHAR(250) NOT NULL
);

DROP TABLE IF EXISTS P06_Collectionneur CASCADE;

CREATE TABLE P06_Collectionneur (
    CollectionneurID SERIAL PRIMARY KEY,
    CollectionneurNom VARCHAR(250) NOT NULL,
    CollectionneurPrenom VARCHAR(250) NOT NULL
);

DROP TABLE IF EXISTS P06_Collectionner CASCADE;

CREATE TABLE P06_Collectionner (
    CollectionneurID INTEGER NOT NULL,
    PieceID INTEGER NOT NULL,
    QteCollection INTEGER CHECK (0 < QteCollection) NOT NULL,


    FOREIGN KEY (PieceID) REFERENCES P06_PieceModele(PieceID),
    FOREIGN KEY (CollectionneurID) REFERENCES P06_Collectionneur(CollectionneurID),

    PRIMARY KEY(CollectionneurID, PieceID)
);

-- Cette vue donne les informations sur les collectionneurs associé à leur nombre de pièces
CREATE OR REPLACE VIEW P06_CollectionneursInfos AS
    SELECT C.*, SUM(QteCollection) AS NbPiece
    FROM P06_Collectionneur AS C
    LEFT JOIN P06_Collectionner
        ON C.CollectionneurID = P06_Collectionner.CollectionneurID
    GROUP BY C.CollectionneurID;

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




-- changer le nom et le prenom d'un collectionneur
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



-- trouver la valeur d'une piece partant de son identifiant
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


-- trouver toutes les piece produites par un pays donnée
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



-- trouver toutes les pieces qui ont une taille entre deux valeurs données
CREATE OR REPLACE FUNCTION P06_ObtenirPiecesParTaille(
    p_TailleMin INTEGER,
    p_TailleMax INTEGER
)
RETURNS SETOF P06_PieceModele AS $$
DECLARE
    row P06_PieceModele;
    cursor CURSOR (tmin INTEGER, tmax INTEGER) FOR (
        SELECT *
        FROM P06_PieceModele
        WHERE PieceID IN (
            SELECT PieceID
            FROM P06_PieceCaracteristique
            WHERE PieceTaille BETWEEN tmin AND tmax
        )
    );

BEGIN

    FOR row in cursor(p_TailleMin, p_TailleMax)
    LOOP
        RETURN NEXT row;
    END LOOP;

    RETURN;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Aucun enregistrements trouvés avec l''interval de tailles indiqué.';
        RETURN;
    WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de la selections.';
        RETURN;
END;
$$ LANGUAGE plpgsql;


/************************************* TRIGGER SUR TOUTE LA LIGNE EDITÉE             */

-- Trigger avant INSERT sur P06_Collectionneur
CREATE OR REPLACE FUNCTION P06_before_insert_collectionneur()
RETURNS TRIGGER AS $$
BEGIN
    -- Insérer des actions ou vérifications avant l'insertion d'une nouvelle ligne
    -- Exemple : vérification des valeurs ou manipulation des données

    -- Pour l'exemple, afficher un message avant l'insertion
    RAISE NOTICE 'Insertion d''un nouveau collectionneur avec nom : % et prénom : %', NEW.CollectionneurNom, NEW.CollectionneurPrenom;

    -- Vous pouvez effectuer d'autres opérations ici

    -- Renvoyer la nouvelle ligne à insérer
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger avant INSERT
CREATE TRIGGER P06_before_insert_collectionneur_trigger
BEFORE INSERT ON P06_Collectionneur
FOR EACH ROW
EXECUTE FUNCTION P06_before_insert_collectionneur();


-- Trigger avant UPDATE sur P06_PieceModele
CREATE OR REPLACE FUNCTION P06_before_update_piece_modele()
RETURNS TRIGGER AS $$
BEGIN
    -- Actions avant la mise à jour d'une ligne
    -- Exemple : vérifications ou modifications des valeurs

    -- Pour l'exemple, afficher un message avant la mise à jour
    RAISE NOTICE 'Mise à jour de la pièce avec ID : %', NEW.PieceID;

    -- Vous pouvez effectuer d'autres opérations ici

    -- Renvoyer la ligne à mettre à jour
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger avant UPDATE
-- (NOTE: CREATE OR REPLACE ne marche pas sur toutes les versions
-- de postgresql.)
CREATE TRIGGER P06_before_update_piece_modele_trigger
BEFORE UPDATE ON P06_PieceModele
FOR EACH ROW
EXECUTE FUNCTION P06_before_update_piece_modele();


/************************************* TRIGGER SUR TOUTES LES LIGNES ÉDITÉES ***********/

-- Trigger après INSERT sur P06_PieceModele
CREATE OR REPLACE FUNCTION P06_after_insert_piece_modele()
RETURNS TRIGGER AS $$
DECLARE
    moyenneVals Real;
BEGIN
    -- recalcule de la moyenne des valeurs.
    SELECT AVG(PieceValeur)
    INTO moyenneVals
    FROM P06_PieceModele;

    -- afficher cela dans un message
    RAISE NOTICE 'Nouvelle moyenne des valeurs: %', moyenneVals;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger après INSERT
CREATE TRIGGER P06_after_insert_piecemodele_trigger
AFTER INSERT ON P06_PieceModele
FOR EACH STATEMENT
EXECUTE FUNCTION P06_after_insert_piece_modele();