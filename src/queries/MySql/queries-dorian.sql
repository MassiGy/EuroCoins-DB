/*----------- Numero 1 -------------*/
SELECT * FROM P06_Collectionneur WHERE CollectionneurNom ~ '^[A-D]';
/*----------- Numero 2 -------------*/

-- Jointure interne
-- EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c
INNER JOIN P06_Collectionner cn 
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 0.203 ms

-- syntax alternative
EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c
NATURAL JOIN P06_Collectionner cn;
-- Execution Time: 0.285 ms

-- Jointure externe (gauche)
-- EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c
LEFT JOIN P06_Collectionner cn 
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 0.339 ms

-- Ici, on va retrouver un enregistrement en 
-- plus des requêtes précedentes, car dans la table
-- Collectionneur, on retrouve un collectionneur qui
-- n'a pas de collection. Et étant donné que la table
-- collectionneur est à gauche du 'LEFT JOIN', donc
-- tout les enregistrement de cette table se retrouve
-- dans notre sortie/output même si certain n'ont pas
-- de correspondent dans la table collectionner

-- Jointure externe (gauche)
EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionner c
LEFT JOIN P06_Collectionneur cn 
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 0.329 ms

-- En changeant l'ordre des tables dans notre 
-- requete de jointure, on retrouve un nombre 
-- de resultats identiques à ceux des requetes
-- précedentes.

-- Produit cartisien

EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c, P06_Collectionner cn 
WHERE c.CollectionneurID = cn.CollectionneurID;
 -- Execution Time: 0.373 ms

-- On peut aussi implementer le produit cartisien
-- avec le CROSS JOIN,
SELECT * 
FROM P06_Collectionner c
CROSS JOIN P06_Collectionneur cn;

-- Comparaison

-- Comme on le constate, les plus rapides sont
-- les INNER JOIN et NATURAL JOIN, et puis les LEFT JOIN,
-- et puis enfin le produit cartisien. Cela se justifie
-- par le fait que les permiers chargent moins
-- d'information en memoire (RAM) que les suivants.


/*----------- Numero 3 -------------*/
-- UNION
-- ça marche, mais à quoi bon ?
SELECT CollectionneurID FROM P06_Collectionner
UNION
SELECT PieceID FROM P06_Collectionner;

-- INTERSECT
-- ça marche, mais à quoi bon ?
SELECT CollectionneurID FROM P06_Collectionner
INTERSECT
SELECT PieceID FROM P06_Collectionner;

-- Les modèles de pièces émisent en Allemagne possédant une tranche
-- 'gravure sur cannelures fines'

SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PiecePays
WHERE PaysNom = 'Allemagne'
INTERSECT
SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PieceTranche
WHERE PieceTranche = 'gravure sur cannelures fines';


-- EXCEPT
-- ça marche, mais à quoi bon ?
SELECT CollectionneurID FROM P06_Collectionner
EXCEPT
SELECT PieceID FROM P06_Collectionner;

-- trouver les piece distinnées au peuple et pas 
-- au evenement ou au collectionneur.
SELECT * FROM P06_PieceModele
EXCEPT
SELECT * FROM P06_PieceModele WHERE PieceQuantiteFrappee < 1000000;

/*----------- Numero 4 -------------*/
-- a) Sous-requête avec l'opérateur =

-- info sur le dernier collectionneur
SELECT * 
FROM P06_Collectionneur 
WHERE CollectionneurID = (
    SELECT MAX(CollectionneurID)
    FROM P06_Collectionneur
);

-- b) Sous-requête avec l'opérateur IN

-- selectionner tout les collectionneur 
-- qui ont une collection
SELECT * 
FROM P06_Collectionneur 
WHERE CollectionneurID IN (
    SELECT DISTINCT CollectionneurID 
    FROM P06_Collectionner
);

-- c) Sous-requête dans la clause FROM

SELECT * 
FROM (
    SELECT CollectionneurNom, CollectionneurPrenom 
    FROM P06_Collectionneur
) AS SubQuery;

-- d) Sous-requête imbriquée

-- Toutes les pieces françaises déjà dans 
-- les collections de certain. (on peut aussi
-- filtrer par la date pour l'histoire)
SELECT * 
FROM P06_PieceModele
WHERE PieceID IN (
    SELECT PieceID 
    FROM P06_PiecePays
    WHERE PaysNom LIKE "%France%"
    AND PieceID IN (
        SELECT PieceID 
        FROM P06_Collectionneur
    )
);

-- Trouver tout les collectionneur qui collectionnent
-- des piece avec une tranche cannelures épaisses 

SELECT * 
FROM P06_Collectionneur 
WHERE P06_Collectionneur.CollectionneurID IN (
    SELECT CollectionneurID 
    FROM P06_Collectionner 
    WHERE PieceID IN (
        SELECT PieceID 
        FROM P06_PieceTranche 
        WHERE P06_PieceTranche.PieceTranche = 'cannelures épaisses'
    )
) ;


-- e) Sous-requête synchronisée
SELECT * 
FROM P06_Collectionneur c1, 
    (
        SELECT MAX(CollectionneurID) AS MaxID 
        FROM P06_Collectionneur
    ) AS res
WHERE c1.CollectionneurID = res.MaxID;



-- f) Sous-requête avec un opérateur de comparaison combiné ANY

-- ça marche, mais à quoi bon ?
-- on prends tout les collectionneur qui se 
-- sont inscrits après au moins un collectionneur
-- avec une vrai collection. (Les potentiels parrainnés)
SELECT * 
FROM P06_Collectionneur 
WHERE CollectionneurID > ANY (
    SELECT CollectionneurID 
    FROM P06_Collectionner
);

-- SELECT * 
-- FROM P06_PieceModele
-- WHERE PieceID IN (
--     SELECT PieceID 
--     FROM P06_Caracterstique
--     WHERE PieceMateriau = ANY (
--         'argent',
--         'cuivre'
--     )
-- );



-- g) Sous-requête avec un opérateur de comparaison combiné ALL
SELECT * 
FROM P06_Collectionneur 
WHERE CollectionneurID > ALL (
    SELECT CollectionneurID 
    FROM P06_Collectionner
);

SELECT * 
FROM P06_PieceModele 
WHERE PieceID <> ALL (
    SELECT PieceID
    FROM P06_PiecePays
    WHERE PaysNom = '%France%'
);

/*----------- Numero 5 -------------*/
-- Requête avec jointure
SELECT * FROM P06_PieceModele pm JOIN P06_PiecePays pp ON pm.PieceID = pp.PieceID;

-- Requête équivalente avec sous-requête
SELECT * FROM P06_PieceModele WHERE PieceID IN (SELECT PieceID FROM P06_PiecePays);


/*----------- Numero 6 -------------*/
-- Exemple 1 : COUNT
SELECT COUNT(*) FROM P06_Collectionneur;

-- Exemple 2 : AVG
SELECT AVG(PieceValeur) FROM P06_PieceModele;

/*----------- Numero 7 -------------*/
-- Exemple 1 : GROUP BY avec COUNT
SELECT CollectionneurID, COUNT(*) FROM P06_Collectionner GROUP BY CollectionneurID;

-- Exemple 2 : GROUP BY avec SUM
SELECT CollectionneurID, SUM(QteCollection) FROM P06_Collectionner GROUP BY CollectionneurID;

/*----------- Numero 8 -------------*/
-- Exemple 1 : HAVING avec COUNT
SELECT CollectionneurID, COUNT(*) FROM P06_Collectionner GROUP BY CollectionneurID HAVING COUNT(*) > 1;

-- Exemple 2 : HAVING avec SUM
SELECT CollectionneurID, SUM(QteCollection) FROM P06_Collectionner GROUP BY CollectionneurID HAVING SUM(QteCollection) > 10;

/*----------- Numero 9 -------------*/
SELECT P1.PaysNom AS Pays1, P2.PaysNom AS Pays2
FROM P06_PiecePays P1, P06_PiecePays P2
WHERE P1.PaysID < P2.PaysID;
