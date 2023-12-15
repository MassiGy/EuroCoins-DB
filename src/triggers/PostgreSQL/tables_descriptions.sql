-- JUST TO SEE WHICH TABLE CONTAINS WHICH FIELD

+----------------------+--------------+------+-----+---------+----------------+
| Field                | Type         | Null | Key | Default | Extra          |
+----------------------+--------------+------+-----+---------+----------------+
| PieceID              | int          | NO   | PRI | NULL    | auto_increment |
| PieceVersion         | varchar(250) | NO   |     | NULL    |                |
| PieceValeur          | int          | NO   |     | NULL    |                |
| PieceDateFrappee     | date         | NO   |     | NULL    |                |
| PieceQuantiteFrappee | bigint       | NO   |     | NULL    |                |
+----------------------+--------------+------+-----+---------+----------------+
+-------------------+--------------+------+-----+---------+----------------+
| Field             | Type         | Null | Key | Default | Extra          |
+-------------------+--------------+------+-----+---------+----------------+
| CaracteristiqueID | int          | NO   | PRI | NULL    | auto_increment |
| PieceID           | int          | NO   | MUL | NULL    |                |
| PieceFaceCommune  | varchar(250) | NO   |     | NULL    |                |
| PieceMasse        | int          | NO   |     | NULL    |                |
| PieceTaille       | int          | NO   |     | NULL    |                |
| PieceMateriau     | varchar(250) | NO   |     | NULL    |                |
+-------------------+--------------+------+-----+---------+----------------+
+--------------+--------------+------+-----+---------+----------------+
| Field        | Type         | Null | Key | Default | Extra          |
+--------------+--------------+------+-----+---------+----------------+
| TrancheID    | int          | NO   | PRI | NULL    | auto_increment |
| PieceID      | int          | NO   | MUL | NULL    |                |
| PieceTranche | varchar(250) | NO   |     | NULL    |                |
+--------------+--------------+------+-----+---------+----------------+
+---------+--------------+------+-----+---------+----------------+
| Field   | Type         | Null | Key | Default | Extra          |
+---------+--------------+------+-----+---------+----------------+
| PaysID  | int          | NO   | PRI | NULL    | auto_increment |
| PieceID | int          | NO   | MUL | NULL    |                |
| PaysNom | varchar(250) | NO   |     | NULL    |                |
+---------+--------------+------+-----+---------+----------------+
+----------------------+--------------+------+-----+---------+----------------+
| Field                | Type         | Null | Key | Default | Extra          |
+----------------------+--------------+------+-----+---------+----------------+
| CollectionneurID     | int          | NO   | PRI | NULL    | auto_increment |
| CollectionneurNom    | varchar(250) | NO   |     | NULL    |                |
| CollectionneurPrenom | varchar(250) | NO   |     | NULL    |                |
+----------------------+--------------+------+-----+---------+----------------+
+------------------+------+------+-----+---------+-------+
| Field            | Type | Null | Key | Default | Extra |
+------------------+------+------+-----+---------+-------+
| CollectionneurID | int  | NO   | PRI | NULL    |       |
| PieceID          | int  | NO   | PRI | NULL    |       |
| QteCollection    | int  | NO   |     | NULL    |       |
+------------------+------+------+-----+---------+-------+

