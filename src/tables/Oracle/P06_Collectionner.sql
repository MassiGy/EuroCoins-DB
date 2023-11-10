DROP TABLE P06_Collectionner CASCADE CONSTRAINTS;

CREATE TABLE P06_Collectionner (
    CollectionneurID INTEGER REFERENCES P06_Collectionneur(CollectionneurID),
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    QteCollection INTEGER CHECK (0 < QteCollection) NOT NULL,
    
    PRIMARY KEY(CollectionneurID, PieceID)
);
