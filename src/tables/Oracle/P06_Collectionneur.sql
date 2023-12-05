DROP TABLE P06_Collectionneur CASCADE CONSTRAINTS;
DROP SEQUENCE seq_collectionneur;

CREATE SEQUENCE seq_collectionneur;

CREATE TABLE P06_Collectionneur (
    CollectionneurID INT DEFAULT seq_collectionneur.nextval PRIMARY KEY,
    CollectionneurNom VARCHAR(250) NOT NULL,
    CollectionneurPrenom VARCHAR(250) NOT NULL
);
