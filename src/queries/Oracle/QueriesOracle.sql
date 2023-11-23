/*------------------------------------      Numero 1     ----------------------------------------*/

-- Donner tout les collectionneur ayant pour nom
-- commençant par une lettre entre A et D
SELECT *
FROM P06_Collectionneur
WHERE REGEXP_LIKE(CollectionneurNom, '^[A-D]');


/*------------------------------------      Numero 2     ----------------------------------------*/

-- Jointure interne: Donner les infos sur tout les
-- collectionneur et leurs collection
-- EXPLAIN ANALYZE 
SELECT *
FROM P06_Collectionneur c
INNER JOIN P06_Collectionner cn ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: ??? ms

-- syntax alternative: Donner les infos sur tout les
-- collectionneur et leurs collection
-- EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c
NATURAL JOIN P06_Collectionner cn;
-- Execution Time: ??? ms

-- Jointure externe (gauche): Donner les infos sur tout
-- les collectionneur et leurs collection
-- EXPLAIN ANALYZE 
SELECT *
FROM P06_Collectionneur c
LEFT JOIN P06_Collectionner cn ON c.CollectionneurID = cn.CollectionneurID;
-- Execution Time: ???? ms

-- Ici, on va retrouver un enregistrement en plus des
-- requêtes précedentes, car dans la table
-- Collectionneur, on retrouve un collectionneur qui
-- n'a pas de collection. Et étant donné que la table
-- collectionneur est à gauche du 'LEFT JOIN', donc
-- tout les enregistrement de cette table se retrouve
-- dans notre sortie/output même si certain n'ont pas
-- de correspondent dans la table collectionner

-- Jointure externe (gauche) : Donner les infos sur
-- tout les collectionneur et leurs collection
-- EXPLAIN ANALYZE 
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

-- EXPLAIN ANALYZE 
SELECT * 
FROM P06_Collectionneur c, P06_Collectionner cn 
WHERE c.CollectionneurID = cn.CollectionneurID;
 -- Execution Time: 0.373 ms

-- Comparaison

-- (Attentions: les temps d'execution sont très
-- variables et il faudrait les réexecuter plusieurs
-- fois à la suite puis prendre la moyenne, mais cela
-- est assez representatif. Nombre d'execution à la
-- suite = 3) Comme on le constate, les plus rapides
-- sont les INNER JOIN et NATURAL JOIN, et puis les
-- LEFT JOIN, et puis enfin le produit cartisien. Cela
-- se justifie par le fait que les permiers chargent
-- moins d'information en memoire (RAM) que les
-- suivants.

-- Question 2 - requête 2

-- inner join
SELECT *
FROM P06_PieceModele PM
INNER JOIN P06_PieceTranche PT ON PM.PieceID = PT.PieceID;

-- natual join
SELECT *
FROM P06_PieceModele
NATURAL JOIN P06_PieceTranche;

-- right join
SELECT *
FROM P06_PieceModele PM
RIGHT JOIN P06_PieceTranche PT ON PM.PieceID = PT.PieceID;


-- Ici on obtient le même nombre de résultat car toutes
-- les tranches définies dans la table PieceTranche
-- sont attaché au moins à un modele de piece dans
-- PieceModele, et vice-vers-ça d'ailleurs.

-- Produit Cartésien
SELECT *
FROM P06_PieceModele AS PM
CROSS JOIN P06_PieceTranche AS PT
ON PM.PieceID = PT.PieceID;

-- Produit Cartésien
SELECT *
FROM 
    P06_PieceModele AS PM,
    P06_PieceTranche AS PT
WHERE PM.PieceID = PT.PieceID;

-- Comparaison et explication des temps 
-- d'éxectution, (voir première requête)

-- Question 2 - requête 3

-- inner join
SELECT *
FROM P06_PieceModele PM
INNER JOIN P06_PiecePays PP ON PM.PieceID = PP.PieceID;


-- natual join
SELECT *
FROM P06_PieceModele
NATURAL JOIN P06_PiecePays;

-- right join
SELECT *
FROM P06_PieceModele PM
RIGHT JOIN P06_PiecePays PP ON PM.PieceID = PP.PieceID;


-- Ici on obtient le même nombre de résultat car toutes
-- les pays définis dans la table PiecePays sont
-- attaché au moins à un modele de piece dans
-- PieceModele.

-- Produit Cartésien
SELECT *
FROM P06_PieceModele AS PM
CROSS JOIN P06_PiecePays AS PP
ON PM.PieceID = PP.PieceID;

-- Produit Cartésien
SELECT *
FROM P06_PieceModele PM, P06_PiecePays PP
WHERE PM.PieceID = PP.PieceID;

-- Comparaison et explication des temps 
-- d'éxectution, (voir première requête)

-- Question 2 - requête 4

-- inner join
SELECT *
FROM P06_PieceModele PM
INNER JOIN P06_PieceCaracteristique PC ON PM.PieceID = PC.PieceID;

-- natual join
SELECT *
FROM P06_PieceModele
NATURAL JOIN P06_PieceCaracteristique;


-- right join
SELECT *
FROM P06_PieceModele PM
RIGHT JOIN P06_PieceCaracteristique PC ON PM.PieceID = PC.PieceID;

-- Ici on obtient le même nombre de résultat car toutes
-- les caracteristiques définis dans la table PieceCarac
-- sont attaché au moins à un modele de piece dans
-- PieceModele.

-- Produit Cartésien
SELECT *
FROM P06_PieceModele PM, P06_PieceCaracteristique PC
WHERE PM.PieceID = PC.PieceID;

-- Comparaison et explication des temps 
-- d'éxectution, (voir première requête)

/*------------------------------------      Numero 3     ----------------------------------------*/

-- pour UNION dans notre cas, l'operateur UNION nous
-- aide pas forcement à retrouver une information
-- spécifique plus aisément que ce qui aurait était
-- fait avec autre chose. L'UNION est très appreciable
-- quand on a des tables différentes avec des colonnes
-- en commun. Par exemple, Supplier, Employee et
-- Customer sont des tables qui ont toutes des
-- information sur le nom, prenom, email. Donc, on
-- pourra retrouver toute la démograhpie d'une
-- entreprise avec un simple UNION.

-- Pour ce qui est de notre base de donnée, on peut
-- utiliser l'union pour avoir les piece qui sont
-- produite lors d'un anniversaire ou un championnat.

SELECT *
FROM P06_PieceModele
WHERE PieceVersion LIKE '%anniversaire%' 
UNION
SELECT *
FROM P06_PieceModele
WHERE PieceVersion LIKE '%Championnat%';



-- INTERSECT

-- L'operateur INTERSECT est très utile pour avoir une
-- inclusion entre deux ensemble de donnée qui ont des
-- clés/colonnes en commun. Encore une fois, cela n'est
-- pas très pertinnent dans le context de notre base de
-- donnée. Par ailleurs, on peut imaginer une base de
-- donnée ou on a deux table Supplier, Customer qui
-- contiennet des colonne nom, prenom et email en
-- commun et on pourra savoir qui est la personne qui
-- porte plusieurs casquettes dans notre entreprise.


-- Dans le cas de notre base de données, par exemple:
-- on peut avoir les modèles de pièces émisent en
-- Allemagne possédant une tranche 'gravure sur
-- cannelures fines'

SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PiecePays
WHERE PaysNom = 'Allemagne'
INTERSECT
SELECT PM.*
FROM P06_PieceModele PM NATURAL JOIN P06_PieceTranche
WHERE PieceTranche = 'gravure sur cannelures fines';


-- EXCEPT pour EXCEPT/MINUS (NOTE: il y a pas
-- d'operateur EXCEPT/MINUS pour mysql, donc on
-- utilisera NOT IN à la place).

-- cette requête pourra être faite autrement et plus
-- aisément, mais pour cette question on voulais
-- utiliser NOT IN pour illustrer un exemple de son
-- utilisation. Par ailleurs, pour ce qui est du sens
-- de cette requête, elle vise à retrouver toutes les
-- information des pièces qui ont une quantite frappée
-- >= 1000000; On ignore en quelques sorte les pièce de
-- collection, rare et d'anniversaire.

SELECT * 
FROM P06_PieceModele 
MINUS 
SELECT PieceID 
FROM P06_PieceModele
WHERE PieceQuantiteFrappee < 1000000  
;


/*------------------------------------      Numero 4     ----------------------------------------*/

-- a) Sous-requête avec l'opérateur =

-- Prendre une piece arbitraire avec un certain
-- ensemble de caracteristique.
SELECT *
FROM P06_PieceModele
WHERE PieceID = (
    SELECT PieceID
    FROM (
        SELECT PieceID
        FROM P06_PieceCaracteristique
        WHERE PieceMateriau LIKE '%cuivre%'
        AND PieceTaille > 100
        AND PieceMasse > 200
        AND ROWNUM = 1
    )
);


-- b) Sous-requête avec l'opérateur IN

-- trouver tout les pays qui ont produit un modèle de
-- piece suite à une competition/championat
SELECT *
FROM P06_PiecePays
WHERE PieceID IN (
    SELECT PieceID
    FROM P06_PieceModele
    WHERE PieceVersion LIKE '%Championnat%'
);


-- c) Sous-requête dans la clause FROM

SELECT SubQuery.*
FROM (
    SELECT CollectionneurNom, CollectionneurPrenom 
    FROM P06_Collectionneur
) SubQuery;

-- d) Sous-requête imbriquée

-- Toutes les pieces françaises déjà dans les
-- collections de certain. (on peut aussi filtrer par
-- la date pour l'histoire)

SELECT *
FROM P06_PieceModele
WHERE PieceID IN (
    SELECT PP.PieceID 
    FROM P06_PiecePays PP
    WHERE PP.PaysNom LIKE '%France%'
    AND PP.PieceID IN (
        SELECT C.PieceID 
        FROM P06_Collectionner C
    )
);


-- Trouver tout les collectionneur qui collectionnent
-- des piece avec une tranche cannelures épaisses 

SELECT *
FROM P06_Collectionneur 
WHERE CollectionneurID IN (
    SELECT C.CollectionneurID 
    FROM P06_Collectionner C
    WHERE C.PieceID IN (
        SELECT PT.PieceID 
        FROM P06_PieceTranche PT 
        WHERE PT.PieceTranche = 'cannelures épaisses'
    )
);



-- e) Sous-requête synchronisée

SELECT C.CollectionneurID, C.CollectionneurNom, C.CollectionneurPrenom -- Ajoutez les colonnes que vous souhaitez sélectionner
FROM P06_Collectionneur C
JOIN P06_Collectionner CN ON C.CollectionneurID = CN.CollectionneurID
GROUP BY C.CollectionneurID, C.CollectionneurNom, C.CollectionneurPrenom -- Ajoutez les colonnes que vous souhaitez regrouper
HAVING COUNT(CN.QteCollection) > 10;

-- La requête suivante est équivalente à la précedente
-- même si elle implemente pas de sous requête synchro
-- Toutefois, elle explique bien ce que la précedente
-- fait.
SELECT C.*
FROM P06_Collectionneur C
JOIN (
    SELECT CollectionneurID, COUNT(QteCollection) AS QteCount
    FROM P06_Collectionner 
    GROUP BY CollectionneurID
    HAVING COUNT(QteCollection) > 10
) QueryASTable ON C.CollectionneurID = QueryASTable.CollectionneurID;



-- f) Sous-requête avec un opérateur de comparaison
-- combiné ANY

-- Trouver toutes les piece avec une valeur > 1€
-- collectionnés par Stefan Ponty.
SELECT *
FROM P06_Collectionneur C
NATURAL JOIN P06_Collectionner CN
WHERE CN.PieceID ANY (
    SELECT PieceID
    FROM P06_PieceModele
    WHERE PieceValeur > 100
)
AND C.CollectionneurNom = 'Ponty'
AND C.CollectionneurPrenom = 'Stefan';



-- g) Sous-requête avec un opérateur de comparaison
-- combiné ALL

-- Trouver tout les modele de piece qui ne 
-- sont pas produit en France.
SELECT *
FROM P06_PieceModele PM
WHERE PieceID <> ALL (
    SELECT PP.PieceID
    FROM P06_PiecePays PP
    WHERE PP.PieceID = PM.PieceID
    AND PP.PaysNom LIKE '%France%'
);

/*------------------------------------      Numero 5     ----------------------------------------*/
-- Requête avec jointure

-- EXPLAIN ANALYZE
SELECT pm.*
FROM P06_PieceModele pm 
INNER JOIN P06_PiecePays pp ON pm.PieceID = pp.PieceID;


-- Requête équivalente avec sous-requête

-- EXPLAIN ANALYZE
SELECT *
FROM P06_PieceModele 
WHERE PieceID IN (
    SELECT PP.PieceID 
    FROM P06_PiecePays PP
);

-- https://stackoverflow.com/questions/2577174/join-vs-sub-query
-- Suivant cette page, les jointures sont plus rapides
-- étant donné qu'elles sont optimisées par le SGBD
-- avant leurs execution. Le SGBD peut en quelques
-- sorte comprends la jointure et déduire quelles sont
-- les données qui doivent être chargées en mémoire.
-- Par contre, pour ce qui est des sous requêtes,
-- celles-ci ne peuvent pas être prédites, car le SGBD
-- doit les executé une à une, et donc il peut pas les
-- comprends assez finement pour arriver à les
-- optimiser. Toutefois, cela dépend des SGBD et aussi
-- du type de la requête. Par ailleurs, les sous
-- requête permettent de rester dans un mode de
-- reflexion plus familier, et donc de faire moin
-- d'erreur, notamment les erreur de chargement de
-- données double - duplication.


/*------------------------------------      Numero 6     ----------------------------------------*/

-- Donner le nombre de collectionneur
SELECT COUNT(*) FROM P06_Collectionneur;

-- Donner le modèle de pièce qui a été le moins frappée
SELECT *
FROM P06_PieceModele
WHERE PieceQuantiteFrappee = (
    SELECT MIN(PieceQuantiteFrappee)
    FROM P06_PieceModele
);

-- Donner la moyenne des valeurs des pièces
SELECT AVG(PieceValeur) FROM P06_PieceModele;

-- Donner le nombre total de pièces qui a été émise en
-- France
SELECT SUM(PieceQuantiteFrappee) AS NbPieceFrance
FROM P06_PieceModele PM
JOIN P06_PiecePays PP ON PM.PieceID = PP.PieceID
WHERE PP.PaysNom = 'France';



/*------------------------------------      Numero 8     ----------------------------------------*/
-- GROUP BY avec COUNT

-- Nombre de collection pour un certain collectionneur
SELECT CollectionneurID, COUNT(*) AS NombreDeCollections
FROM P06_Collectionner 
GROUP BY CollectionneurID;


-- Donner le nombre de modèle de pièce que possède
-- chaque pays
SELECT PaysNom, COUNT(PM.PieceID) AS NbPiece
FROM P06_PiecePays PP 
JOIN P06_PieceModele PM ON PP.PieceID = PM.PieceID
GROUP BY PaysNom;

-- GROUP BY avec SUM

-- Donner le nombre total de pièces que possède chaque
-- collectionneur
SELECT C.CollectionneurID, SUM(C.QteCollection) AS NbPiece 
FROM P06_Collectionneur C
LEFT JOIN P06_Collectionner CN ON C.CollectionneurID = CN.CollectionneurID
GROUP BY C.CollectionneurID;

-- Ou bien, tout simplement
SELECT CollectionneurID, SUM(QteCollection) AS NbPiece 
FROM P06_Collectionner 
GROUP BY CollectionneurID;


/*------------------------------------      Numero 8     ----------------------------------------*/
--  HAVING avec COUNT
-- Donner tout les id des collectionneurs 
-- qui ont au moins 2 collection.
SELECT CollectionneurID, COUNT(*) AS NombreDeCollections
FROM P06_Collectionner 
GROUP BY CollectionneurID 
HAVING COUNT(*) > 1;

-- HAVING avec SUM
-- Donner tout les id des collectionneur qui 
-- ont au moins 100 pièces collectionnées 
SELECT CollectionneurID, SUM(QteCollection) AS TotalPieces
FROM P06_Collectionner 
GROUP BY CollectionneurID 
HAVING SUM(QteCollection) > 100;

/*------------------------------------      Numero 9     ----------------------------------------*/

-- Une requête pour generé quelques binômes de
-- collectionneurs. Pour avoir ça, l'astuce est de
-- charger en mémoire deux fois la même table (deux
-- instances de la même table).
SELECT 
    C1.CollectionneurNom AS Nom1,
    C1.CollectionneurPrenom AS Prenom1,
    C2.CollectionneurNom AS Nom2,
    C2.CollectionneurPrenom AS Prenom2
FROM 
    P06_Collectionneur C1 
JOIN 
    P06_Collectionneur C2
ON 
    (C1.CollectionneurNom < C2.CollectionneurNom)
    OR 
    (C1.CollectionneurNom = C2.CollectionneurNom AND C1.CollectionneurPrenom < C2.CollectionneurPrenom);