
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

-- PROTOTYPE
-- Trigger avant INSERT sur P06_Collectionner qui a pour but de incrémenter la valeur
-- qteCollection si le couple PieceID et CollectionneurID est déjà dans la table
/**
CREATE OR REPLACE TRIGGER P06_before_insert_collectionner_trigger
BEFORE INSERT ON P06_Collectionner
FOR EACH ROW
DECLARE
    line P06_Collectionner%ROWTYPE;
BEGIN
    FOR line IN ( SELECT *
    FROM P06_Collectionner
    WHERE CollectionneurID = :NEW.CollectionneurID AND PieceID = :NEW.PieceID)
    LOOP
        IF line.PieceID IS NOT NULL THEN
            UPDATE P06_Collectionner
            SET QteCollection = QteCollection + :NEW.QteCollection
            WHERE CollectionneurID = :NEW.CollectionneurID AND PieceID = :NEW.PieceID;

            :NEW.CollectionneurID := NULL;
            :NEW.PieceID := NULL;
            :NEW.QteCollection := NULL;

        ELSE
            RETURN;
        END IF;
    END LOOP;
END;
*/
