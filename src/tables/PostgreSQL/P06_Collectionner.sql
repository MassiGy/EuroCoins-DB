DROP TABLE IF EXISTS P06_Collectionner CASCADE;

CREATE TABLE P06_Collectionner (
    CollectionneurID INTEGER NOT NULL,
    PieceID INTEGER NOT NULL,
    QteCollection INTEGER CHECK (0 < QteCollection) NOT NULL,
    

    FOREIGN KEY (PieceID) REFERENCES P06_PieceModele(PieceID),
    FOREIGN KEY (CollectionneurID) REFERENCES P06_Collectionneur(CollectionneurID),

    PRIMARY KEY(CollectionneurID, PieceID)
);
