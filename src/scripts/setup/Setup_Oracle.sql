-- NOTE: Since Databases are not set the same way in PostgreSQL and Oracle, we
-- can not create a database as easily as we've been able to do in PostgreSQL
-- and Mysql. Thereafter CREATE DATABASE CLAUSE in the current Oracle script
-- will be omitted, and thus the use|\i equivalent will be discarded too.

-- for more: 
-- https://stackoverflow.com/questions/10461861/use-database-command-on-sql-plus-oracle-11gr1


-- CREATE THE TABLES;
@../tables/Oracle/P06_PieceModele.sql;
@../tables/Oracle/P06_PieceCaracteristique.sql;
@../tables/Oracle/P06_PieceTranche.sql;
@../tables/Oracle/P06_PiecePays.sql;
@../tables/Oracle/P06_Collectionneur.sql;



-- CREATE THE JUNCTION TABLES;
@../tables/Oracle/P06_Collectionner.sql;

-- CREATE THE VIEWS
@../views/Oracle/views.sql;

-- CREATE THE FUNCTIONS
@../functions/Oracle/functions.sql;

-- CREATE THE TRIGGERS
@../triggers/Oracle/triggers.sql;


-- INSERT THE DATA (note: you can insert before
-- creating the triggers to speed things up)
@../inserts/P06_AlimentationOracle.sql;






