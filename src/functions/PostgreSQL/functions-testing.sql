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



-- créer une fonction qui utilise une cursor et une 
-- boucle.
-- pour cela, on va crée une fonction qui va afficher
-- le nom et le prénom de chaque collectionneur avec
-- une pièce très rare (émise pour un championat ou un 
-- grand anniversaire).
-- on va faire que de l'affichage donc c'est une procedure
create or replace procedure collectionneur_possedant_pieces_rare() as $$
declare 
    row p06_collectionneur%rowtype;
    curseur cursor for 
            select * 
            from p06_collectionneur 
            where collectionneurid in (
                select collectionneurid 
                from p06_collectionner
                where pieceid in (
                    select pieceid 
                    from p06_piecemodele
                    where pieceversion like '%Championat%'
                    or pieceversion like '%anniversaire%'
                 )
            );
begin
    for row in curseur 
    loop 
        raise notice 'M/Mme % % possède queqlues pieces rares!', row.collectionneurprenom, row.collectionneurnom;
    end loop;
end;
$$ language plpgsql;


-- créer une fonction qui va retourner une sous 
-- partie d'une table 
create or replace function 
    filtrer_piece_par_valeurs(valeur int)
returns setof p06_piecemodele as $$ 
declare 
    curseur cursor(val int) for
            select * from 
            p06_piecemodele 
            where piecevaleur = val;
    row p06_piecemodele%rowtype;
begin
    for row in curseur(valeur) 
    loop 
        -- queue (add one to queue)
        return next row;
    end loop;
    
    -- flush (return all)
    return;  
end;
$$ language plpgsql; 



-- créer une procedure fizzbuzz (ce ci n'a aucun rapport avec le projet)
create or replace procedure
   fizzbuzz(range int) 
as $$
declare 
    i int;
begin
    for i in 1 .. range
    loop
        if mod(i,15)=0 
        then 
            raise notice 'fizzbuzz';
        elsif mod(i, 5)=0 
        then 
            raise notice 'buzz';
        elsif mod(i, 3)=0
        then    
            raise notice 'fizz';
        else
            raise notice '%',i; 
        end if; 
    end loop;

end;
$$ language plpgsql;











