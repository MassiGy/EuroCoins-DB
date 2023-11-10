DROP TABLE P06_PieceModele CASCADE CONSTRAINTS;
DROP SEQUENCE seq_pieceModele;

CREATE SEQUENCE seq_pieceModele;

CREATE TABLE P06_PieceModele (
    PieceID INT DEFAULT seq_pieceModele.nextval PRIMARY KEY,
    PieceVersion VARCHAR(250) NOT NULL,
    PieceValeur INTEGER CHECK (0 < PieceValeur) NOT NULL,
    PieceDateFrappee DATE NOT NULL,
    PieceQuantiteFrappee NUMBER NOT NULL
);