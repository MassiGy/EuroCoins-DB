-- Trigger avant INSERT sur P06_Collectionneur
CREATE OR REPLACE FUNCTION before_insert_collectionneur()
RETURNS TRIGGER AS $$
BEGIN
    -- Insérer des actions ou vérifications avant l'insertion d'une nouvelle ligne
    -- Exemple : vérification des valeurs ou manipulation des données
    
    -- Pour l'exemple, afficher un message avant l'insertion
    RAISE NOTICE 'Insertion d\'un nouveau collectionneur avec nom : % et prénom : %', NEW.CollectionneurNom, NEW.CollectionneurPrenom;
    
    -- Vous pouvez effectuer d'autres opérations ici
    
    -- Renvoyer la nouvelle ligne à insérer
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger avant INSERT
CREATE TRIGGER before_insert_collectionneur_trigger
BEFORE INSERT ON P06_Collectionneur
FOR EACH ROW
EXECUTE FUNCTION before_insert_collectionneur();


-- Trigger après INSERT sur P06_Collectionneur
CREATE OR REPLACE FUNCTION after_insert_collectionneur()
RETURNS TRIGGER AS $$
BEGIN
    -- Actions à effectuer après l'insertion d'une nouvelle ligne
    -- Exemple : mise à jour d'autres tables ou enregistrement d'informations
    
    -- Pour l'exemple, afficher un message après l'insertion
    RAISE NOTICE 'Nouveau collectionneur inséré avec ID : %', NEW.CollectionneurID;
    
    -- Vous pouvez effectuer d'autres opérations ici
    
    -- Renvoyer la nouvelle ligne insérée
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger après INSERT
CREATE TRIGGER after_insert_collectionneur_trigger
AFTER INSERT ON P06_Collectionneur
FOR EACH ROW
EXECUTE FUNCTION after_insert_collectionneur();


-- Trigger avant UPDATE sur P06_PieceModele
CREATE OR REPLACE FUNCTION before_update_piece_modele()
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
CREATE TRIGGER before_update_piece_modele_trigger
BEFORE UPDATE ON P06_PieceModele
FOR EACH ROW
EXECUTE FUNCTION before_update_piece_modele();


-- Trigger après UPDATE sur P06_PieceModele
CREATE OR REPLACE FUNCTION after_update_piece_modele()
RETURNS TRIGGER AS $$
BEGIN
    -- Actions après la mise à jour d'une ligne
    -- Exemple : enregistrement d'informations ou mises à jour associées
    
    -- Pour l'exemple, afficher un message après la mise à jour
    RAISE NOTICE 'Mise à jour effectuée pour la pièce avec ID : %', NEW.PieceID;
    
    -- Vous pouvez effectuer d'autres opérations ici
    
    -- Renvoyer la ligne mise à jour
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger après UPDATE
CREATE TRIGGER after_update_piece_modele_trigger
AFTER UPDATE ON P06_PieceModele
FOR EACH ROW
EXECUTE FUNCTION after_update_piece_modele();
