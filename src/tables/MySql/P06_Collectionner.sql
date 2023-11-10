DROP TABLE IF EXISTS P06_Collectionner CASCADE;

CREATE TABLE P06_Collectionner (

    CollectionneurID INT NOT NULL,
    PieceID INT NOT NULL,
    QteCollection INT CHECK (0 < QteCollection) NOT NULL,
    

    FOREIGN KEY (PieceID) REFERENCES P06_PieceModele(PieceID),
    FOREIGN KEY (CollectionneurID) REFERENCES P06_Collectionneur(CollectionneurID),

    PRIMARY KEY(CollectionneurID, PieceID)
);
