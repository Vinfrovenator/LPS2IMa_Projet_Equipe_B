* Début du code EG généré (ne pas modifier cette ligne);
*
*  Application stockée enregistrée par
*  Enterprise Guide Stored Process Manager V6.1
*
*  ====================================================================
*  Nom de l'application stockée : macroPalma
*  ====================================================================
*
*  Dictionnaire d'invites de l'application stockée :
*  ____________________________________
*  I_ENSEIGNE
*       Type : Numérique
*      Libellé : I_ENSEIGNE
*       Attr: Visible, Obligatoire
*  ____________________________________
*  I_FAMPROD
*       Type : Numérique
*      Libellé : I_FAMPROD
*       Attr: Visible, Obligatoire
*  ____________________________________
*  I_INDICATEUR
*       Type : Numérique
*      Libellé : I_INDICATEUR
*       Attr: Visible, Obligatoire
*  ____________________________________
*  I_REGION
*       Type : Numérique
*      Libellé : I_REGION
*       Attr: Visible, Obligatoire
*  ____________________________________
*  I_TEMPS
*       Type : Texte
*      Libellé : I_TEMPS
*       Attr: Visible
*  ____________________________________
*;


*ProcessBody;

%global I_ENSEIGNE
        I_FAMPROD
        I_INDICATEUR
        I_REGION
        I_TEMPS;

%STPBEGIN;

* Fin du code EG généré (ne pas modifier cette ligne);


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



%let SELECT_COURS=1;
/*
TITLE 'Les options de cumuls de temps disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_CUMUL)
;
*/
%let SELECT_CUMUL=1;


/* Conception de la table contenant les valeurs temporelles */

TITLE 'Les temps disponibles';
CREATE TABLE work.REQUETE_TEMPS AS
SELECT * FROM connection to ora12c(
WITH RECURSIVE_CUMULATED_MONTH1(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')) 
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from RECURSIVE_CUMULATED_MONTH1, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH1.YEAR_REF AND DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH1.MONTH_REF-1 AND DIM_TEMPS.MOIS>=1
),
RECURSIVE_CUMULATED_MONTH(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1 
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from RECURSIVE_CUMULATED_MONTH, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH.YEAR_REF AND DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH.MONTH_REF-1 AND DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_MONTH2(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2 
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from RECURSIVE_CUMULATED_MONTH2, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH2.YEAR_REF AND DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH2.MONTH_REF-1 AND DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_TRIMESTER1(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from RECURSIVE_CUMULATED_TRIMESTER1, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER1.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER1.TRIMESTER_REF-1 AND DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_TRIMESTER(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from RECURSIVE_CUMULATED_TRIMESTER, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER.TRIMESTER_REF-1 AND DIM_TEMPS.TRIMESTRE>=1
), 
RECURSIVE_CUMULATED_TRIMESTER2(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from RECURSIVE_CUMULATED_TRIMESTER2, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER2.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER2.TRIMESTER_REF-1 AND DIM_TEMPS.TRIMESTRE>=1
), 
RECURSIVE_CUMULATED_SEMESTER1(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from RECURSIVE_CUMULATED_SEMESTER1, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER1.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_SEMESTER1.SEMESTER_REF-1 AND DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER2(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from RECURSIVE_CUMULATED_SEMESTER2, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER2.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_SEMESTER2.SEMESTER_REF-1 AND DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from RECURSIVE_CUMULATED_SEMESTER, DIM_TEMPS 
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER.YEAR_REF AND DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_SEMESTER.SEMESTER_REF-1 AND DIM_TEMPS.SEMESTRE>=1
) 
SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))||'_1_'||TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')) AS CODE,ID_TEMPS AS ID_TEMPS FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL 
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND TRIMESTRE=T1.TRIMESTRE) 



AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND SEMESTRE=T1.SEMESTRE) 
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1) ,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1 
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND TRIMESTRE=T1.TRIMESTRE) 
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND SEMESTRE=T1.SEMESTRE) 
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2) ,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2 
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND TRIMESTRE=T1.TRIMESTRE) 
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1 
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND SEMESTRE=T1.SEMESTRE) 
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER2
WHERE &SELECT_CUMUL=0);

/* Synthèse des requêtes */
/*
%let SELECT_TEMPS='2015_1_2015';


TITLE 'Les zones géographiques disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_ZONE_GEO)
;

%let SELECT_ZONE_GEO=0;

TITLE 'Les onglets disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_ONGLET)
;

%let SELECT_ONGLET=1;

TITLE 'Les enseignes disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_ENSEIGNE)
;

%let SELECT_ENSEIGNE=0;

TITLE 'Les familles de produits disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_FAMILLE_PRODUIT)
;

%let SELECT_FAMILLE_PRODUIT=0;

TITLE 'Les indicateurs disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_INDICATEURS)
;

%let SELECT_INDICATEUR=1;

TITLE 'Les utilisateurs disponibles';
SELECT * FROM connection to ora12c(SELECT * FROM SELECT_USER)
;

%let SELECT_USER=2;

disconnect from ora12c;
QUIT;
*/
/* Création d'une table datatable qui contient toute les données dont nous avons besoin pour la conception des différents tableaux*/
PROC SQL;
CREATE TABLE work.datatable as
Select DWR_FAITS_VENTES.id_magasin, DWR_FAITS_VENTES.id_famille_produit, DWR_FAITS_VENTES.id_temps,
	   DWR_FAITS_VENTES.date_maj, DWR_FAITS_VENTES.indicateur, DWR_FAITS_VENTES.objectif, DWR_FAITS_VENTES.reel,
	   DIM_MAGASIN_star.id_region_com, DIM_magasin_star.lib_region_com,
	   DIM_ENSEIGNE.id_enseigne,DIM_ENSEIGNE.lib_enseigne
from ORA12015.DWR_FAITS_VENTES, ora12015.DIM_magasin_star, ora12015.DIM_enseigne
where  DWR_faits_ventes.id_magasin=dim_magasin_star.id_magasin and DIM_MAGASIN_STAR.id_enseigne=DIM_ENSEIGNE.id_enseigne;
QUIT;

/* Ajout de variables supplémentaires dans le but de simplifier le code de conception des tableaux */


DATA work.datatable2;
SET work.DATATABLE;
id_i=0;
if indicateur = "VENTES" then id_i=2;
if indicateur = "CA" then id_i=1;
if indicateur = "MARGE" then id_i=3;
if id_famille_produit = 1 then lib_famille_produit= "Four";
if id_famille_produit = 2 then lib_famille_produit= "Hifi";
if id_famille_produit = 3 then lib_famille_produit= "Magnetoscope";
annee=input(substr(ID_TEMPS,1,4),4.);
mois=input(substr(ID_TEMPS,5,2),2.);
run;


/* Le code suivant permet de faire le lien entre les différentes invites et les tables faisant correspondre les différents codes et identifiants */
libname ORA12015 meta library="ORA-DARTIES1-2015";

PROC SQL;
CREATE TABLE work.transi as
	SELECT * from work.datatable2 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= "&I_TEMPS.")
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
	;
quit;

/* TABLEAU palmares */
%macro tabPalma ();




proc sort data=work.transi out=work.palma (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

data work.palma (keep=Lib_region_com indicateur cumulR cumulO ecart) ;
attrib cumulR label="cumul réel"  FORMAT=10.;
attrib cumulO label="cumul objectif"  FORMAT=10.;
attrib ecart FORMAT=PERCENTN8.2 label="ecart";
set work.palma;

retain cumulR;
retain cumulO;

by id_region_com indicateur;


if  first.indicateur then do;
cumulR =0;
cumulO = 0;
ecart = 0;

end;
cumulR = cumulR+ reel;
cumulO = cumulO+ objectif;

if  last.indicateur then do;
ecart = (cumulR- cumulO)/cumulO;
output;
end;
run;



data work.palma;
retain Lib_region_com id_famille_produit lib_famille_produit indicateur cumulR cumulO ecart;
set work.palma;
run;

proc sort data=work.palma out=work.palma2sort;
by Lib_region_com;
run;


PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaCumulR;
ID indicateur;
VAR cumulR ;
BY Lib_region_com;
RUN;


PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaCumulO;
ID indicateur;
VAR cumulO ;
BY Lib_region_com ;
RUN;



PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaecart;
ID indicateur;
VAR ecart ;
BY Lib_region_com;
RUN;

%if &I_INDICATEUR. = 0 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART, r.ventes as VENTES_R, o.ventes as VENTES_O, e.ventes as VENTES_ECART, r.marge as MARGE_R, o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;
%else %if  &I_INDICATEUR. = 1 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

%else %if  &I_INDICATEUR. = 2 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ventes as VENTES_R , o.ventes as VENTES_O, e.ventes as VENTES_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var VENTES_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

%else %if  &I_INDICATEUR. = 3 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.marge as MARGE_R , o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var MARGE_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

proc print data=work.palmaresRang noobs;
run;


%end;
%else %do;


proc sort data=work.transi out=work.palma (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

data work.palma (keep=Lib_region_com indicateur cumulR cumulO ecart) ;
attrib cumulR label="cumul réel"  FORMAT=10.;
attrib cumulO label="cumul objectif"  FORMAT=10.;
attrib ecart FORMAT=PERCENTN8.2 label="ecart";
set work.palma;

retain cumulR;
retain cumulO;

by id_region_com indicateur;


if  first.indicateur then do;
cumulR =0;
cumulO = 0;
ecart = 0;

end;
cumulR = cumulR+ reel;
cumulO = cumulO+ objectif;

if  last.indicateur then do;
ecart = (cumulR- cumulO)/cumulO;
output;
end;
run;



data work.palma;
retain Lib_region_com id_famille_produit lib_famille_produit indicateur cumulR cumulO ecart;
set work.palma;
run;

proc sort data=work.palma out=work.palma2sort;
by Lib_region_com;
run;


PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaCumulR;
ID indicateur;
VAR cumulR ;
BY Lib_region_com;
RUN;


PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaCumulO;
ID indicateur;
VAR cumulO ;
BY Lib_region_com ;
RUN;



PROC
TRANSPOSE
DATA=work.palma2sort OUT=work.palmaecart;
ID indicateur;
VAR ecart ;
BY Lib_region_com;
RUN;

%if &I_INDICATEUR. = 0 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART, r.ventes as VENTES_R, o.ventes as VENTES_O, e.ventes as VENTES_ECART, r.marge as MARGE_R, o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;
%else %if  &I_INDICATEUR. = 1 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

%else %if  &I_INDICATEUR. = 2 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.ventes as VENTES_R , o.ventes as VENTES_O, e.ventes as VENTES_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var VENTES_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

%else %if  &I_INDICATEUR. = 3 %then %do;
proc sql;
create table work.palmares as
select r.Lib_region_com, r.marge as MARGE_R , o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palmaCumulR r, work.palmaCumulO o, work.palmaecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmares out=work.palmaresRang descending;
   var MARGE_R;
   ranks N;
run;

proc sort data=work.palmaresRang;
by N;
run;
%end;

/*palma N-1*/

proc sql;
create table work.ordreN1 as
select ordre from ORA12015.select_temps
where code = "&I_TEMPS.";
quit;


PROC SQL;
CREATE TABLE work.transiN1 as
	SELECT * from work.datatable2 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= (select code 
from ORA12015.select_temps s_t,work.ordreN1 n1
where s_t.ordre = ((n1.ordre )+20)))
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = &I_REGION.)
	;
quit;



proc sort data=work.transiN1 out=work.palman1 (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

data work.palman1 (keep=Lib_region_com indicateur cumulR cumulO ecart) ;
attrib cumulR label="cumul réel"  FORMAT=10.;
attrib cumulO label="cumul objectif"  FORMAT=10.;
attrib ecart FORMAT=PERCENTN8.2 label="ecart";
set work.palman1;

retain cumulR;
retain cumulO;

by id_region_com indicateur;


if  first.indicateur then do;
cumulR =0;
cumulO = 0;
ecart = 0;

end;
cumulR = cumulR+ reel;
cumulO = cumulO+ objectif;

if  last.indicateur then do;
ecart = (cumulR- cumulO)/cumulO;
output;
end;
run;



data work.palman1;
retain Lib_region_com id_famille_produit lib_famille_produit indicateur cumulR cumulO ecart;
set work.palman1;
run;

proc sort data=work.palman1;
by Lib_region_com;
run;


PROC
TRANSPOSE
DATA=work.palman1 OUT=work.palman1R;
ID indicateur;
VAR cumulR ;
BY Lib_region_com;
RUN;


PROC
TRANSPOSE
DATA=work.palman1 OUT=work.palman1O;
ID indicateur;
VAR cumulO ;
BY Lib_region_com ;
RUN;



PROC
TRANSPOSE
DATA=work.palman1 OUT=work.palman1ecart;
ID indicateur;
VAR ecart ;
BY Lib_region_com;
RUN;


%if &I_INDICATEUR. = 0 %then %do;
proc sql;
create table work.palmaresn1 as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART, r.ventes as VENTES_R, o.ventes as VENTES_O, e.ventes as VENTES_ECART, r.marge as MARGE_R, o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palman1R r, work.palman1O o, work.palman1ecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmaresn1 out=work.palmaresn1Rang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresn1Rang;
by N;
run;

proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.CA_R, n.CA_O, n.CA_ECART, n.VENTES_R, n.VENTES_O, n.VENTES_ECART, n.MARGE_R , n.MARGE_O, n.MARGE_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;


%end;
%else %if  &I_INDICATEUR. = 1 %then %do;
proc sql;
create table work.palmaresn1 as
select r.Lib_region_com, r.ca as CA_R , o.ca as CA_O, e.ca as CA_ECART
from work.palman1R r, work.palman1O o, work.palman1ecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmaresn1 out=work.palmaresn1Rang descending;
   var CA_R;
   ranks N;
run;

proc sort data=work.palmaresn1Rang;
by N;
run;

proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.CA_R, n.CA_O, n.CA_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

%end;

%else %if  &I_INDICATEUR. = 2 %then %do;
proc sql;
create table work.palmaresn1 as
select r.Lib_region_com, r.ventes as VENTES_R, o.ventes as VENTES_O, e.ventes as VENTES_ECART
from work.palman1R r, work.palman1O o, work.palman1ecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmaresn1 out=work.palmaresn1Rang descending;
   var VENTES_R;
   ranks N;
run;

proc sort data=work.palmaresn1Rang;
by N;
run;

proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.VENTES_R, n.VENTES_O, n.VENTES_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

%end;

%else %if  &I_INDICATEUR. = 3 %then %do;
proc sql;
create table work.palmaresn1 as
select r.Lib_region_com, r.marge as MARGE_R, o.marge as MARGE_O, e.marge as MARGE_ECART
from work.palman1R r, work.palman1O o, work.palman1ecart e
where r.Lib_region_com = o.Lib_region_com
and o.Lib_region_com = e.Lib_region_com;

quit;


proc rank data=work.palmaresn1 out=work.palmaresn1Rang descending;
   var MARGE_R;
   ranks N;
run;

proc sort data=work.palmaresn1Rang;
by N;
run;

proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.MARGE_R , n.MARGE_O, n.MARGE_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

%end;

proc print data=work.palmaresfinal noobs;
run;

%end;
%mend;

%tabPalma();

* Début du code EG généré (ne pas modifier cette ligne);
;*';*";*/;quit;
%STPEND;

* Fin du code EG généré (ne pas modifier cette ligne);

