
-- NOTE: ORACLE DOES NOT SUPPORT 
-- THE IF EXISTS RULE

--- DROP ALL THE TRIGGERS IF ANY 
DROP TRIGGER P06_before_insert_collectionneur_trigger;
DROP TRIGGER P06_before_update_piece_modele_trigger;
DROP TRIGGER P06_after_insert_piecemodele_trigger;

--- DROP ALL THE FUNCTIONS IF ANY 
DROP PROCEDURE P06_EditerDonnees;
DROP FUNCTION P06_ObtenirValeur;
DROP FUNCTION P06_ObtenirPiecesParPays;
DROP FUNCTION P06_ObtenirPiecesParTaille;

-- DROP ALL TYPES IF ANY
DROP TYPE set_piece_modele;
DROP TYPE rec_P06_PieceModele;

--- DROP ALL THE VIEWS IF ANY
DROP VIEW P06_CollectionneursInfos;
DROP VIEW P06_PiecesNonPossedees;
DROP VIEW P06_PieceInfos;



--- DROP ALL THE JUNCTION TABLES IF ANY
DROP TABLE P06_Collectionner;

--- DROP ALL THE TABLES IF ANY
DROP TABLE P06_Collectionneur;
DROP TABLE P06_PieceCaracteristique ;
DROP TABLE P06_PiecePays;
DROP TABLE P06_PieceTranche ;
DROP TABLE P06_PieceModele ;


-- DROP ALL THE SEQUENCES
DROP SEQUENCE seq_collectionneur;
DROP SEQUENCE seq_caracteristique;
DROP SEQUENCE seq_pieceModele;
DROP SEQUENCE seq_pays;
DROP SEQUENCE seq_tranche;


--- DROP THE DATABASE
-- DROP DATABASE P06_Euro;




