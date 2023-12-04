-- Start by creating the database
-- CREATE DATABASE IF NOT EXISTS P06_Euro;

-- switch to it
-- \c P06_Euro;


-- CREATE THE TABLES;
\i  ../tables/PostgreSQL/P06_PieceModele.sql;
\i  ../tables/PostgreSQL/P06_PieceCaracteristique.sql;
\i  ../tables/PostgreSQL/P06_PieceTranche.sql;
\i  ../tables/PostgreSQL/P06_PiecePays.sql;
\i  ../tables/PostgreSQL/P06_Collectionneur.sql;



-- CREATE THE JUNCTION TABLES;
\i  ../tables/PostgreSQL/P06_Collectionner.sql;

-- CREATE THE VIEWS
\i  ../views/PostgreSQL/views.sql;

-- INSERT THE DATA (note: you can insert before
-- creating the triggers to speed things up)
\i  ../inserts/P06_AlimentationPostgresql.sql;

-- CREATE THE FUNCTIONS
\i  ../functions/PostgreSQL/functions.sql;

-- CREATE THE TRIGGERS
\i  ../triggers/PostgreSQL/triggers.sql;




