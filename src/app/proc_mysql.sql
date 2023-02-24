--AZinterv__interv_cmptSelect OLD

begin
	select '' as etat,ic.id_interv_cmpt,ic.id_interv,concat(i.date_interv,' ',l.nom_lieu) as id_intervWITH,ic.id_cmpt,c.nom_cmpt as id_cmptWITH,ic.ordre
	from interv_cmpt ic
    inner join interv i
    inner join cmpt c
    inner join lieu l
	where ic.id_interv=p_id_interv
    and ic.id_interv=i.id_interv
    and c.id_cmpt=ic.id_cmpt
    and i.id_lieu=l.id_lieu;
end

--AZinterv__interv_cmptSelect    OK <--
begin
	select '' as etat,concat(i.date_interv,' ',l.nom_lieu) as id_intervWITH,c.nom_cmpt as id_cmptWITH,ic.ordre,ic.id_cmpt
    from interv i
    left join lieu l on l.id_lieu=i.id_lieu
    left join interv_cmpt ic on i.id_interv=ic.id_interv
    left join cmpt c on c.id_cmpt=ic.id_cmpt
	where ic.id_interv=p_id_interv;
end
--
    and ic.id_cmpt=c.id_cmpt;

--AZinterv__seance_cmptSelect    OK <--
select '' as etat,concat(i.date_interv,' ',l.nom_lieu) as id_intervWITH,i.id_seance,c.nom_cmpt
from interv i
left join lieu l on l.id_lieu=i.id_lieu
left join seance_cmpt sc on i.id_seance=sc.id_seance
left join cmpt c on c.id_cmpt=sc.id_cmpt
where id_interv=p_id_interv;
--



--AZinterv_intervMaj
begin
	if (p_etat ='U') then
        if (p_id_seance = 0) then
            set p_id_seance = NULL;
        end if;
		update interv set date_interv=p_date_interv,id_seance=p_id_seance,id_lieu=p_id_lieu,comm_interv=p_comm_interv,tarif_interv=p_tarif_interv,fact_interv=p_fact_interv,num_interv=p_num_interv where id_interv=p_id_interv;
	elseif (p_etat = 'I') then
		insert into interv (date_interv,id_seance,id_lieu,comm_interv,tarif_interv,fact_interv,num_interv) values (p_date_interv,p_id_seance,p_id_lieu,p_comm_interv,p_tarif_interv,p_fact_interv,p_num_interv);
	elseif (p_etat = 'D') then
		delete from interv where id_interv=p_id_interv;
	end if;
end
--

--AZvilleSelect
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZvilleSelect`()
begin
	SELECT '' as etat,id_ville,nom_ville
    FROM `ville`
    ORDER BY id_ville;
 end$$
DELIMITER ;
--

--AZinstrMaj
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZvilleMaj`(IN `p_etat` CHAR, IN `p_id_ville` INT, IN `p_nom_ville` VARCHAR(30))
begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update ville set nom_ville=p_nom_ville where id_ville=p_id_ville;
	elseif (p_etat = 'I') then
		insert into ville (nom_ville) values (p_nom_ville);
	elseif (p_etat = 'D') then
		delete from ville where id_ville=p_id_ville;
	end if;
end$$
DELIMITER ;
--

--AZlieuMaj  // pour éviter les erreurs quand lat_lieu et/ou lon_lieu ne sont pas renseignés
begin
	if (p_etat ='U') then
		update lieu set nom_lieu=p_nom_lieu,ad_lieu=p_ad_lieu,id_ville=p_id_ville,lat_lieu=p_lat_lieu,lon_lieu=p_lon_lieu,id_type_lieu=p_id_type_lieu where id_lieu=p_id_lieu;
	elseif (p_etat = 'I') then
        if (p_id_seance = 0) then
            set p_id_seance = NULL;
        end if;
		insert into lieu (nom_lieu,ad_lieu,id_ville,lat_lieu,lon_lieu,id_type_lieu) values (p_nom_lieu,p_ad_lieu,p_id_ville,p_lat_lieu,p_lon_lieu,p_id_type_lieu);
	elseif (p_etat = 'D') then
		delete from lieu where id_lieu=p_id_lieu;
	end if;
end
--
--AZinterv__intervSelect
begin
	select '' as etat,i.id_interv,i.date_interv,i.id_seance,i.id_lieu,i.comm_interv,i.tarif_interv,i.fact_interv,i.num_interv,l.id_lieu,l.nom_lieu
	from interv i
    inner join lieu l on l.id_lieu=i.id_lieu
	where i.id_interv=p_id_interv;
end

--
--AZinterv__intervMaj
begin
	if (p_etat ='U') then
        if (p_id_seance = 0) then
            set p_id_seance = NULL;
        end if;
		update interv set date_interv=p_date_interv,id_seance=p_id_seance,id_lieu=p_id_lieu,comm_interv=p_comm_interv,tarif_interv=p_tarif_interv,fact_interv=p_fact_interv,num_interv=p_num_interv where id_interv=p_id_interv;
	elseif (p_etat = 'I') then
		insert into interv (date_interv,id_seance,id_lieu,comm_interv,tarif_interv,fact_interv,num_interv) values (p_date_interv,p_id_seance,p_id_lieu,p_comm_interv,p_tarif_interv,p_fact_interv,p_num_interv);
	elseif (p_etat = 'D') then
		delete from interv where id_interv=p_id_interv;
	end if;
end