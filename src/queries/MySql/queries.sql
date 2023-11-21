/*
 * 1. Donner une requête filtrant des données à l'aide d'une expression rationnelle (REGEXP) sur
 * un champ textuel.
 */
-- SELECT * FROM P06_PieceModele WHERE P06_PieceModele.PieceVersion REGEXP 'Guerre' ;
/* Cette requête permet d'obtenir toutes les pièces dont la version contient le mot "Guerre". */


/*
 * 2. Donner quatre requêtes différentes mettant en œuvre des jointures internes. Pour chacune
 * d’entre elles proposer :
 */
/*
 * a) deux syntaxes différentes ;
 */
-- SELECT * FROM P06_PiecePays NATURAL JOIN P06_PieceModele ORDER BY P06_PiecePays.PaysID ;
SELECT * FROM P06_PiecePays P06PP INNER JOIN EuroCoins.P06_PieceModele P06PM ON P06PP.PieceID = P06PM.PieceID ORDER BY P06PP.PaysID ;
/*
 * Ces deux requêtes permettent d'obtenir une jointure des tables P06_PiecePays/P06_PieceModele.
 */

/*
 * b) une version alternative mettant en œuvre une jointure externe et expliquant pourquoi les
 * résultats sont identiques ou différents de ceux obtenus via la jointure interne ;
 */
-- SELECT * FROM P06_PieceModele P06PM LEFT JOIN EuroCoins.P06_PiecePays P06PP on P06PM.PieceID = P06PP.PieceID ORDER BY P06PP.PaysID ;
/*
 *
 */