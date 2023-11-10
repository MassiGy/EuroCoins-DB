DROP TABLE IF EXISTS P06_PieceCaracteristique CASCADE;

CREATE TABLE P06_PieceCaracteristique (
    CaracteristiqueID INT PRIMARY KEY AUTO_INCREMENT,
    PieceID INT NOT NULL,
    PieceFaceCommune VARCHAR(250) NOT NULL,
    PieceMasse INT CHECK (0 < PieceMasse) NOT NULL,
    PieceTaille INT CHECK (0 < PieceTaille) NOT NULL,
    PieceMateriau VARCHAR(250) NOT NULL,

    FOREIGN KEY (PieceID) REFERENCES P06_PieceModele(PieceID)
);
