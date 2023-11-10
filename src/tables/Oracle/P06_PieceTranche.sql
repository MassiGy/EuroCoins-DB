DROP TABLE P06_PieceTranche CASCADE CONSTRAINTS;
DROP SEQUENCE seq_tranche;

CREATE SEQUENCE seq_tranche;

CREATE TABLE P06_PieceTranche (
    TrancheID INT DEFAULT seq_tranche.nextval PRIMARY KEY,
    PieceID INTEGER REFERENCES P06_PieceModele(PieceID),
    PieceTranche VARCHAR(250) NOT NULL
);
