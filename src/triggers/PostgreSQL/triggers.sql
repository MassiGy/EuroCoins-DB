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





