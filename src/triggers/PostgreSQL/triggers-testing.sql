
-- creer un trigger pour tracker les changement 
-- des valeurs monitaires des emission
-- this will be fired after an update on 
-- table piecemodele
create or replace function
    track_monitary_value_of_emission()
returns trigger as $$
begin
    
    -- the monitary value is calculated regarding
    -- the modal id
    if old.piecevaleur <> new.piecevaleur then 
        raise notice 'new total monitary value for modal #% is equal to %€', new.pieceid, new.piecevaleur * new.piecequantitefrappee;
    else
        raise notice 'total monitary value of modal #% did not change', new.pieceid;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger piecemodele_after_update_check_monitary_value
after update
on p06_piecemodele
for each row
execute function track_monitary_value_of_emission();



-- créer un trigger pour notifier si un  nouveau
-- collectionneur doit faire attention au fait que il y
-- a d'autre personne qui partagent le même nom que lui 
create or replace function 
    inform_new_comers_about_shared_names()
returns trigger  as $$
declare 
    nb_personnes_partagant_le_meme_nom bigint;
begin
    select count(collectionneurid)  
    into nb_personnes_partagant_le_meme_nom
    from p06_collectionneur
    where collectionneurnom = new.collectionneurnom;

    if nb_personnes_partagant_le_meme_nom > 0 then
        raise notice 'attention il y a % personnes qui partagent votre nom. Faites attention au enchères !', nb_personnes_partagant_le_meme_nom;
    end if;
    
    return new;
end; 
$$ language plpgsql;

create trigger after_insert_collectionneur_shared_names_notification
after insert
on p06_collectionneur 
for each row
execute function inform_new_comers_about_shared_names();


-- refaire le même trigger, mais à la fin de toutes 
-- les insertion et pas à chaque fin d'une insertion
create or replace function 
    inform_new_comers_about_shared_names_bulk()
returns trigger as $$ 
declare 
    row record;
begin
    for row in 
        (   
            select 
                count(collectionneurid) as nb_personnes,
                collectionneurnom as nom_personnes
            from p06_collectionneur
            group by collectionneurnom
        )
    loop
        if row.nb_personnes > 1 then 
            raise notice 'attention le nom % est partagé par % personnes. Attention aux enchères chers collectionneurs!', row.nom_personnes, row.nb_personnes;
        end if;
    end loop; 
    return null;
end;
$$ language plpgsql;

create trigger after_bulk_insert_collectionneur_shared_names_notification
after insert
on p06_collectionneur
for statement 
execute function inform_new_comers_about_shared_names_bulk();



