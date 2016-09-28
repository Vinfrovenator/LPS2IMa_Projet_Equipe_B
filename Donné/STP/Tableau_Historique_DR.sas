* Début du code EG généré (ne pas modifier cette ligne);
*
*  Application stockée enregistrée par
*  Enterprise Guide Stored Process Manager V6.1
*
*  ====================================================================
*  Nom de l'application stockée : Tableau_Historique_DR
*  ====================================================================
*
*  Dictionnaire d'invites de l'application stockée :
*  ____________________________________
*  I_CUMUL
*       Type : Numérique
*      Libellé : Choix du calcul
*       Attr: Visible
*       Desc. : Permet d'opter pour le cumul ou non des indicateurs sur
*               la période concernée
*  ____________________________________
*  I_DEVISE
*       Type : Numérique
*      Libellé : Choix de la devise
*       Attr: Visible
*       Desc. : Permet de sélectionner la devise dans laquelle les
*               données seront affichées
*  ____________________________________
*  I_ENSEIGNE
*       Type : Numérique
*      Libellé : Choix de l'enseigne
*       Attr: Visible
*       Desc. : Permet de sélectionner l'enseigne
*  ____________________________________
*  I_FAMPROD
*       Type : Numérique
*      Libellé : Choix de la famille de produit
*       Attr: Visible
*       Desc. : Permet de sélectionner la famille de produit
*  ____________________________________
*  I_INDICATEUR
*       Type : Numérique
*      Libellé : Choix de l'indicateur
*       Attr: Visible
*       Desc. : Permet de choisir l'indicateur à analyser
*  ____________________________________
*  I_REGION
*       Type : Numérique
*      Libellé : Choix de la région
*       Attr: Visible
*       Desc. : Permet de sélectionner la région commerciale
*  ____________________________________
*  I_TEMPS
*       Type : Texte
*      Libellé : Choix de la période étudiée
*       Attr: Visible
*       Desc. : Permet de déterminer le laps de temps qui sera étudié
*  ____________________________________
*;


*ProcessBody;

%global I_CUMUL
        I_DEVISE
        I_ENSEIGNE
        I_FAMPROD
        I_INDICATEUR
        I_REGION
        I_TEMPS;

%STPBEGIN;

* Fin du code EG généré (ne pas modifier cette ligne);


/* ----------------------------------------------------------------------*/
			/*  Tableau d'historique pour le directeur régionnal du groupe DARTIES */
			/* ----------------- Développé par le groupe FRATBAG -------------------*/
			/* -------------------------- 21/03/2016 --------------------------------*/
			/* ----------------------------- LP CSD ---------------------------------*/
			/* ----------------------------------------------------------------------*/

/* Lien vers le code de rassemblement des données utilisées */


%INCLUDE "D:\SASuserdirs\projets\DARTIES1-2015\STP\Rassemblement_des_donnees.sas";

/* Connection à la bibliothèque ora12015 */

dm "clear out;clear log;ODSRESULTS;clear";

OPTIONS FULLSTIMER SASTRACE=',,,d' sastraceloc=saslog;
libname ORA12015;
libname ORA12015 oracle user='DARTIES1' password='DARTIES1' 
 path="(DESCRIPTION= 
          (ADDRESS_LIST=
            (ADDRESS= (PROTOCOL=TCP)(HOST=ora12c)(PORT=1521))
             )
              (CONNECT_DATA= 
         	     (SID=ORAETUD)
          )
        )
       ";


PROC SQL STIMER _method _tree EXEC;
connect to oracle as ora12c(
user='DARTIES1'
orapw='DARTIES1'
 path="(DESCRIPTION= 
          (ADDRESS_LIST=
            (ADDRESS= (PROTOCOL=TCP)(HOST=ora12c)(PORT=1521))
             )
              (CONNECT_DATA= 
         	     (SID=ORAETUD)
          )
        )
       "
) ;

disconnect from ora12c;

/* Déclaration des macro-variables qui constitueront le titre du tableau */

%GLOBAL REGION;
%GLOBAL ANNEE_CURR;
%GLOBAL ANNEE_PREC;
%GLOBAL DEVISE;
%GLOBAL PRODUIT;
%GLOBAL INDICATEUR;


/* TABLEAU HISTORIQUE */


/* Valeurs sans cumul */

PROC SQL;
CREATE TABLE work.histo_transi as
	SELECT * from work.datatable2 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= "&I_TEMPS.")
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
;
quit;


PROC SQL;
   CREATE TABLE work.histo_transi1 AS 
   SELECT t2.LIB_FAMILLE_PRODUIT LABEL="Famille de produit", 
          /* SUM_of_OBJECTIF */
            sum(OBJECTIF) FORMAT=10. LABEL="Données budgetées" AS SUM_of_VENTES_OBJECTIF, 
          /* SUM_of_REEL */
            sum(REEL) FORMAT=10. LABEL="Données réelles" AS SUM_of_VENTES_REEL, 
          /* Ecart */
            (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) FORMAT=PERCENTN8.2 LABEL=
            "Écart Objectif/Réel" AS Ecart_ventes
			FROM ora12015.DIM_MAGASIN_STAR t1, work.histo_transi t2
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN)
      GROUP BY t2.LIB_FAMILLE_PRODUIT;

               
QUIT;

/* Valeur avec cumul */

PROC SQL;
CREATE TABLE work.histo_transi_cumul as
	SELECT * from work.datatable2_cumul 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps_cumul where code= "&I_TEMPS.")
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
;
quit;


PROC SQL;
   CREATE TABLE work.histo_transi2 AS 
   SELECT t2.LIB_FAMILLE_PRODUIT LABEL="Famille de produit", 
          /* SUM_of_OBJECTIF */
           (SUM(OBJECTIF)) FORMAT=10. LABEL="Données budgetées cumulées" AS SUM_of_VENTES_OBJECTIF_cumul, 
          /* SUM_of_REEL */
          (SUM(REEL)) FORMAT=10. LABEL="Données réelles cumulées" AS SUM_of_VENTES_REEL_cumul, 
          /* Ecart */
            (((SUM(REEL)) - (SUM(OBJECTIF))) / (SUM(OBJECTIF))) FORMAT=PERCENTN8.2 LABEL=
            "Écart cumulé Objectif/Réel" AS Ecart_ventes_cumul			
			FROM ora12015.DIM_MAGASIN_STAR t1, work.histo_transi_cumul t2
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN )
      GROUP BY t2.LIB_FAMILLE_PRODUIT;
  QUIT;

/* Valeurs non cumulées de l'année précédente */

 PROC SQL;
CREATE TABLE work.histo_transi_prec as
	SELECT * from work.datatable2 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= case when length("&I_TEMPS.") < 10 then put(input(substr("&I_TEMPS.",0,4),4.)-1,4.) || substr("&I_TEMPS.",5) 
																										   else put(input(substr("&I_TEMPS.",0,4),4.)-1,4.) || substr("&I_TEMPS.",5,3) || put(input(substr("&I_TEMPS.",8),4.)-1,4.)
				end )
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
;
quit;


PROC SQL;
   CREATE TABLE work.histo_transi3 AS 
   SELECT t2.LIB_FAMILLE_PRODUIT LABEL="Famille de produit", 
          /* SUM_of_OBJECTIF */
            sum(OBJECTIF) FORMAT=10. LABEL="Données budgetées N-1" AS SUM_of_VENTES_OBJECTIF_prec, 
          /* SUM_of_REEL */
            sum(REEL) FORMAT=10. LABEL="Données réelles N-1" AS SUM_of_VENTES_REEL_prec, 
          /* Ecart */
            (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) FORMAT=PERCENTN8.2 LABEL=
            "Écart N-1 Objectif/Réel" AS Ecart_ventes_prec			
			FROM ora12015.DIM_MAGASIN_STAR t1, work.histo_transi_prec t2
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN )
      GROUP BY t2.LIB_FAMILLE_PRODUIT;
  QUIT;


/* Valeur cumulées de l'année précédentes */


PROC SQL;
CREATE TABLE work.histo_transi_cumul_prec as
	SELECT * from work.datatable2_cumul 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
	AND id_temps in(select id_temps from work.requete_temps_cumul where CODE= case when length(compress("&I_TEMPS.")) < 10 then put(input(substr(compress("&I_TEMPS."),0,4),4.)-1,4.) || substr(compress("&I_TEMPS."),5) 
																							 					 else put(input(substr(compress("&I_TEMPS."),0,4),4.)-1,4.) || substr(compress("&I_TEMPS."),5,3) || put(input(substr(compress("&I_TEMPS."),8),4.)-1,4.)
		  																										 end );
QUIT;

PROC SQL;
   CREATE TABLE work.histo_transi4 AS 
   SELECT t2.LIB_FAMILLE_PRODUIT LABEL="Famille de produit", 
          /* SUM_of_OBJECTIF */
            (SUM(OBJECTIF)) FORMAT=10. LABEL="Données budgetées N-1 cumulées" AS SUM_of_VENTES_OBJECTIF_cum2, 
          /* SUM_of_REEL */
            (SUM(REEL)) FORMAT=10. LABEL="Données réelles N-1 cumulées" AS SUM_of_VENTES_REEL_cum2, 
          /* Ecart */
            (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) FORMAT=PERCENTN8.2 LABEL=
            "Écart cumulé N-1 Objectif/Réel" AS Ecart_ventes_cum2	
			FROM ora12015.DIM_MAGASIN_STAR t1, work.histo_transi_cumul_prec t2
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN)
      GROUP BY t2.LIB_FAMILLE_PRODUIT;
  QUIT;

  /* Récupération des libellé de la valeur des différentes invites */

  /* Zone géo */

  PROC SQL noprint;
  select trim(libelle) into :REGION
  from ora12015.select_zone_geo
  where code=&I_REGION.

  ;
  quit;

  /* Période étudiée - Année actuelle */

  PROC sql noprint;
  select substr(compress("&I_TEMPS."),0,4) into :ANNEE_CURR
  from ora12015.SELECT_TEMPS
  where code="&I_TEMPS."
  ;
  quit;

  /* Période étudiée - Année précédente */

  PROC sql noprint;
  select put(input(substr(compress("&I_TEMPS."),0,4),4.)-1,4.) into :ANNEE_PREC
  from ora12015.SELECT_TEMPS
  where code="&I_TEMPS."
  ;
  quit;

  /*Famille de produit */

  PROC SQL noprint;
  select trim(lib_famille) into :PRODUIT
  from ora12015.select_famille_produit
  where code=&I_FAMPROD.
  ;
  quit;

  /* Indicateur étudié */

  PROC SQL noprint;
  select trim(lib_ind) into :INDICATEUR
  from ora12015.select_INDICATEUR
  where code=&I_INDICATEUR.
  ;
  QUIT;

/* Consitution du tableau final */

PROC SQL;
	CREATE TABLE work.HISTORIQUE1 AS
		SELECT t5.LIB_FAMILLE_PRODUIT LABEL="Famille de produit",
			/* Objectif non cumulé N-1 */
			t3.SUM_of_VENTES_OBJECTIF_prec LABEL="Données budgetées N-1",
			/* Réel non cumulé N-1 */
			t3.SUM_of_VENTES_REEL_prec LABEL="Données réelles N-1",
			/* Écart non-cumulé N-1 */
			t3.Ecart_ventes_prec LABEL="Écart Objectif/Réel N-1",
			/* Objectif cumulé N-1*/
			t4.SUM_of_VENTES_OBJECTIF_cum2 LABEL="Données budgetées cumulées N-1",
			/* Réel cumulé N-1 */
			t4.SUM_of_VENTES_REEL_cum2 LABEL="Données réelles cumulées N-1",
			/* Écart cumulé N-1 */
			t4.Ecart_ventes_cum2 LABEL="Écart cumulé Objectif/Réel N-1",
			/* Objectif non cumulé */
			t1.SUM_of_VENTES_OBJECTIF LABEL="Données budgetées",
			/* Réel non cumulé */
			t1.SUM_of_VENTES_REEL LABEL="Données réelles",
			/* Écart non cumulé */
			t1.Ecart_ventes LABEL="Écart Objectif/Réel",
			/* Objectif cumulé */
			t2.SUM_of_VENTES_OBJECTIF_cumul LABEL="Données budgetées cumulées",
			/* Réel cumulé */
			t2.SUM_of_VENTES_REEL_cumul LABEL="Données réelles cumulées",
			/* Écart cumulé */
			t2.Ecart_ventes_cumul LABEL="Écart cumulé Objectif/Réel"
		FROM work.histo_transi1 t1, work.histo_transi2 t2, work.histo_transi3 t3, work.histo_transi4 t4, ora12015.DIM_FAMILLE_PRODUIT t5
		WHERE (t1.LIB_FAMILLE_PRODUIT=t2.LIB_FAMILLE_PRODUIT AND t2.LIB_FAMILLE_PRODUIT = t3.LIB_FAMILLE_PRODUIT AND t3.LIB_FAMILLE_PRODUIT=t4.LIB_FAMILLE_PRODUIT AND t4.LIB_FAMILLE_PRODUIT=t5.LIB_FAMILLE_PRODUIT)
		ORDER BY t5.LIB_FAMILLE_PRODUIT
	;
QUIT;


/* Ajout d'une ligne de total et restitution du tableau */


TITLE;
TITLE1 "&ANNEE_PREC.|&ANNEE_CURR.|&INDICATEUR.";

Proc sql;
select * from work.historique1
Union all
select "Total" as Total, 
						 /* Données de l'année précédente non cumulées */
						 sum(SUM_of_VENTES_OBJECTIF_prec) as SUM_of_VENTES_OBJECTIF_prec,
						 sum(SUM_of_VENTES_REEL_prec) as SUM_of_VENTES_REEL_prec,
						 ((sum(SUM_of_VENTES_REEL_prec)-sum(SUM_of_VENTES_OBJECTIF_prec))/sum(SUM_of_VENTES_OBJECTIF_prec)) as Ecart_ventes_prec,

						 /* Données de l'année précédente cumulées */
						 sum(SUM_of_VENTES_OBJECTIF_cum2) as SUM_of_VENTES_OBJECTIF_cum2,
						 sum(SUM_of_VENTES_REEL_cum2) as SUM_of_VENTES_REEL_cum2,
						 ((sum(SUM_of_VENTES_REEL_cum2)-sum(SUM_of_VENTES_OBJECTIF_cum2))/sum(SUM_of_VENTES_OBJECTIF_cum2)) as Ecart_ventes_cum2,

						 /* Données actuelles non cumulées */
						 sum(SUM_of_VENTES_OBJECTIF) as SUM_of_VENTES_OBJECTIF,
						 sum(SUM_of_VENTES_REEL) as SUM_of_VENTES_REEL,
						 ((sum(SUM_of_VENTES_REEL)-sum(SUM_of_VENTES_OBJECTIF))/sum(SUM_of_VENTES_OBJECTIF)) as Ecart_ventes,

						 /* Données actuelles cumulées */
						 sum(SUM_of_VENTES_OBJECTIF_cumul) as SUM_of_VENTES_OBJECTIF_cumul,
						 sum(SUM_of_VENTES_REEL_cumul) as SUM_of_VENTES_REEL_cumul,
						 ((sum(SUM_of_VENTES_REEL_cumul)-sum(SUM_of_VENTES_OBJECTIF_cumul))/sum(SUM_of_VENTES_OBJECTIF_cumul)) as Ecart_ventes_cumul
from work.HISTORIQUE1
;
quit;

TITLE;

* Début du code EG généré (ne pas modifier cette ligne);
;*';*";*/;quit;
%STPEND;

* Fin du code EG généré (ne pas modifier cette ligne);

