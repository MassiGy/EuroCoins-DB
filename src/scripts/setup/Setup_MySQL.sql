-- Start by creating the database
CREATE DATABASE IF NOT EXISTS P06_Euro;

-- switch to it
USE P06_Euro;


-- CREATE THE TABLES;
SOURCE  ../tables/MySql/P06_PieceModele.sql;
SOURCE  ../tables/MySql/P06_PieceCaracteristique.sql;
SOURCE  ../tables/MySql/P06_PieceTranche.sql;
SOURCE  ../tables/MySql/P06_PiecePays.sql;
SOURCE  ../tables/MySql/P06_Collectionneur.sql;



-- CREATE THE JUNCTION TABLES;
SOURCE  ../tables/MySql/P06_Collectionner.sql;

-- CREATE THE VIEWS
SOURCE  ../views/MySQL/views.sql;

-- CREATE THE FUNCTIONS
-- CREATE THE TRIGGERS



-- INSERT THE DATA
SOURCE  ../inserts/P06_AlimentationMySql.sql;






