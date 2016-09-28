* Début du code EG généré (ne pas modifier cette ligne);
*
*  Application stockée enregistrée par
*  Enterprise Guide Stored Process Manager V6.1
*
*  ====================================================================
*  Nom de l'application stockée : Tableau_Accueil_DC
*  ====================================================================
*
*  Dictionnaire d'invites de l'application stockée :
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
*  I_REGION
*       Type : Numérique
*      Libellé : I_REGION
*       Attr: Visible
*  ____________________________________
*  I_TEMPS
*       Type : Texte
*      Libellé : Choix de la période étudiée
*       Attr: Visible
*       Desc. : Permet de déterminer le laps de temps qui sera étudié
*  ____________________________________
*;


*ProcessBody;

%global I_DEVISE
        I_ENSEIGNE
        I_REGION
        I_TEMPS;

%STPBEGIN;

* Fin du code EG généré (ne pas modifier cette ligne);


/* ----------------------------------------------------------------------*/
			/* - Tableau d'accueil pour le directeur commercial du groupe DARTIES -*/
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

/* TABLEAU D'ACCUEIL */

/* Filtrage selon la valeur des invites */

PROC SQL;
CREATE TABLE work.transi as
	SELECT * from work.datatable2 
	WHERE id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= "&I_TEMPS.")
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
;
quit;

/* Tableau dédié aux valeurs de chiffre d'affaire */

PROC SQL;
   CREATE TABLE work.Accueil_CA AS 
   SELECT t3.LIB_FAMILLE_PRODUIT,
          /* SUM_of_OBJECTIF */
            (SUM(OBJECTIF)) FORMAT=12.2 LABEL="CA budgeté" AS CA_Objectif, 
          /* SUM_of_REEL */
            (SUM(REEL)) FORMAT=12.2 LABEL="CA réel" AS CA_Reel
         FROM ora12015.DIM_MAGASIN_STAR t1, work.transi t2, ora12015.DIM_FAMILLE_PRODUIT t3
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT AND INDICATEUR="CA")
      GROUP BY t3.LIB_FAMILLE_PRODUIT;
               
QUIT;

/* Tableau dédié aux ventes */

PROC SQL;
   CREATE TABLE work.Accueil_VE AS 
   SELECT t3.LIB_FAMILLE_PRODUIT,
          /* SUM_of_OBJECTIF */
            (SUM(OBJECTIF)) FORMAT=12.2 LABEL="Ventes budgetées" AS Ventes_Objectif, 
          /* SUM_of_REEL */
            (SUM(REEL)) FORMAT=12.2 LABEL="Ventes réelles" AS Ventes_Reel
         FROM ora12015.DIM_MAGASIN_STAR t1, work.transi t2, ora12015.DIM_FAMILLE_PRODUIT t3
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT AND INDICATEUR="VENTES")
      GROUP BY t3.LIB_FAMILLE_PRODUIT;
               
QUIT;

/* Tableau dédié aux valeurs de marge */

PROC SQL;
   CREATE TABLE work.Accueil_MA AS 
   SELECT t3.LIB_FAMILLE_PRODUIT,
          /* SUM_of_OBJECTIF */
            (SUM(OBJECTIF)) FORMAT=12.2 LABEL="Marge budgetée" AS Marge_Objectif, 
          /* SUM_of_REEL */
            (SUM(REEL)) FORMAT=12.2 LABEL="Marge réelle" AS Marge_Reel
         FROM ora12015.DIM_MAGASIN_STAR t1, work.transi t2, ora12015.DIM_FAMILLE_PRODUIT t3
      WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT AND INDICATEUR="MARGE")
      GROUP BY t3.LIB_FAMILLE_PRODUIT;
               
QUIT;

/* Rassemblement des 3 tableaux précédents */

Proc sql;
Create table work.transi_Accueil as
Select t1.lib_famille_produit, t1.CA_Reel, t1.CA_Objectif,  t2.Ventes_Reel, t2.Ventes_Objectif, t3.Marge_Reel,t3.Marge_Objectif
from work.Accueil_CA t1, work.Accueil_VE t2, work.Accueil_MA t3
where t1.Lib_famille_produit=t2.Lib_famille_produit and t1.Lib_famille_produit=t3.lib_famille_produit
;
QUIT;

/* Ajout d'une ligne de total */

Proc sql;
CREATE TABLE work.Accueil as
select * from work.transi_accueil
Union all
select "Total" as Total, 
						 /* CA */
						 sum(CA_Reel) format=12.2 as CA_Reel,
						 sum(CA_Objectif) format=12.2 as CA_Objectif,
						 
						 /* Ventes */
						 sum(Ventes_Reel) format=12.2 as Ventes_Reel,
						 sum(Ventes_Objectif) format=12.2 as Ventes_Objectif,
						 
						 /* Marge */
						 sum(Marge_Reel) format=12.2 as Marge_Reel,
						 sum(Marge_Objectif) format=12.2 as Marge_Objectif
						 
											
from work.transi_accueil
;
quit;

/* Récupération des éléments du titre */

/* Zone géographique */

  PROC SQL noprint;
  select trim(id_region) into :REGION
  from ora12015.codes_region
  where code=&I_REGION.
  ;
  quit;

  /* Année actuelle */

  PROC sql noprint;
  select substr(compress("&I_TEMPS."),0,4) into :ANNEE_CURR
  from ora12015.SELECT_TEMPS
  where code="&I_TEMPS."
  ;
  quit;

  /* Année précédente */

  PROC sql noprint;
  select put(input(substr(compress("&I_TEMPS."),0,4),4.)-1,4.) into :ANNEE_PREC
  from ora12015.SELECT_TEMPS
  where code="&I_TEMPS."
  ;
  quit;

/* Restitution du tableau d'accueil */

TITLE;
TITLE1 "Détail &REGION. en &ANNEE_CURR. en &DEVISE., tout les produits, Tout les indicateurs";

PROC PRINT DATA=work.Accueil /* Production du rapport */
	OBS="Famille de produit"
	LABEL
;
	VAR CA_Reel CA_Objectif Ventes_Reel Ventes_Objectif Marge_Reel Marge_Objectif;
	ID Lib_famille_produit;
	
RUN;
RUN;
QUIT;
TITLE;

* Début du code EG généré (ne pas modifier cette ligne);
;*';*";*/;quit;
%STPEND;

* Fin du code EG généré (ne pas modifier cette ligne);

