DROP TABLE P06_PieceCaracteristique CASCADE CONSTRAINTS;
DROP SEQUENCE seq_caracteristique;

CREATE SEQUENCE seq_caracteristique;

CREATE TABLE P06_PieceCaracteristique (
    CaracteristiqueID INT DEFAULT seq_caracteristique.nextval PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceFaceCommune VARCHAR(250) NOT NULL,
    PieceMasse INTEGER CHECK (0 < PieceMasse) NOT NULL,
    PieceTaille INTEGER CHECK (0 < PieceTaille) NOT NULL,
    PieceMateriau VARCHAR(250) NOT NULL
);
