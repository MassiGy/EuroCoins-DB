DROP TABLE IF EXISTS P06_PieceCaracteristique CASCADE;

CREATE TABLE P06_PieceCaracteristique (
    CaracteristiqueID SERIAL PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceFaceCommune VARCHAR(250) NOT NULL,
    PieceMasse INTEGER CHECK (0 < PieceMasse) NOT NULL,
    PieceTaille INTEGER CHECK (0 < PieceTaille) NOT NULL,
    PieceMateriau VARCHAR(75) NOT NULL
);
