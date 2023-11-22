-- 1) Donner une requête filtrant des données à l'aide
-- d'une expression rationnelle (REGEXP) sur un champ
-- textuel.

-- idée: trouver toutes les piece qui ont pour
-- version un anniversaire d'un evennement/persone
-- (NOTE: ceci peut se faire avec un LIKE assez facilement)
SELECT * FROM P06_PieceModele
WHERE PieceVersion REGEXP "anniversaire";

-- à l'aide d'une regex, afficher tous les collectionneurs
-- possédant un nom entre "A" et "D"

SELECT * FROM P06_Collectionneur
WHERE CollectionneurNom NOT REGEXP "^[E-Z]";

-- 2) Donner quatre requêtes différentes mettant en œuvre des
-- jointures internes. Différentes syntaxes de jointure devront
-- être employées. De plus pour les quatre requêtes, vous
-- proposerez au moins une version alternative mettant en œuvre une
-- jointure externe ; pour chacune de ces jointures externes vous
-- expliquerez pourquoi les résultats sont identiques ou différents
-- de la jointure interne.

-- EXPLAIN ANALYZE
SELECT *
FROM P06_Collectionneur c
INNER JOIN P06_Collectionner cn
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 25 ms

-- syntax alternative
-- EXPLAIN ANALYZE
SELECT *
FROM P06_Collectionneur c
NATURAL JOIN P06_Collectionner cn;
-- Execution Time: 13 ms

-- Jointure externe (gauche)
-- EXPLAIN ANALYZE
SELECT *
FROM P06_Collectionneur c
LEFT JOIN P06_Collectionner cn
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 40 ms

-- Ici, on va retrouver un enregistrement en
-- plus des requêtes précedentes, car dans la table
-- Collectionneur, on retrouve un collectionneur qui
-- n'a pas de collection. Et étant donné que la table
-- collectionneur est à gauche du 'LEFT JOIN', donc
-- tout les enregistrement de cette table se retrouve
-- dans notre sortie/output même si certain n'ont pas
-- de correspondent dans la table collectionner

-- Jointure externe (gauche)
-- EXPLAIN ANALYZE
SELECT *
FROM P06_Collectionner c
LEFT JOIN P06_Collectionneur cn
ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: 15 ms

-- En changeant l'ordre des tables dans notre
-- requete de jointure, on retrouve un nombre
-- de resultats identiques à ceux des requetes
-- précedentes.

-- Produit cartisien

-- EXPLAIN ANALYZE
SELECT *
FROM P06_Collectionneur c, P06_Collectionner cn
WHERE c.CollectionneurID = cn.CollectionneurID;
 -- Execution Time: 14 ms

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

-- 3) Donner une requête pour chacun des opérateurs ensemblistes
-- (UNION, INSERSECT et EXCEPT)

-- pour UNION
-- dans notre cas, l'operateur UNION nous aide pas forcement
-- à retrouver une information spécifique plus aisément que
-- ce qui aurait était fait avec autre chose. L'UNION est 
-- très appreciable quand on a des tables différentes avec 
-- des colonnes en commun. Par exemple, Supplier, Employee et
-- Customer sont des tables qui ont toutes des information 
-- sur le nom, prenom, email. Donc, on pourra retrouver
-- toute la démograhpie d'une entreprise avec un simple UNION.

-- Pour ce qui est de notre base de donnée, on peut utiliser
-- l'union pour avoir les piece qui sont produite lors d'un anniversaire
-- ou un championnat.
SELECT *
FROM P06_PieceModele
WHERE PieceVersion LIKE "%anniversaire%"
UNION
SELECT *
FROM P06_PieceModele
WHERE PieceVersion LIKE "%Championnat%";

-- pour EXCEPT/MINUS
-- (NOTE: il y a pas d'operateur EXCEPT/MINUS pour mysql,
-- donc on utilisera NOT IN à la place).

-- cette requête pourra être faite autrement et plus
-- aisément, mais pour cette question on voulais utiliser
-- NOT IN pour illustrer un exemple de son utilisation.
-- Par ailleurs, pour ce qui est du sens de cette requête,
-- elle vise à retrouver toutes les information des pièces
-- qui ont une quantite frappée >= 1000000; On ignore en quelques
-- sorte les pièce de collection, rare et d'anniversaire.

SELECT * 
FROM P06_PieceModele
WHERE PieceID NOT IN (
    SELECT PieceID 
    FROM P06_PieceModele
    WHERE PieceQuantiteFrappee < 1000000
);

-- Pour INTERSECT

-- L'operateur INTERSECT est très utile pour avoir
-- une inclusion entre deux ensemble de donnée qui
-- ont des clés/colonnes en commun. Encore une fois,
-- cela n'est pas très pertinnent dans le contexte de
-- notre base de donnée. Par ailleurs, on peut imaginer
-- une base de donnée ou on a deux table Supplier, Customer
-- qui contiennent des colonne

-- Les modèles de pièces émisent en Allemagne possédant une tranche
-- "gravure sur cannelures fines"

SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PiecePays
WHERE PaysNom = "Allemagne"
INTERSECT
SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PieceTranche
WHERE PieceTranche = "gravure sur cannelures fines";


-- 4) Donner 7 requêtes mettant en œuvre les sous-requêtes suivantes :
-- une sous-requête dans la clause WHERE via l'opérateur =
-- une sous-requête dans la clause WHERE via l'opérateur IN (et nécessitant cet opérateur)
-- une sous requête dans la clause FROM
-- une sous-requête imbriquée dans une autre sous-requête
-- une sous-requête synchronisée
-- une sous-requêtes utilisant un opérateur de comparaison combiné ANY
-- une sous-requête utilisant un opérateur de comparaison combiné ALL

-- 5) Donner un exemple de requête pouvant être réalisé avec une jointure
-- ou avec une sous-requête. Les deux requêtes équivalentes devront être fournies.
-- Quelle requête est la plus efficace (justification attendue)


-- 6) Donner deux requêtes différentes utilisant
-- les fonctions d'agrégation SQL

-- a. Donner le modèle de pièce qui a été le moins frappée

SELECT *
FROM P06_PieceModele
WHERE PieceQuantiteFrappee =    (SELECT MIN(PieceQuantiteFrappee)
                                 FROM P06_PieceModele);

-- b. Donner le nombre total de pièces qui a été émise en France

SELECT SUM(PieceQuantiteFrappee) AS NbPieceFrance
FROM P06_PieceModele NATURAL JOIN P06_PiecePays
WHERE PaysNom = "France";


-- 7) Donnez deux requêtes différentes utilisant les fonctions d'agrégation
-- et la clause GROUP BY

-- a. Donner le nombre total de pièces que possède chaque collectionneur

SELECT C.*, SUM(QteCollection) AS NbPiece
FROM P06_Collectionneur C LEFT JOIN P06_Collectionner ON C.CollectionneurID = P06_Collectionner.CollectionneurID
GROUP BY CollectionneurID;

-- b. Donner le nombre de modèle de pièce que possède chaque pays

SELECT PaysNom, COUNT(P06_PieceModele.PieceID) AS NbPiece
FROM P06_PiecePays P NATURAL JOIN P06_PieceModele
GROUP BY PaysNom;


-- 8) Donner deux exemples de mise en œuvre de
-- la clause HAVING

-- 9) Donner une requête qui associe sur une même ligne des informations issues de deux
-- enregistrements différents d’une même table, par exemple deux pays différents, deux
-- personnes différentes, etc