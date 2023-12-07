--- DROP ALL THE TRIGGERS IF ANY 
DROP TRIGGER IF EXISTS P06_before_insert_collectionneur_trigger 
ON P06_Collectionneur;

DROP TRIGGER IF EXISTS P06_before_update_piece_modele_trigger
ON P06_PieceModele;

DROP TRIGGER IF EXISTS P06_after_insert_piecemodele_trigger
ON P06_PieceModele;

--- DROP ALL THE FUNCTIONS IF ANY 
DROP FUNCTION IF EXISTS P06_before_insert_collectionneur;
DROP FUNCTION IF EXISTS P06_before_update_piece_modele;
DROP FUNCTION IF EXISTS P06_after_insert_piece_modele;
DROP PROCEDURE IF EXISTS PO6_EditerDonnees;
DROP FUNCTION IF EXISTS P06_ObtenirValeur;
DROP FUNCTION IF EXISTS P06_ObtenirPiecesParPays;
DROP FUNCTION IF EXISTS P06_ObtenirPiecesParTaille;



--- DROP ALL THE VIEWS IF ANY
DROP VIEW IF EXISTS P06_CollectionneursInfos;
DROP VIEW IF EXISTS P06_PiecesNonPossedees;
DROP VIEW IF EXISTS P06_PieceInfos;



--- DROP ALL THE JUNCTION TABLES IF ANY
DROP TABLE IF EXISTS P06_Collectionner;

--- DROP ALL THE TABLES IF ANY
DROP TABLE IF EXISTS P06_Collectionneur;
DROP TABLE IF EXISTS P06_PieceCaracteristique ;
DROP TABLE IF EXISTS P06_PiecePays;
DROP TABLE IF EXISTS P06_PieceTranche ;
DROP TABLE IF EXISTS P06_PieceModele ;

--- DROP THE DATABASE
-- DROP DATABASE P06_Euro;




