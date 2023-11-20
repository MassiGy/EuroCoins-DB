-- Donner une requête filtrant des données à l'aide
-- d'une expression rationnelle (REGEXP) sur un champ
-- textuel.

-- idée: trouver toutes les piece qui ont pour 
-- version un anniversaire d'un evennement/persone
-- (NOTE: ceci peut se faire avec un LIKE assez facilement)
SELECT * FROM P06_PieceModele
WHERE PieceVersion REGEXP "anniversaire";

-- Donner quatre requêtes différentes mettant en œuvre des
-- jointures internes. Différentes syntaxes de jointure devront
-- être employées. De plus pour les quatre requêtes, vous
-- proposerez au moins une version alternative mettant en œuvre une
-- jointure externe ; pour chacune de ces jointures externes vous
-- expliquerez pourquoi les résultats sont identiques ou différents
-- de la jointure interne.



-- Donner une requête pour chacun des opérateurs ensemblistes
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
-- cela n'est pas très pertinnent dans le context de
-- notre base de donnée. Par ailleurs, on peut imaginer
-- une base de donnée ou on a deux table Supplier, Customer
-- qui contiennet des colonne 












