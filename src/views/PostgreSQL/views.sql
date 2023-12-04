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

