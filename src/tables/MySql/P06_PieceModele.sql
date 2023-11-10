DROP TABLE IF EXISTS P06_PieceModele CASCADE;

CREATE TABLE P06_PieceModele (
    PieceID INT PRIMARY KEY AUTO_INCREMENT,
    PieceVersion VARCHAR(250) NOT NULL,
    PieceValeur INT CHECK (0 < PieceValeur) NOT NULL, 
    PieceDateFrappee DATE NOT NULL, 
    PieceQuantiteFrappee BIGINT CHECK (0 < PieceQuantiteFrappee) NOT NULL
);
