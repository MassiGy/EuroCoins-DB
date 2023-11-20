-- Donner une requête filtrant des données à l'aide
-- d'une expression rationnelle (REGEXP) sur un champ
-- textuel.

-- idée: trouver toutes les piece qui ont pour 
-- version un anniversaire d'un evennement/persone
SELECT * FROM PieceModele
WHERE PieceVersion REGEXP '*anniversaire*';



