DROP TABLE IF EXISTS P06_PieceModele CASCADE;

CREATE TABLE P06_PieceModele (
    PieceID SERIAL PRIMARY KEY,
    PieceVersion VARCHAR(250) NOT NULL,
    PieceValeur INTEGER CHECK (0 < PieceValeur) NOT NULL,
    PieceDateFrappee DATE NOT NULL,
    PieceQuantiteFrappee BIGINT NOT NULL
);
