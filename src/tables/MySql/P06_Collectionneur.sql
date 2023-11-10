DROP TABLE IF EXISTS P06_Collectionneur CASCADE;

CREATE TABLE P06_Collectionneur (
    CollectionneurID INT PRIMARY KEY AUTO_INCREMENT,
    CollectionneurNom VARCHAR(250) NOT NULL,
    CollectionneurPrenom VARCHAR(250) NOT NULL
);
