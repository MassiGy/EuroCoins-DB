-- cree une fonction qui renvois le compte
-- des modele de piece groupé par date 

create or replace function 
    piece_modeles_par_date()
returns    
    table(nb_modele bigint, date_frappee date)  
as $$
begin
    return query (
        select 
             count(pieceid),
            piecedatefrappee
        from p06_piecemodele
        group by piecedatefrappee
    );
end;
$$ language plpgsql;


-- cree une fonction qui revois
-- les caracteristique d'une piece en csv
-- note: on peut faire cela plus facilement 
-- avec l'operateur TO de sql;
create or replace function
    piece_caracteristique_en_csv(idpiece int)
returns 
    varchar
as $$
declare 
    piece_details p06_piececaracteristique%rowtype;
    res text; 
begin
    select *
    into piece_details
    from p06_piececaracteristique 
    where pieceid = idpiece;

    res:=concat(res,piece_details.piecefacecommune);
    res:=concat(res,',');
    res:=concat(res,piece_details.piecemasse);
    res:=concat(res,',');
    res:=concat(res,piece_details.piecetaille);
    res:=concat(res,',');
    res:=concat(res,piece_details.piecemateriau);
    return res;
end;
$$ language plpgsql;


-- créer une fonction qui calcule la valeur 
-- monitaire frappé d'une date
create or replace function 
    val_monitaire_date(dateVolue date)
returns 
    table(valeur_monitaire_total bigint,dateIndiquee date)
as $$
begin
    return QUERY (
        select 
        piecevaleur * piecequantitefrappee,
        piecedatefrappee
        from p06_piecemodele
        where piecedatefrappee = dateVolue
    );
end;
$$ language plpgsql; 


-- créer une fonction qui calcule la valeur 
-- monitaire que possède la collection d'un 
-- collectionneur
create or replace function 
    val_monitaire_collection(idcollectionneur int) 
returns bigint as $$
declare
    res bigint;
begin 
    select sum(val_monitaire_par_collection) as val_monitaire_collections
    into res
    from (
        select 
            qtecollection * piecevaleur as val_monitaire_par_collection
        from p06_collectionner
        inner join p06_piecemodele
        on p06_collectionner.pieceid = p06_piecemodele.pieceid
        where collectionneurid = idcollectionneur
    ) as vals_monitaire_collectionneur_par_collection;
    return res;
end;
$$ language plpgsql;


