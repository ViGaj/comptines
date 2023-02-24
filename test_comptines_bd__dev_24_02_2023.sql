-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 24 fév. 2023 à 13:13
-- Version du serveur : 5.7.36
-- Version de PHP : 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `test_comptines`
--
CREATE DATABASE IF NOT EXISTS `test_comptines` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test_comptines`;

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `ap_debog`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ap_debog` (`p_msg` VARCHAR(200))  begin
	declare v_date_debog datetime;
	select current_date() into v_date_debog;
	insert into debog(date_msg,msg) values (v_date_debog,p_msg);
end$$

DROP PROCEDURE IF EXISTS `AZcmptMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZcmptMaj` (IN `p_etat` CHAR, IN `p_id_cmpt` INT, IN `p_nom_cmpt` VARCHAR(30), IN `p_id_instr` INT, IN `p_grands` INT, IN `p_moyens` INT, IN `p_petits` INT)  begin
    if(p_id_instr = 0) then
    	set p_id_instr = NULL;
    end if;
	if (p_etat ='U') then
	update cmpt set nom_cmpt=p_nom_cmpt,id_instr=p_id_instr,grands=p_grands,moyens=p_moyens,petits=p_petits where id_cmpt=p_id_cmpt;
	elseif (p_etat = 'I') then
		insert into cmpt (nom_cmpt,id_instr,grands,moyens,petits) values (p_nom_cmpt,p_id_instr,p_grands,p_moyens,p_petits);
	elseif (p_etat = 'D') then
		delete from cmpt where id_cmpt=p_id_cmpt;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZcmptSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZcmptSelect` ()  begin
	SELECT '' as etat,c.nom_cmpt,c.id_instr, c.id_cmpt,i.nom_instr as id_instrWITH,c.grands,c.moyens,c.petits
    FROM `cmpt` as c
    LEFT JOIN `instr` as i ON c.id_instr=i.id_instr
    ORDER BY nom_cmpt;
 end$$

DROP PROCEDURE IF EXISTS `AZcmpt__seanceMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZcmpt__seanceMaj` (IN `p_etat` CHAR, IN `p_id_seance_cmpt` INT, IN `p_id_cmpt` INT, IN `p_id_seance` INT)  begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update seance_cmpt set id_seance=p_id_seance,id_cmpt=p_id_cmpt where id_seance_cmpt=p_id_seance_cmpt;
	elseif (p_etat = 'I') then
		insert into seance_cmpt (id_seance,id_cmpt) values (p_id_seance,p_id_cmpt);
	elseif (p_etat = 'D') then
		delete from seance_cmpt where id_seance_cmpt=p_id_seance_cmpt;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZetat_prsMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZetat_prsMaj` (`p_etat` CHAR, `p_id_etat_prs` INT, `p_nom_etat_prs` VARCHAR(50), `p_actif` BIT)  begin
-- declare v_date_debog datetime;
-- declare v_actif varchar(5);
	if (p_etat ='U') then
-- select current_datetime() into v_date_debog;
-- set v_actif=convert(p_actif,char);
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZetat_prsMaj: actif=(',v_actif,')'));
--		if(p_actif = B'0') then
--			update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=B'0' where id_etat_prs=p_id_etat_prs;
--		elseif (p_actif = B'1') then
--			update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=B'1' where id_etat_prs=p_id_etat_prs;
--		end if;
		update etat_prs set nom_etat_prs=p_nom_etat_prs,actif=p_actif where id_etat_prs=p_id_etat_prs;
	elseif (p_etat = 'I') then
		insert into etat_prs (nom_etat_prs,actif) values (p_nom_etat_prs,p_actif);
	elseif (p_etat = 'D') then
		delete from etat_prs where id_etat_prs=p_id_etat_prs;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZetat_prsSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZetat_prsSelect` ()  begin
	select '' as etat,id_etat_prs,nom_etat_prs,actif from etat_prs order by nom_etat_prs;
end$$

DROP PROCEDURE IF EXISTS `AZinit_cbo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinit_cbo` (IN `p_nom_tab` VARCHAR(200))  begin
	if (p_nom_tab='prs') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2;
    elseif(p_nom_tab='seance') then
		select id_seance,nom_seance from seance where nom_seance is not null order by 2;
    elseif(p_nom_tab='lieu') then
		select id_lieu,nom_lieu from lieu order by 2;
    elseif(p_nom_tab='cmpt') then
		select id_cmpt,nom_cmpt from cmpt order by 2;
	elseif(p_nom_tab='instr') then
		select id_instr,nom_instr from instr order by 2;
	elseif(p_nom_tab='etat_prs') then
		select id_etat_prs,nom_etat_prs from etat_prs order by 2;
	elseif (p_nom_tab='prs_login') then
		select id_prs,concat(nom_prs,' ',prenom_prs) from prs order by 2 desc;
	elseif (p_nom_tab='actions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transactions') then
		select id_actions,nom from actions order by 2;
	elseif (p_nom_tab='transetat') then
		select id_transetat,lib_transetat from transetat order by 2;
    elseif (p_nom_tab='type_lieu') then
		select id_type_lieu,lib_type_lieu from type_lieu order by 2;
    elseif (p_nom_tab='ville') then
		select id_ville,nom_ville from ville order by 2;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZinit_cbo_bis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinit_cbo_bis` (IN `p_nom_tab` VARCHAR(200), IN `p_id` INT)  begin
	if(p_nom_tab='cmpt') then
		select id_cmpt,nom_cmpt from cmpt order by 2;
	elseif (p_nom_tab='transetat') then
		select id_transetat,lib_transetat from transetat order by 2;
    elseif(p_nom_tab='seance') then
		select id_seance,nom_seance from seance order by 2;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZinstrMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinstrMaj` (IN `p_etat` CHAR, IN `p_id_instr` INT, IN `p_nom_instr` VARCHAR(30))  begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update instr set nom_instr=p_nom_instr where id_instr=p_id_instr;
	elseif (p_etat = 'I') then
		insert into instr (nom_instr) values (p_nom_instr);
	elseif (p_etat = 'D') then
		delete from instr where id_instr=p_id_instr;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZinstrSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinstrSelect` ()  begin
	SELECT '' as etat,id_instr,nom_instr
    FROM `instr`
    ORDER BY id_instr;
 end$$

DROP PROCEDURE IF EXISTS `AZinterv__intervMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__intervMaj` (IN `p_etat` CHAR, IN `p_id_interv` INT, IN `p_date_interv` DATETIME, IN `p_id_seance` INT, IN `p_id_lieu` INT, IN `p_comm_interv` VARCHAR(150), IN `p_tarif_interv` FLOAT, IN `p_fact_interv` BOOLEAN, IN `p_num_interv` VARCHAR(8))  begin
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
end$$

DROP PROCEDURE IF EXISTS `AZinterv__intervSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__intervSelect` (IN `p_id_interv` INT)  begin
	select '' as etat,i.id_interv,i.date_interv,i.id_seance,i.id_lieu,i.comm_interv,i.tarif_interv,i.fact_interv,i.num_interv,l.id_lieu,l.nom_lieu
	from interv i
    inner join lieu l on l.id_lieu=i.id_lieu
	where i.id_interv=p_id_interv;
end$$

DROP PROCEDURE IF EXISTS `AZinterv__interv_cmptMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__interv_cmptMaj` (IN `p_etat` CHAR, IN `p_id_interv_cmpt` INT, IN `p_id_interv` INT, IN `p_id_cmpt` INT)  begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update interv_cmpt set id_interv=p_id_interv,id_cmpt=p_id_cmpt
        where id_interv_cmpt=p_id_interv_cmpt;
	elseif (p_etat = 'I') then
		insert into interv_cmpt (id_interv,id_cmpt)
        values (p_id_interv,p_id_cmpt);
	elseif (p_etat = 'D') then
		delete from interv_cmpt where id_interv_cmpt=p_id_interv_cmpt;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZinterv__interv_cmptSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__interv_cmptSelect` (IN `p_id_interv` INT)  begin
	select '' as etat,concat(i.date_interv,' ',l.nom_lieu) as id_intervWITH,c.nom_cmpt as id_cmptWITH,ic.ordre,ic.id_cmpt
    from interv i
    left join lieu l on l.id_lieu=i.id_lieu
    left join interv_cmpt ic on i.id_interv=ic.id_interv
    left join cmpt c on c.id_cmpt=ic.id_cmpt
	where ic.id_interv=p_id_interv;
end$$

DROP PROCEDURE IF EXISTS `AZinterv__recherche`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__recherche` (IN `p_id_interv` INT, IN `p_date_interv_mini` DATE, IN `p_date_interv_maxi` DATE, IN `p_id_seance` INT, IN `p_id_lieu` INT)  begin
select i.id_interv,i.date_interv,i.id_seance,i.id_lieu,i.comm_interv,i.tarif_interv,i.fact_interv,i.num_interv,s.id_seance,s.nom_seance,l.id_lieu,l.nom_lieu
	from interv i
    left join seance s
    on i.id_seance=s.id_seance
    left join lieu l
    on l.id_lieu=i.id_lieu
	where (i.date_interv > p_date_interv_mini OR p_date_interv_mini is null) AND (i.date_interv < p_date_interv_maxi OR p_date_interv_maxi is null) AND (i.id_seance = p_id_seance OR p_id_seance is null) AND (i.id_lieu = p_id_lieu OR p_id_lieu is null)
	ORDER BY i.date_interv desc;
end$$

DROP PROCEDURE IF EXISTS `AZinterv__seance_cmptSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZinterv__seance_cmptSelect` (IN `p_id_interv` INT)  select '' as etat,concat(i.date_interv,' ',l.nom_lieu) as id_intervWITH,i.id_seance,c.nom_cmpt
from interv i
left join lieu l on l.id_lieu=i.id_lieu
left join seance_cmpt sc on i.id_seance=sc.id_seance
left join cmpt c on c.id_cmpt=sc.id_cmpt
where i.id_interv=p_id_interv$$

DROP PROCEDURE IF EXISTS `AZlieuMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZlieuMaj` (IN `p_etat` CHAR, IN `p_id_lieu` INT, IN `p_nom_lieu` VARCHAR(100), IN `p_ad_lieu` VARCHAR(100), IN `p_id_ville` INT, IN `p_lat_lieu` FLOAT, IN `p_lon_lieu` FLOAT, IN `p_id_type_lieu` INT)  begin
	if (p_etat ='U') then
		update lieu set nom_lieu=p_nom_lieu,ad_lieu=p_ad_lieu,id_ville=p_id_ville,lat_lieu=p_lat_lieu,lon_lieu=p_lon_lieu,id_type_lieu=p_id_type_lieu where id_lieu=p_id_lieu;
	elseif (p_etat = 'I') then
		insert into lieu (nom_lieu,ad_lieu,id_ville,lat_lieu,lon_lieu,id_type_lieu) values (p_nom_lieu,p_ad_lieu,p_id_ville,p_lat_lieu,p_lon_lieu,p_id_type_lieu);
	elseif (p_etat = 'D') then
		delete from lieu where id_lieu=p_id_lieu;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZlieuSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZlieuSelect` ()  begin
	SELECT '' as etat,l.id_lieu,l.nom_lieu,l.ad_lieu,v.id_ville,v.nom_ville as id_villeWITH,l.lat_lieu,l.lon_lieu,t.id_type_lieu,t.lib_type_lieu as id_type_lieuWITH
    FROM lieu l
    INNER JOIN type_lieu t ON l.id_type_lieu = t.id_type_lieu
    LEFT OUTER JOIN ville v ON l.id_ville = v.id_ville
    ORDER BY nom_lieu asc;
 end$$

DROP PROCEDURE IF EXISTS `AZlister_interventions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZlister_interventions` (IN `p_id_lieu` INT, IN `p_id_interv` INT)  begin
    select concat('<a href=@@url@@?p=@@prs@@|1|1|',i.id_interv,'|@@fonte@@ target="_blank">',i.date_interv,'</a>') as vignette
        from interv i
        where i.id_interv=p_id_interv;
end$$

DROP PROCEDURE IF EXISTS `AZlister_lieux`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZlister_lieux` ()  begin
SELECT l.nom_lieu,l.ad_lieu,l.id_ville,l.lat_lieu,l.lon_lieu,v.nom_ville,t.lib_type_lieu,AZlister_interventions_par_lieu(l.id_lieu) as liste_interv
FROM lieu l
LEFT OUTER JOIN ville v ON l.id_ville = v.id_ville
INNER JOIN type_lieu t ON l.id_type_lieu = t.id_type_lieu;
end$$

DROP PROCEDURE IF EXISTS `AZmdp_prs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZmdp_prs` (`p_id_prs` INT, `p_cle` VARCHAR(200))  begin
	update prs set cle=p_cle where id_prs=p_id_prs;
	select 'OK';
end$$

DROP PROCEDURE IF EXISTS `AZprs__prsMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZprs__prsMaj` (`p_etat` CHAR, `p_id_prs` INT, `p_nom_prs` VARCHAR(30), `p_prenom_prs` VARCHAR(20), `p_id_etat_prs` INT)  begin
	if (p_etat ='U') then
		update prs set nom_prs=p_nom_prs,prenom_prs=p_prenom_prs,id_etat_prs=p_id_etat_prs where id_prs=p_id_prs;
	elseif (p_etat = 'I') then
		insert into prs (nom_prs,prenom_prs,id_etat_prs) values (p_nom_prs,p_prenom_prs,1);
	elseif (p_etat = 'D') then
		delete from prs where id_prs=p_id_prs;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZprs__prsSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZprs__prsSelect` (IN `p_id_prs` INT)  begin
	select '' as etat,p.id_prs,p.nom_prs,p.prenom_prs,p.id_etat_prs,e.nom_etat_prs as id_etat_prsWITH,e.actif
	from prs p
	inner join etat_prs e on p.id_etat_prs=e.id_etat_prs
 where id_prs=p_id_prs;
 end$$

DROP PROCEDURE IF EXISTS `AZseance__recherche`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZseance__recherche` (IN `p_id_prs` INT, IN `p_id_seance` VARCHAR(20))  begin
	select S.id_seance,S.num_seance,S.nom_seance
	from seance S
		where 1=1
			and (S.id_seance like p_id_seance or p_id_seance is null)
    	order by num_seance asc;
end$$

DROP PROCEDURE IF EXISTS `AZseance__seanceMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZseance__seanceMaj` (IN `p_etat` CHAR, IN `p_id_seance` INT, IN `p_nom_seance` VARCHAR(50), IN `p_num_seance` INT)  begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update seance set nom_seance=p_nom_seance,num_seance=p_num_seance where id_seance=p_id_seance;
	elseif (p_etat = 'I') then
		insert into seance (nom_seance,num_seance) values (p_nom_seance,p_num_seance);
	elseif (p_etat = 'D') then
		delete from seance where id_seance=p_id_seance;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZseance__seanceSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZseance__seanceSelect` (IN `p_id_seance` INT)  begin
	select '' as etat,s.id_seance,s.nom_seance,s.num_seance
	from seance s
	where id_seance=p_id_seance;
end$$

DROP PROCEDURE IF EXISTS `AZseance__seance_cmptMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZseance__seance_cmptMaj` (IN `p_etat` CHAR, IN `p_id_seance_cmpt` INT, IN `p_id_seance` INT, IN `p_id_cmpt` INT)  begin
	if (p_etat ='U') then
-- select current_date() into v_date_debog;
-- insert into debog(date_msg,msg) values (v_date_debog,concat('AZloge__tenueMaj: lib_tenue=',p_lib_tenue));
		update seance_cmpt set id_cmpt=p_id_cmpt,id_seance=p_id_seance
        where id_seance_cmpt=p_id_seance_cmpt;
	elseif (p_etat = 'I') then
		insert into seance_cmpt (id_seance,id_cmpt) values (p_id_seance,p_id_cmpt);
	elseif (p_etat = 'D') then
		delete from seance_cmpt where id_seance_cmpt=p_id_seance_cmpt;
	end if;
end$$

DROP PROCEDURE IF EXISTS `AZseance__seance_cmptSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZseance__seance_cmptSelect` (IN `p_id_seance` INT)  begin
	select '' as etat,C.id_cmpt,C.nom_cmpt as id_cmptWITH,C.id_instr,I.nom_instr,S.id_cmpt,S.id_seance_cmpt,S.id_seance
	from cmpt C    
    left join instr I
    on I.id_instr=C.id_instr
    inner join seance_cmpt S
	on S.id_seance=p_id_seance
    where S.id_cmpt=C.id_cmpt
    and nom_cmpt=C.nom_cmpt;
end$$

DROP PROCEDURE IF EXISTS `AZvalider_prs_mdp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZvalider_prs_mdp` (`p_id_prs` INT, `p_cle` VARCHAR(200))  begin
	declare v_nb int;
	declare v_ret varchar(10);
	declare v_niv_lec int;
	declare v_niv_ecr int;
	declare v_niv_exp int;
	select count(*) into v_nb from prs where id_prs=p_id_prs and mdp=p_cle;
	if(v_nb>0)then
		select case isnull(nivo_lec) when 1 then 1 else nivo_lec end,
			case isnull(nivo_ecr) when 1 then 1 else nivo_ecr end,
			case isnull(nivo_exp) when 1 then 1 else nivo_exp end
			 into v_niv_lec,v_niv_ecr,v_niv_exp
			from prs where id_prs=p_id_prs;
		set v_ret=concat(v_niv_lec,'|',v_niv_ecr,'|',v_niv_exp);
	else
		set v_ret='-1|-1|-1';
	end if;
	select v_ret;
end$$

DROP PROCEDURE IF EXISTS `AZvilleMaj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZvilleMaj` (IN `p_etat` CHAR, IN `p_id_ville` INT, IN `p_nom_ville` VARCHAR(30))  begin
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

DROP PROCEDURE IF EXISTS `AZvilleSelect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AZvilleSelect` ()  begin
	SELECT '' as etat,id_ville,nom_ville
    FROM `ville`
    ORDER BY id_ville;
 end$$

DROP PROCEDURE IF EXISTS `lec_dependances`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lec_dependances` (`p_sens` VARCHAR(1), `p_nom_tab` VARCHAR(50), `p_tab_id` VARCHAR(500), `p_max_lignes` INT, `p_profondeur` INT)  begin
	declare	v_fini int;
	declare	v_tab_id_tmp varchar(500);
	declare	v_pos int;
	declare	v_id int;
	declare	v_tmp varchar(500);
	declare	v_msmt bit;
	declare v_nb int;
	declare v_ret_recurs char(2);
SET @@GLOBAL.max_sp_recursion_depth = 7;
SET @@SESSION.max_sp_recursion_depth = 7;
-- print 'lec_dependances('+@sens+','+@nom_tab+','+@tab_id+','+convert(varchar,@max_lignes)+','+convert(varchar,@profondeur)+')'
	select locate(';',p_tab_id) into v_pos;
	if (v_pos = 0) then
		set p_tab_id=concat(p_tab_id,';');
	end if;
	select count(*) into v_nb from information_schema.innodb_temp_table_info where name='temp_dep'; -- where n_cols=8;
-- call ap_debog(concat('nb pour temp_dep=',v_nb));
	if(v_nb = 0) then
--		 call ap_debog('avant creer temp table');
		create temporary table temp_dep (id_dep int not null auto_increment,primary key(id_dep),niv int,nom_tab varchar(40),id int,info varchar(300));
	else
		delete from temp_dep;
	end if;
	/*
	select count(*) into v_nb from information_schema.innodb_temp_table_info where n_cols=6; -- where name='temp_dep';
-- call ap_debog(concat('nb pour temp_tab_cle=',v_nb));
	if(v_nb = 0) then
		create temporary table temp_tab_cle (ind int not null auto_increment,primary key(ind),niveau int,nom_col varchar(80),nom_tab2 varchar(80),nom_col2 varchar(80),nom_pk varchar(80));
	end if;
	*/
	select count(*) into v_nb from information_schema.innodb_temp_table_info where name='temp_tab_id'; -- where n_cols=6;
-- call ap_debog(concat('nb pour temp_tab_id=',v_nb));
	if(v_nb = 0) then
		create temporary table temp_tab_id (ind int not null auto_increment,primary key(ind),niveau int,id int);
	else
		delete from temp_tab_id;
	end if;
-- call ap_debog ('lec_dep_recurs 2');
-- call ap_debog('apres creer temp table');
	set v_fini=0;
	set v_tab_id_tmp=p_tab_id;
	while (v_fini = 0) do
-- call ap_debog('avant locate');
		select locate(';',v_tab_id_tmp) into v_pos;
-- call ap_debog(concat('apres locate, v_pos=',v_pos));
-- call ap_debog(concat('v_tab_id=',v_tab_id_tmp,', v_pos=(',v_pos,')'));
-- print 'pos='+convert(varchar,@pos)
		if (v_pos <= 0) then
			set v_fini=1;
		else
			if (v_pos > 1) then
-- call ap_debog(concat('avant v_id=substring..:tab_id_tmp=(',v_tab_id_tmp,'), v_pos=',v_pos));
				set v_id=substring(v_tab_id_tmp,1,v_pos-1);
-- call ap_debog('apres v_id=substring...');
--				set v_id=convert(v_tmp as int(10));
-- print 'id='+convert(varchar,@id)
-- print 'profondeur='+convert(varchar,@profondeur)
-- call ap_debog('avant appel lec_dep_recurs');
				call lec_dep_recurs (p_sens,p_nom_tab,v_id,0,p_max_lignes,p_profondeur,v_ret_recurs);
-- call ap_debog('apres appel lec_dep_recurs');
			end if;
-- call ap_debog('avant v_tmp');
			select substring(v_tab_id_tmp,v_pos+1,999) into v_tmp;
-- call ap_debog('apres v_tmp');
			set v_tab_id_tmp=v_tmp;
-- call ap_debog(concat('apres v_tab_id, v_tab_id_tmp=',v_tab_id_tmp));
		end if;
	end while;
-- call ap_debog('avant drop tab_id');
--	drop table temp_tab_id;
-- call ap_debog('avant drop tab_cle');
--	drop table temp_tab_cle;
-- call ap_debog('apres drop tab_cle');
--	select @msmt=msmt from prj
--	select id_dep,niv,nom_tab,isnull(sql,dbo.fct_rep_dependances(nom_tab,id,@msmt)) as rep,id from #dep order by id_dep
--	select id_dep,niv,nom_tab,dbo.fct_rep_dependances(nom_tab,id,@msmt) as rep,id from #dep order by id_dep
--	select id_dep,niv,nom_tab,fct_rep(nom_tab,id) as rep,id,info from temp_dep order by id_dep;
-- insert into debog(msg) select concat(id_dep,',',niv,',',nom_tab,',',id,',',info) from temp_dep;
-- call ap_debog('apres insert into temp_dep');
	select niv,case isnull(lib_tab) when 1 then t.nom_tab else lib_tab end as nom_tab,id,fct_rep(t.nom_tab,id) as rep,info
	from temp_dep t left outer join AZtab on t.nom_tab=AZtab.nom_tab order by id_dep;
--	drop table temp_tab_cle;
	drop table temp_tab_id;
	drop table temp_dep;
end$$

DROP PROCEDURE IF EXISTS `lec_dep_recurs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lec_dep_recurs` (IN `p_sens` VARCHAR(1), IN `p_nom_tab` VARCHAR(50), IN `p_id` INT, `p_niveau` INT, IN `p_max_lignes` INT, IN `p_profondeur` INT, OUT `p_retour` CHAR(2))  begin
	declare	v_niv2 int;
--	declare	v_nb_cles int;
--	declare	v_nom_col varchar(80);
	declare	v_nom_tab_fk varchar(80);
	declare	v_nom_tab_pk varchar(80);
	declare	v_nom_col_fk varchar(80);
	declare	v_nom_col_fk_pk varchar(80);
	declare	v_i	int;
--	declare	v_j	int;
	declare	v_id2 int;
--	declare	v_nb_id	int;
	declare	v_sql varchar(300);
	declare	v_nb_dep int;
--	declare	v_err int;
	declare	v_faire	int;
	declare	v_num_instr int;
	declare	v_msg_erreur varchar(500);
--	declare	v_val_erreur varchar(50);
--	declare	v_ajout int;
--	declare	v_min_ind int;
--	declare	v_max_ind int;
--	declare	v_ligne varchar(50);
	declare	v_nb int;
--	declare	v_app_ds_dep bit;
--	declare v_min_cle int;
--	declare v_max_cle int;
	declare v_retour_recurs char(2);
	declare v_curseur_ok int default 1;
	declare v_debog bit;
	declare v_nom_tab2 varchar(30);
	declare v_req_sql varchar(200);
	declare c_cles_b cursor for
		select nom_tab_fk,nom_col_fk,nom_col_fk_pk
		FROM info_sch_fk where nom_tab_pk=p_nom_tab
		order by 1,2,3;
		/*
		select RC.TABLE_NAME AS FK_TABLE_NAME,KCU.COLUMN_NAME,KCU.REFERENCED_COLUMN_NAME,KCU2.COLUMN_NAME
		FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC
		inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK on FK.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA and FK.CONSTRAINT_NAME = RC.CONSTRAINT_NAME and FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU on KCU.CONSTRAINT_NAME=RC.CONSTRAINT_NAME
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 on KCU2.TABLE_NAME=RC.TABLE_NAME
		where rc.referenced_table_NAME=p_nom_tab and KCU2.CONSTRAINT_NAME='PRIMARY'
		order by 1,2,3;
		*/
	declare c_cles_h cursor for
		select nom_tab_pk,nom_col_fk,nom_col_fk_pk
		FROM info_sch_fk where nom_tab_fk=p_nom_tab
		order by 1,2,3;
		/*
		select RC.REFERENCED_TABLE_NAME AS FK_TABLE_NAME,KCU.COLUMN_NAME,KCU.REFERENCED_COLUMN_NAME,KCU2.COLUMN_NAME
		FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC
		inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK on FK.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA and FK.CONSTRAINT_NAME = RC.CONSTRAINT_NAME and FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU on KCU.CONSTRAINT_NAME=RC.CONSTRAINT_NAME
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 on KCU2.TABLE_NAME=RC.TABLE_NAME
		where rc.table_NAME=p_nom_tab and KCU2.CONSTRAINT_NAME='PRIMARY'
		order by 1,2,3;
		*/
	declare c_id cursor for select id FROM temp_tab_id where niveau=p_niveau;
	declare continue handler for not found set v_curseur_ok=0;
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		set v_msg_erreur=concat('Erreur SQL :',@text);
		if (p_sens = 'B') then
			insert into temp_dep (niv,nom_tab,id,info) values (p_niveau+1,v_nom_tab_fk,null,v_msg_erreur);
		else
			insert into temp_dep (niv,nom_tab,id,info) values (p_niveau+1,p_nom_tab,null,v_msg_erreur);
		end if;
		set p_retour='KO';
--		drop table temp_id;
	END;
	set v_debog=1;
	if(v_debog=1) then
		call ap_debog(concat('debut de lec_dep_recurs(',p_sens,',',p_nom_tab,',',p_id,',',p_niveau,',',p_profondeur,')'));
	end if;
	/*
	if (p_niveau > 0) then
		select count(*) into v_nb from temp_dep where nom_tab=p_nom_tab and id=p_id;
		if (v_nb = 0) then
-- call ap_debog(concat('insertion d''une dependance(niveau=',p_niveau,', nom_tab=',p_nom_tab,', id=',p_id));
			insert into temp_dep (niv,nom_tab,id) values (p_niveau,p_nom_tab,p_id);
			set v_faire=1;
		else
			set v_faire=0;
		end if;
	else
		set v_faire=1;
	end if;
	*/
	select count(*) into v_nb from temp_dep where nom_tab=p_nom_tab and id=p_id;
	if (v_nb = 0) then
-- call ap_debog(concat('insertion d''une dependance(niveau=',p_niveau,', nom_tab=',p_nom_tab,', id=',p_id));
		insert into temp_dep (niv,nom_tab,id) values (p_niveau,p_nom_tab,p_id);
		set v_faire=1;
	else
		set v_faire=0;
	end if;
-- call ap_debog ('lec_dep_recurs 4');
	set v_niv2=p_niveau+1;
	if (v_faire>0 and v_niv2<32 and v_niv2<=p_profondeur) then-- Nombre d'imbrication dans T-sql doit �tre inf�rieur a 32
-- call ap_debog ('lec_dep_recurs 5');
		if (p_sens = 'B') then
			if (p_nom_tab = 'prsaaa') then
				set v_nb=0;
			else
				set v_faire=1;
			end if;
		else
			set v_faire=1;
		end if;
		if (v_faire>0) then
-- call ap_debog ('lec_dep_recurs 6');
			if (p_sens = 'B') then
				open c_cles_b;
			else
				open c_cles_h;
			end if;
-- call ap_debog ('lec_dep_recurs 7');
			set v_curseur_ok=1;
			while(v_curseur_ok=1) do
				if(p_sens = 'B') then
					fetch c_cles_b into v_nom_tab_fk,v_nom_col_fk,v_nom_col_fk_pk;
				else
					fetch c_cles_h into v_nom_tab_pk,v_nom_col_fk,v_nom_col_fk_pk;
				end if;
				if(v_curseur_ok=1) then
-- call ap_debog ('lec_dep_recurs 8');
--					delete from temp_tab_id where niveau=p_niveau;
--				create temporary table temp_tab_id (ind int not null auto_increment, primary key(ind),id int);
					if (p_sens = 'B') then
--						select @sql='declare lect_id cursor global for select '+@nom_pk+' from '+@nom_tab2+' where '+@nom_col2+'='+convert(varchar,@id)
-- call ap_debog ('6');
						set v_nom_tab2=v_nom_tab_fk;
						set v_req_sql=concat('insert into temp_tab_id(niveau,id) select ',p_niveau,',',v_nom_col_fk_pk,' from ',v_nom_tab2,' where ',v_nom_col_fk,'=',convert(p_id,char));
-- call ap_debog ('7');
-- call ap_debog(v_req_sql);
-- call ap_debog ('7 bis');
--						set @sql=concat('create or replace view temp_id as select ',v_nom_col_fk_pk,' as id from ',v_nom_tab2,' where ',v_nom_col_fk,'=',convert(p_id,char));
					else
						set v_req_sql=concat('insert into temp_tab_id(niveau,id) select ',p_niveau,',',v_nom_col_fk,' from ',p_nom_tab,' where ',v_nom_col_fk_pk,'=',convert(p_id,char));
--						select @sql='declare lect_id cursor global for select '+@nom_col+' from '+@nom_tab+' where id_'+@nom_tab+'='+convert(varchar,@id)
-- call ap_debog ('6');
						set v_nom_tab2=v_nom_tab_pk;
--						set @sql=concat('create or replace view temp_id as select ',v_nom_col_fk,' as id from ',p_nom_tab,' where ',v_nom_col_fk_pk,'=',convert(p_id,char));
-- call ap_debog ('7');
					end if;
					if(v_debog=1) then
						call ap_debog(concat('sql dyn=',v_req_sql));
					end if;
-- print 'sql='+isnull(@sql,'sql')
--					call sp_executesql (v_sql);
					set @sql=v_req_sql;
					prepare stmt from @sql;
					execute stmt;
					deallocate prepare stmt;
-- call ap_debog('apres exec sql dyn');
					open c_id;
					set v_curseur_ok=1;
					while(v_curseur_ok=1) do
						fetch c_id into v_id2;
						if(v_curseur_ok=1) then
							if (v_id2>0) then
								select count(*) into v_nb_dep from temp_dep;
-- call ap_debog(concat('v_nb_dep=',v_nb_dep));
								if (v_nb_dep < p_max_lignes) then
									set v_niv2=p_niveau+1;
-- call ap_debog(concat('v_niv2=',v_niv2));
									if (v_niv2<32 and v_niv2<=p_profondeur) then -- Nombre d'imbrication dans T-sql doit �tre inf�rieur � 32
										if(v_debog=1) then
											call ap_debog(concat('avant appel recursif(',p_sens,',',v_nom_tab2,',',v_id2,',',v_niv2,')'));
										end if;
										call lec_dep_recurs (p_sens,v_nom_tab2,v_id2,v_niv2,p_max_lignes,p_profondeur,v_retour_recurs);
										if(v_debog=1) then
											call ap_debog('apres appel recursif');
										end if;
									end if;
								end if;
							end if;
						end if;
					end while;
					if(v_debog=1) then
						call ap_debog('fin boucle sur les id');
					end if;
					delete from temp_tab_id where niveau=p_niveau;
					close c_id;
					set v_curseur_ok=1;
				end if;
				set v_i=v_i+1;
			end while;
			if(p_sens='B')then
				close c_cles_b;
			else
				close c_cles_h;
			end if;
			if(v_debog=1) then
				call ap_debog('fin boucle sur les cles');
			end if;
		end if;
	end if;
	set p_retour='OK';
-- print 'fin de lec_dep_recurs('+@sens+','+@nom_tab+','+convert(varchar,@id)+','+convert(varchar,@niveau)+','+convert(varchar,@profondeur)+')'
end$$

DROP PROCEDURE IF EXISTS `valider_prs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `valider_prs` (`p_id_prs` INT, `p_cle` VARCHAR(200))  begin
	declare v_nb int;
	declare v_ret char(2);
	select count(*) into v_nb from prs where id_prs=p_id_prs and cle=p_cle;
	set v_ret=case v_nb when 1 then 'OK' else 'KO' end;
	select v_ret;
end$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `AZcentrer_carte`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `AZcentrer_carte` (`p_id_lieu` INT) RETURNS VARCHAR(40) CHARSET latin1 begin
    declare v_lat_lon_zoom varchar(40);
    declare v_lat decimal(10,6);
    declare v_lon decimal(10,6);
    declare v_zoom int;
    set v_lat_lon_zoom='46.303558,6.0164252,0';
    if (p_id_lieu is not null) then
		if(p_id_lieu=0) then
			select moy_lat,moy_lon into v_lat,v_lon from centre_lieux;
		else
        	select lat_lieu,lon_lieu into v_lat,v_lon from lieu where id_lieu=p_id_lieu;
		end if;
        if(v_lat is not null and v_lon is not null) then
            set v_lat_lon_zoom=concat(v_lat,',',v_lon,',17');
			if(v_lat=0 or v_lon=0) then
				set v_lat_lon_zoom='46.303558,6.0164252,6';
			end if;
        end if;
    end if;
    return v_lat_lon_zoom;
end$$

DROP FUNCTION IF EXISTS `AZlister_interventions_par_lieu`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `AZlister_interventions_par_lieu` (`p_id_lieu` INT) RETURNS VARCHAR(200) CHARSET latin1 begin
    declare v_liste_interv varchar(200) default '';
    declare v_id_interv int;
    declare v_date_interv varchar(50);
    declare v_c_interv_ok int default 1;
    declare c_interv cursor for select id_interv,date_interv from interv where id_lieu=p_id_lieu order by 2;
    declare continue handler for not found set v_c_interv_ok=0;
    open c_interv;
    while(v_c_interv_ok=1) do
        fetch c_interv into v_id_interv,v_date_interv;
        if(v_c_interv_ok=1) then        
            if(length(v_liste_interv)>0) then
                set v_liste_interv=concat(v_liste_interv,'§');
            end if;
            set v_liste_interv=concat(v_liste_interv,concat(v_id_interv,'#',v_date_interv));
        end if;
    end while;
    close c_interv;
    return v_liste_interv;
end$$

DROP FUNCTION IF EXISTS `fct_rep`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fct_rep` (`nom_tab` VARCHAR(30), `id` INT) RETURNS VARCHAR(500) CHARSET latin1 begin
	declare rep varchar(500) default '';
	declare id_bis int;
	declare id_ter int;
	declare v_temp varchar(500);
	if(nom_tab='AZecr') then
		select nom_ecr into rep from AZecr where id_AZecr=id;
	elseif(nom_tab='AZonglet') then
		select entete into rep from AZonglet where id_AZonglet=id;
	elseif(nom_tab='AZtype_champ') then
		select nom_type_champ into rep from AZtype_champ where id_AZtype_champ=id;
	elseif(nom_tab='cmpt') then
		select nom_cmpt into rep from cmpt where id_cmpt=id;
    elseif(nom_tab='instr') then
		select nom_instr into rep from instr where id_instr=id;
    elseif(nom_tab='lieu') then
		select nom_lieu into rep from lieu where id_lieu=id;
	elseif(nom_tab='interv') then
		select concat(convert(i.date_interv,char)," ; ",i.comm_interv) into rep from interv i
		where i.id_interv=id;
	elseif(nom_tab='prs') then
		select concat(nom_prs,' ',prenom_prs) into rep from prs where id_prs=id;
	else
		set rep=concat(nom_tab,id);
	end if;
	return rep;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `aztab`
--

DROP TABLE IF EXISTS `aztab`;
CREATE TABLE IF NOT EXISTS `aztab` (
  `nom_tab` varchar(30) NOT NULL,
  `lib_tab` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `aztab`
--

INSERT INTO `aztab` (`nom_tab`, `lib_tab`) VALUES
('cmpt', 'Comptines'),
('instr', 'Instruments'),
('interv', 'Interventions'),
('lieu', 'Lieux'),
('seance', 'Séances');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `centre_lieux`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `centre_lieux`;
CREATE TABLE IF NOT EXISTS `centre_lieux` (
`moy_lat` double
,`moy_lon` double
);

-- --------------------------------------------------------

--
-- Structure de la table `cmpt`
--

DROP TABLE IF EXISTS `cmpt`;
CREATE TABLE IF NOT EXISTS `cmpt` (
  `id_cmpt` int(11) NOT NULL AUTO_INCREMENT,
  `nom_cmpt` varchar(30) NOT NULL,
  `id_instr` int(11) DEFAULT NULL,
  `grands` int(1) DEFAULT NULL,
  `moyens` int(1) DEFAULT NULL,
  `petits` int(1) DEFAULT NULL,
  `doc_db` longblob NOT NULL,
  PRIMARY KEY (`id_cmpt`),
  KEY `fk_cmpt__instr` (`id_instr`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `cmpt`
--

INSERT INTO `cmpt` (`id_cmpt`, `nom_cmpt`, `id_instr`, `grands`, `moyens`, `petits`, `doc_db`) VALUES
(1, 'A dada sur mon daudet', NULL, 1, 1, 1, ''),
(2, 'Abeille oreille', 1, NULL, NULL, NULL, ''),
(3, 'Ah les croco', 5, NULL, NULL, NULL, ''),
(4, 'Ainsi font font font', 1, 1, NULL, NULL, ''),
(5, 'Alouette', 4, NULL, NULL, NULL, ''),
(6, 'Allons bon CHUT !', NULL, NULL, NULL, NULL, ''),
(7, 'Petit homme jamais content', NULL, NULL, NULL, NULL, ''),
(8, 'Le jamais content', NULL, NULL, NULL, NULL, ''),
(9, 'Malle magique', NULL, NULL, NULL, NULL, ''),
(10, 'La moufle', NULL, NULL, NULL, NULL, ''),
(11, 'Parapluie rouge', NULL, NULL, NULL, NULL, ''),
(12, 'Mademoiselle Scarabée', NULL, NULL, NULL, NULL, ''),
(13, 'Roule Galette', NULL, NULL, NULL, NULL, ''),
(14, 'Fais dodo gentil Minipoil', 2, NULL, NULL, NULL, ''),
(17, 'Test Angular v15', 3, 1, NULL, NULL, ''),
(19, 'mon test', NULL, NULL, -1, NULL, ''),
(20, 'ABCDEFG', NULL, 1, NULL, NULL, '');

-- --------------------------------------------------------

--
-- Structure de la table `debog`
--

DROP TABLE IF EXISTS `debog`;
CREATE TABLE IF NOT EXISTS `debog` (
  `date_msg` datetime NOT NULL,
  `msg` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `debog`
--

INSERT INTO `debog` (`date_msg`, `msg`) VALUES
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-09 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-09 00:00:00', 'fin boucle sur les cles'),
('2023-01-16 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-16 00:00:00', 'fin boucle sur les cles'),
('2023-01-16 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-16 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,1)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,0,1)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,2)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,5)'),
('2023-01-17 00:00:00', 'fin boucle sur les cles'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-17 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where FK_cmpt_instr=1'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-17 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,2)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,2,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,14,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,14,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,3,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=3'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,1,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,17,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,17,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,lieu,4,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,4,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,5,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,4,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,5,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,5,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=5'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=5'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,11,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,11,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,33,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,33,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,3)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,3)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,3)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,3)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,3)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,3)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,3)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,3)'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=2'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,3,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,3,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,6,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,6,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,13,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,13,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,2)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_interv_cmpt from interv_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 1,id_seance_cmpt from seance_cmpt where id_cmpt=4'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,7,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,7,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,seance_cmpt,9,2)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,9,2,2)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-18 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-18 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-18 00:00:00', 'apres appel recursif'),
('2023-01-18 00:00:00', 'fin boucle sur les id'),
('2023-01-18 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,2)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,2)'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,lieu,4,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=4'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-19 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,lieu,1,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,interv,3,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,interv,3,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,lieu,1,0,1)'),
('2023-01-19 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=1'),
('2023-01-19 00:00:00', 'avant appel recursif(B,interv,3,1)'),
('2023-01-19 00:00:00', 'debut de lec_dep_recurs(B,interv,3,1,1)'),
('2023-01-19 00:00:00', 'apres appel recursif'),
('2023-01-19 00:00:00', 'fin boucle sur les id'),
('2023-01-19 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,4,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=4'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,8,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=8'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,3,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=3'),
('2023-01-24 00:00:00', 'avant appel recursif(B,interv,5,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,interv,5,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,6,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=6'),
('2023-01-24 00:00:00', 'avant appel recursif(B,interv,1,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,interv,1,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,3,0,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=3'),
('2023-01-24 00:00:00', 'avant appel recursif(B,interv,5,1)'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,interv,5,1,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,6,0,1)'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=6'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,4,0,1)'),
('2023-01-24 00:00:00', 'avant appel recursif(B,interv,1,1)'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=4'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,interv,1,1,1)'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'debut de lec_dep_recurs(B,lieu,8,0,1)'),
('2023-01-24 00:00:00', 'apres appel recursif'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=8'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les id'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-24 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,11,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=11'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,cmpt,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv_cmpt,13,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv_cmpt,13,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,38,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,38,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,39,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,39,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,11,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=11'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)');
INSERT INTO `debog` (`date_msg`, `msg`) VALUES
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,10,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=10'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,interv,6,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,interv,6,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,instr,1,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_cmpt from cmpt where id_instr=1'),
('2023-01-25 00:00:00', 'avant appel recursif(B,cmpt,2,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,cmpt,2,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'avant appel recursif(B,cmpt,4,1)'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,cmpt,4,1,1)'),
('2023-01-25 00:00:00', 'apres appel recursif'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-25 00:00:00', 'debut de lec_dep_recurs(B,lieu,11,0,1)'),
('2023-01-25 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv from interv where id_lieu=11'),
('2023-01-25 00:00:00', 'fin boucle sur les id'),
('2023-01-25 00:00:00', 'fin boucle sur les cles'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'fin boucle sur les cles'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'fin boucle sur les cles'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'fin boucle sur les cles'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'fin boucle sur les cles'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,cmpt,1,0,1)'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=1'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,1,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,1,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,2,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,2,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,12,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,12,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,16,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,16,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,19,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,19,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,22,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,22,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,34,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,34,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'avant appel recursif(B,seance_cmpt,35,1)'),
('2023-01-26 00:00:00', 'debut de lec_dep_recurs(B,seance_cmpt,35,1,1)'),
('2023-01-26 00:00:00', 'apres appel recursif'),
('2023-01-26 00:00:00', 'fin boucle sur les id'),
('2023-01-26 00:00:00', 'fin boucle sur les cles'),
('2023-02-23 00:00:00', 'debut de lec_dep_recurs(B,cmpt,20,0,1)'),
('2023-02-23 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_interv_cmpt from interv_cmpt where id_cmpt=20'),
('2023-02-23 00:00:00', 'avant appel recursif(B,interv_cmpt,19,1)'),
('2023-02-23 00:00:00', 'debut de lec_dep_recurs(B,interv_cmpt,19,1,1)'),
('2023-02-23 00:00:00', 'apres appel recursif'),
('2023-02-23 00:00:00', 'fin boucle sur les id'),
('2023-02-23 00:00:00', 'sql dyn=insert into temp_tab_id(niveau,id) select 0,id_seance_cmpt from seance_cmpt where id_cmpt=20'),
('2023-02-23 00:00:00', 'fin boucle sur les id'),
('2023-02-23 00:00:00', 'fin boucle sur les cles');

-- --------------------------------------------------------

--
-- Structure de la table `info_sch_fk`
--

DROP TABLE IF EXISTS `info_sch_fk`;
CREATE TABLE IF NOT EXISTS `info_sch_fk` (
  `nom_tab_fk` varchar(30) DEFAULT NULL,
  `nom_col_fk` varchar(30) DEFAULT NULL,
  `nom_col_fk_pk` varchar(30) DEFAULT NULL,
  `nom_tab_pk` varchar(30) DEFAULT NULL,
  `nom_col_pk` varchar(30) DEFAULT NULL,
  UNIQUE KEY `i_info_sch_bas_1` (`nom_tab_fk`,`nom_col_fk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `info_sch_fk`
--

INSERT INTO `info_sch_fk` (`nom_tab_fk`, `nom_col_fk`, `nom_col_fk_pk`, `nom_tab_pk`, `nom_col_pk`) VALUES
('cmpt', 'id_instr', 'id_cmpt', 'instr', 'id_instr'),
('interv', 'id_lieu', 'id_interv', 'lieu', 'id_lieu'),
('interv', 'id_seance', 'id_interv', 'seance', 'id_seance'),
('interv_cmpt', 'id_cmpt', 'id_interv_cmpt', 'cmpt', 'id_cmpt'),
('interv_cmpt', 'id_interv', 'id_interv_cmpt', 'interv', 'id_interv'),
('seance_cmpt', 'id_cmpt', 'id_seance_cmpt', 'cmpt', 'id_cmpt'),
('seance_cmpt', 'id_seance', 'id_seance_cmpt', 'seance', 'id_seance');

-- --------------------------------------------------------

--
-- Structure de la table `instr`
--

DROP TABLE IF EXISTS `instr`;
CREATE TABLE IF NOT EXISTS `instr` (
  `id_instr` int(11) NOT NULL AUTO_INCREMENT,
  `nom_instr` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_instr`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `instr`
--

INSERT INTO `instr` (`id_instr`, `nom_instr`) VALUES
(1, 'Cloches'),
(2, 'Xylophone'),
(3, 'Guitare'),
(4, 'Piano'),
(5, 'Triangle'),
(6, 'Ligne modifiée!!');

-- --------------------------------------------------------

--
-- Structure de la table `interv`
--

DROP TABLE IF EXISTS `interv`;
CREATE TABLE IF NOT EXISTS `interv` (
  `id_interv` int(11) NOT NULL AUTO_INCREMENT,
  `date_interv` datetime DEFAULT NULL,
  `id_seance` int(11) DEFAULT NULL,
  `id_lieu` int(11) DEFAULT NULL,
  `comm_interv` varchar(150) DEFAULT NULL,
  `tarif_interv` float DEFAULT NULL,
  `fact_interv` bit(1) DEFAULT NULL,
  `num_interv` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id_interv`),
  KEY `fk_interv__seance` (`id_seance`),
  KEY `fk_interv__lieu` (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `interv`
--

INSERT INTO `interv` (`id_interv`, `date_interv`, `id_seance`, `id_lieu`, `comm_interv`, `tarif_interv`, `fact_interv`, `num_interv`) VALUES
(1, '2020-01-04 00:00:00', 5, 6, 'Roule Galette pour les 2 grands (5 enfants)', 660, b'0', '2020-001'),
(2, '2020-02-02 00:00:00', 1, 7, 'Anniversaire Maëlly 4 ans', 30, b'1', '2020-002'),
(3, '2021-01-11 00:00:00', 4, 1, 'Anniv. 3 ans Ilona', 40, b'1', '2020-003'),
(4, '2023-01-09 00:00:00', NULL, 10, NULL, 22, b'1', '2023-002'),
(5, '2022-10-31 00:00:00', 10, 3, NULL, 0, b'0', NULL),
(6, '2023-01-22 00:00:00', 3, 10, 'Test de commentaire du 22/02/2023', 50.98, b'1', '2023-001'),
(8, '2023-01-02 00:00:00', 5, 1, '', 0, b'0', ''),
(9, '2023-01-04 00:00:00', 5, 6, '', 0, b'0', ''),
(10, '2023-02-01 00:00:00', 2, 10, 'bonne ambiance', 0.04, b'0', '2023-000');

-- --------------------------------------------------------

--
-- Structure de la table `interv_cmpt`
--

DROP TABLE IF EXISTS `interv_cmpt`;
CREATE TABLE IF NOT EXISTS `interv_cmpt` (
  `id_interv_cmpt` int(11) NOT NULL AUTO_INCREMENT,
  `id_interv` int(11) DEFAULT NULL,
  `id_cmpt` int(11) DEFAULT NULL,
  `ordre` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_interv_cmpt`),
  KEY `fk_interv_cmpt__interv` (`id_interv`),
  KEY `fk_interv_cmpt__cmpt` (`id_cmpt`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `interv_cmpt`
--

INSERT INTO `interv_cmpt` (`id_interv_cmpt`, `id_interv`, `id_cmpt`, `ordre`) VALUES
(9, 1, 11, 1),
(10, 2, 17, 2),
(11, 2, 8, NULL),
(12, 2, 9, NULL),
(13, 2, 10, NULL),
(14, 2, 11, NULL),
(15, 2, 12, NULL),
(16, 4, 7, NULL),
(17, 1, 9, NULL),
(18, 3, 1, NULL),
(19, 6, 20, NULL),
(20, 6, 17, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `lieu`
--

DROP TABLE IF EXISTS `lieu`;
CREATE TABLE IF NOT EXISTS `lieu` (
  `id_lieu` int(11) NOT NULL AUTO_INCREMENT,
  `nom_lieu` varchar(100) DEFAULT NULL,
  `ad_lieu` varchar(100) DEFAULT NULL,
  `id_ville` int(11) DEFAULT NULL,
  `lat_lieu` float NOT NULL,
  `lon_lieu` float NOT NULL,
  `id_type_lieu` int(11) NOT NULL,
  PRIMARY KEY (`id_lieu`),
  KEY `fk_lieu__ville` (`id_ville`),
  KEY `fk_lieu__type` (`id_type_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `lieu`
--

INSERT INTO `lieu` (`id_lieu`, `nom_lieu`, `ad_lieu`, `id_ville`, `lat_lieu`, `lon_lieu`, `id_type_lieu`) VALUES
(1, 'Magali', '', NULL, 0, 0, 3),
(2, 'Poussins Gardannais', NULL, 2, 43.4585, 5.4857, 2),
(3, 'Lutins - Lutines Eguilles', NULL, 3, 43.5661, 5.3178, 2),
(4, 'Assmat Calas', NULL, 1, 43.4605, 5.3536, 3),
(5, 'Biblio BBA - avec Compagnie Minipoil', NULL, NULL, 0, 0, 3),
(6, 'Pertuis Madame Dios', NULL, 5, 43.6932, 5.5347, 1),
(7, 'Lénaïque Simiane', NULL, NULL, 43.4298, 5.4278, 3),
(8, 'Ludo Gardanne', NULL, 2, 43.4585, 5.4857, 1),
(9, 'Colibri Marlène', NULL, NULL, 0, 0, 1),
(10, 'Maison Boulogne', '94 rue Camille Enlart', 6, 0, 0, 1),
(12, 'Cathédrale Notre-Dame de Saint-Omer', 'Enclos Notre-Dame', 8, 0, 0, 2);

-- --------------------------------------------------------

--
-- Structure de la table `prs`
--

DROP TABLE IF EXISTS `prs`;
CREATE TABLE IF NOT EXISTS `prs` (
  `id_prs` int(11) NOT NULL AUTO_INCREMENT,
  `mdp` varchar(20) NOT NULL,
  `nom_prs` varchar(20) NOT NULL,
  `prenom_prs` varchar(20) NOT NULL,
  `id_etat_prs` int(11) DEFAULT NULL,
  `nivo_lec` int(11) NOT NULL,
  `nivo_ecr` int(11) NOT NULL,
  `nivo_exp` int(11) NOT NULL,
  `cle` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_prs`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `prs`
--

INSERT INTO `prs` (`id_prs`, `mdp`, `nom_prs`, `prenom_prs`, `id_etat_prs`, `nivo_lec`, `nivo_ecr`, `nivo_exp`, `cle`) VALUES
(1, '', 'GAJAC', 'Vivien', 2, 2, 2, 2, 'mdp'),
(2, 'mdp', 'GAJAC', 'Michel', 2, 2, 2, 2, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `seance`
--

DROP TABLE IF EXISTS `seance`;
CREATE TABLE IF NOT EXISTS `seance` (
  `id_seance` int(11) NOT NULL AUTO_INCREMENT,
  `num_seance` int(11) DEFAULT NULL,
  `nom_seance` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_seance`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `seance`
--

INSERT INTO `seance` (`id_seance`, `num_seance`, `nom_seance`) VALUES
(1, 1, 'Minipoil perdu doudou'),
(2, 2, 'Petrouchka perdu chat'),
(3, 3, 'Je vois du pays'),
(4, 4, 'Pays des couleurs'),
(5, 5, 'Au fil de l\'eau'),
(6, 6, 'Il était un petit homme'),
(7, 7, 'J\'ai faim'),
(8, 8, 'Je pars en voyage'),
(9, 9, 'Sans nom'),
(10, 10, 'Maternelle'),
(11, 11, 'Minipoil cherche Père Noël');

-- --------------------------------------------------------

--
-- Structure de la table `seance_cmpt`
--

DROP TABLE IF EXISTS `seance_cmpt`;
CREATE TABLE IF NOT EXISTS `seance_cmpt` (
  `id_seance_cmpt` int(11) NOT NULL AUTO_INCREMENT,
  `id_seance` int(11) DEFAULT NULL,
  `id_cmpt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_seance_cmpt`),
  KEY `fk_seance_cmpt__seance` (`id_seance`),
  KEY `fk_seance_cmpt__cmpt` (`id_cmpt`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `seance_cmpt`
--

INSERT INTO `seance_cmpt` (`id_seance_cmpt`, `id_seance`, `id_cmpt`) VALUES
(1, 2, 1),
(2, 8, 1),
(3, 2, 2),
(4, 2, 3),
(5, 2, 6),
(6, 3, 2),
(7, 3, 4),
(8, 3, 6),
(9, 4, 4),
(10, 5, 3),
(11, 6, 5),
(12, 7, 1),
(13, 10, 2),
(14, 1, 14),
(15, 3, 14),
(16, 6, 1),
(18, 8, 7),
(22, 8, 1),
(27, 1, 12),
(29, 10, 9),
(30, 11, 9),
(31, 2, 9),
(32, 9, 17),
(33, 9, 5),
(34, 9, 1),
(35, 1, 1),
(38, 1, 10),
(39, 9, 10),
(41, 7, NULL),
(43, 7, 1),
(44, 7, 9);

-- --------------------------------------------------------

--
-- Structure de la table `type_lieu`
--

DROP TABLE IF EXISTS `type_lieu`;
CREATE TABLE IF NOT EXISTS `type_lieu` (
  `id_type_lieu` int(11) NOT NULL AUTO_INCREMENT,
  `lib_type_lieu` varchar(30) NOT NULL,
  PRIMARY KEY (`id_type_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `type_lieu`
--

INSERT INTO `type_lieu` (`id_type_lieu`, `lib_type_lieu`) VALUES
(1, 'particulier'),
(2, 'association'),
(3, 'ecole');

-- --------------------------------------------------------

--
-- Structure de la table `ville`
--

DROP TABLE IF EXISTS `ville`;
CREATE TABLE IF NOT EXISTS `ville` (
  `id_ville` int(11) NOT NULL AUTO_INCREMENT,
  `nom_ville` varchar(300) NOT NULL,
  PRIMARY KEY (`id_ville`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `ville`
--

INSERT INTO `ville` (`id_ville`, `nom_ville`) VALUES
(1, 'Calas'),
(2, 'Gardanne'),
(3, 'Eguilles'),
(4, 'Simiane'),
(5, 'Pertuis'),
(6, 'Boulogne-sur-mer'),
(7, 'Vincennes'),
(8, 'Saint-Omer'),
(10, 'Marseille');

-- --------------------------------------------------------

--
-- Structure de la vue `centre_lieux`
--
DROP TABLE IF EXISTS `centre_lieux`;

DROP VIEW IF EXISTS `centre_lieux`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `centre_lieux`  AS SELECT ((min(`lieu`.`lat_lieu`) + max(`lieu`.`lat_lieu`)) / 2) AS `moy_lat`, ((min(`lieu`.`lon_lieu`) + max(`lieu`.`lon_lieu`)) / 2) AS `moy_lon` FROM `lieu` WHERE ((`lieu`.`lat_lieu` > 0) AND (`lieu`.`lon_lieu` > 0)) ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `cmpt`
--
ALTER TABLE `cmpt`
  ADD CONSTRAINT `cmpt_ibfk_1` FOREIGN KEY (`id_instr`) REFERENCES `instr` (`id_instr`),
  ADD CONSTRAINT `fk_cmpt__instr` FOREIGN KEY (`id_instr`) REFERENCES `instr` (`id_instr`);

--
-- Contraintes pour la table `interv`
--
ALTER TABLE `interv`
  ADD CONSTRAINT `fk_interv__lieu` FOREIGN KEY (`id_lieu`) REFERENCES `lieu` (`id_lieu`),
  ADD CONSTRAINT `fk_interv__seance` FOREIGN KEY (`id_seance`) REFERENCES `seance` (`id_seance`),
  ADD CONSTRAINT `interv_ibfk_1` FOREIGN KEY (`id_seance`) REFERENCES `seance` (`id_seance`),
  ADD CONSTRAINT `interv_ibfk_2` FOREIGN KEY (`id_lieu`) REFERENCES `lieu` (`id_lieu`);

--
-- Contraintes pour la table `interv_cmpt`
--
ALTER TABLE `interv_cmpt`
  ADD CONSTRAINT `fk_interv_cmpt__cmpt` FOREIGN KEY (`id_cmpt`) REFERENCES `cmpt` (`id_cmpt`),
  ADD CONSTRAINT `fk_interv_cmpt__interv` FOREIGN KEY (`id_interv`) REFERENCES `interv` (`id_interv`),
  ADD CONSTRAINT `interv_cmpt_ibfk_1` FOREIGN KEY (`id_interv`) REFERENCES `interv` (`id_interv`),
  ADD CONSTRAINT `interv_cmpt_ibfk_2` FOREIGN KEY (`id_cmpt`) REFERENCES `cmpt` (`id_cmpt`);

--
-- Contraintes pour la table `lieu`
--
ALTER TABLE `lieu`
  ADD CONSTRAINT `fk_lieu__type` FOREIGN KEY (`id_type_lieu`) REFERENCES `type_lieu` (`id_type_lieu`),
  ADD CONSTRAINT `fk_lieu__ville` FOREIGN KEY (`id_ville`) REFERENCES `ville` (`id_ville`);

--
-- Contraintes pour la table `seance_cmpt`
--
ALTER TABLE `seance_cmpt`
  ADD CONSTRAINT `fk_seance_cmpt__cmpt` FOREIGN KEY (`id_cmpt`) REFERENCES `cmpt` (`id_cmpt`),
  ADD CONSTRAINT `fk_seance_cmpt__seance` FOREIGN KEY (`id_seance`) REFERENCES `seance` (`id_seance`),
  ADD CONSTRAINT `seance_cmpt_ibfk_1` FOREIGN KEY (`id_seance`) REFERENCES `seance` (`id_seance`),
  ADD CONSTRAINT `seance_cmpt_ibfk_2` FOREIGN KEY (`id_cmpt`) REFERENCES `cmpt` (`id_cmpt`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
