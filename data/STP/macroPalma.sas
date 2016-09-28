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
*  I_CUMUL
*       Type : Numérique
*      Libellé : I_CUMUL
*       Attr: Visible, Obligatoire
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

%global I_CUMUL
        I_ENSEIGNE
        I_FAMPROD
        I_INDICATEUR
        I_REGION
        I_TEMPS;

%STPBEGIN;

* Fin du code EG généré (ne pas modifier cette ligne);


/*macro de rassemblement des données*/
%macro rassemblementDonnees();

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


/* Conception de la table contenant les valeurs temporelles */

%let SELECT_CUMUL=&I_CUMUL.;


CREATE TABLE work.REQUETE_TEMPS AS
SELECT * FROM connection to ora12c(
WITH RECURSIVE_CUMULATED_MONTH1(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH1.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH1.MONTH_REF-1 AND
DIM_TEMPS.MOIS>=1
),
RECURSIVE_CUMULATED_MONTH(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH.MONTH_REF-1 AND DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_MONTH2(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH2.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH2.MONTH_REF-1 AND
DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_TRIMESTER1(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER1.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER1.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_TRIMESTER(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_TRIMESTER2(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER2.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER2.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_SEMESTER1(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER1.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER1.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER2(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER2.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER2.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
)
SELECT
TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))||'_1_'||TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
AS CODE,ID_TEMPS AS ID_TEMPS FROM DIM_TEMPS WHERE
ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT
TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1)
,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT
TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2)
,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER2
WHERE &SELECT_CUMUL=0);


/* Conception de la table contenant les valeurs temporelles pour le cumul */

%let SELECT_CUMUL = &I_CUMUL.;


CREATE TABLE work.REQUETE_TEMPS_CUMUL AS
SELECT * FROM connection to ora12c(
WITH RECURSIVE_CUMULATED_MONTH1(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH1.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH1.MONTH_REF-1 AND
DIM_TEMPS.MOIS>=1
),
RECURSIVE_CUMULATED_MONTH(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH.MONTH_REF-1 AND DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_MONTH2(CODE,ID_TEMPS,YEAR_REF, MONTH_REF) AS (
SELECT ANNEE||'_4_'||MOIS, ID_TEMPS,ANNEE,MOIS  from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,MOIS  from
RECURSIVE_CUMULATED_MONTH2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_MONTH2.YEAR_REF AND
DIM_TEMPS.MOIS=RECURSIVE_CUMULATED_MONTH2.MONTH_REF-1 AND
DIM_TEMPS.MOIS>=1
) ,
RECURSIVE_CUMULATED_TRIMESTER1(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER1.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER1.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_TRIMESTER(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_TRIMESTER2(CODE,ID_TEMPS,YEAR_REF, TRIMESTER_REF) AS (
SELECT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS,ANNEE,TRIMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,TRIMESTRE  from
RECURSIVE_CUMULATED_TRIMESTER2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_TRIMESTER2.YEAR_REF AND
DIM_TEMPS.TRIMESTRE=RECURSIVE_CUMULATED_TRIMESTER2.TRIMESTER_REF-1 AND
DIM_TEMPS.TRIMESTRE>=1
),
RECURSIVE_CUMULATED_SEMESTER1(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER1, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER1.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER1.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER2(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER2, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER2.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER2.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
) ,
RECURSIVE_CUMULATED_SEMESTER(CODE,ID_TEMPS,YEAR_REF, SEMESTER_REF) AS (
SELECT ANNEE||'_2_'||SEMESTRE,ID_TEMPS,ANNEE,SEMESTRE from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT CODE, DIM_TEMPS.ID_TEMPS,ANNEE,SEMESTRE  from
RECURSIVE_CUMULATED_SEMESTER, DIM_TEMPS
WHERE DIM_TEMPS.ANNEE=RECURSIVE_CUMULATED_SEMESTER.YEAR_REF AND
DIM_TEMPS.SEMESTRE=RECURSIVE_CUMULATED_SEMESTER.SEMESTER_REF-1 AND
DIM_TEMPS.SEMESTRE>=1
)
SELECT
TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))||'_1_'||TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
AS CODE,ID_TEMPS AS ID_TEMPS FROM DIM_TEMPS WHERE
ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER1
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT
TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1)
,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-1  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT
TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2)||'_1_'||TO_CHAR(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2)
,ID_TEMPS  FROM DIM_TEMPS WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
UNION ALL
SELECT ANNEE||'_4_'||MOIS,  ID_TEMPS from DIM_TEMPS
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_MONTH2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_3_'||TRIMESTRE,ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
TRIMESTRE=T1.TRIMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_TRIMESTER2
WHERE &SELECT_CUMUL=0
UNION ALL
SELECT DISTINCT ANNEE||'_2_'||SEMESTRE, ID_TEMPS from DIM_TEMPS T1
WHERE ANNEE=TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-2  AND MOIS IN (SELECT
DISTINCT MOIS FROM DIM_TEMPS WHERE ANNEE=T1.ANNEE AND
SEMESTRE=T1.SEMESTRE)
AND &SELECT_CUMUL=1
UNION ALL
SELECT DISTINCT CODE,ID_TEMPS FROM RECURSIVE_CUMULATED_SEMESTER2
WHERE &SELECT_CUMUL=0);




/* On tri la table faits_ventes par l'ID de la famille de produit et par
l'ID de magasin*/
PROC SORT DATA=ORA12015.DWR_FAITS_VENTES
                  OUT= WORK.FAITS_VENTES_TRI;
                BY ID_FAMILLE_PRODUIT ID_MAGASIN ID_TEMPS;
RUN;

/* On merge la table triée précedemment avec la table Dim_Famille_Produit
pour avoir le label du produit*/
DATA WORK.MERGE_FAITS_PRODUIT;
        MERGE WORK.FAITS_VENTES_TRI (in=a)
                  ORA12015.DIM_FAMILLE_PRODUIT(in=b);
        BY ID_FAMILLE_PRODUIT;
        if a and b then output;
RUN;

DATA WORK.MERGE1;
        MERGE ORA12015.UTILISATEUR (in=a)
                  ora12015.PROFIL(in=b);
        BY ID_PROFIL;
        if a and b then output;
run;

DATA WORK.MERGE2;
        MERGE WORK.MERGE1(in=a)
                  ORA12015.SECURITE(in=b);
        BY ID_PROFIL;
        if a and b then output;
run;

PROC SORT DATA=WORK.MERGE2;
        BY ID_MAGASIN;
run;

DATA WORK.MERGE3;
        MERGE WORK.MERGE2 (in=a)
                  ORA12015.DIM_MAGASIN(in=b);
        BY ID_MAGASIN;
        if a and b then output;
run;

PROC SQL;
        CREATE TABLE WORK.MERGE4 AS
                SELECT * FROM WORK.MERGE3
                INNER JOIN ORA12015.DIM_DEPARTEMENT ON DIM_DEPARTEMENT.ID_DEPARTEMENT =
MERGE3.DEP;
quit;

PROC SORT DATA= WORK.MERGE4;
by ID_ENSEIGNE;
run;


DATA WORK.MERGE5;
        MERGE WORK.MERGE4(in=a)
                  ORA12015.DIM_ENSEIGNE(in=b);
        BY ID_ENSEIGNE;
        if a and b then output;
run;

PROC SORT DATA=WORK.REQUETE_TEMPS;
by code;
run;

DATA WORK.MERGE6;
        MERGE WORK.REQUETE_TEMPS (in=a)
                  ORA12015.SELECT_TEMPS (in=b);
        BY CODE;
        if a and b then output;
run;

PROC SORT DATA=WORK.MERGE5;
by ID_MAGASIN;
run;

PROC SORT DATA=WORK.MERGE_FAITS_PRODUIT;
by ID_MAGASIN;
run;

DATA WORK.MERGE7;
        MERGE WORK.MERGE_FAITS_PRODUIT (in=a)
                  WORK.MERGE5(in=b);
        BY ID_MAGASIN;
        if a and b then output;
run;


PROC SORT DATA=WORK.MERGE6;
by ID_TEMPS;
run;

PROC SORT DATA=WORK.MERGE7;
by ID_TEMPS;
run;

DATA WORK.MERGE8;
        MERGE WORK.MERGE6
                  WORK.MERGE7;
        BY ID_TEMPS;
run;


PROC SORT DATA=WORK.MERGE8;
by id_famille_produit id_magasin;
run;


DATA WORK.DATATABLE2;
        SET WORK.MERGE8;
        by id_famille_produit id_magasin ;


        /* Definition de l'année et du mois en extrayant ces valeur de ID_TEMPS */
        ANNEE = SUBSTR(ID_TEMPS,1,4);
        MOIS = SUBSTR(ID_TEMPS,5,2);

        id_i=0;
        if indicateur="CA" then id_i=1;
        if indicateur="VENTES" then id_i=2;
        if indicateur="MARGE" then id_i=3;
		if id_famille_produit = 1 then lib_famille_produit= "Four";
	if id_famille_produit = 2 then lib_famille_produit= "Hifi";
	if id_famille_produit = 3 then lib_famille_produit= "Magnetoscope";
	if id_region_com = 1 then lib_region_com = "Nord_Ouest";
	if id_region_com = 2 then lib_region_com = "Nord_Est";
	if id_region_com = 3 then lib_region_com = "Sud_Ouest";
	if id_region_com = 4 then lib_region_com = "Sud_Est";
	if id_region_com = 5 then lib_region_com = "Région_parisienne";

RUN;


%mend;

/*On utilise la macro : */
%rassemblementDonnees();

libname ORA12015 meta library="ORA-DARTIES1-2015";

/*données en fonction des filtres : */
PROC SQL;
CREATE TABLE work.transi as
	SELECT * from work.datatable2 
	where id_i in( select id_i from ora12015.CODES_INDICATEUR where CODE=&I_INDICATEUR.)
	AND id_famille_produit in(select id_famille_produit from ora12015.REQUETE_FAMILLE where CODE = &I_FAMPROD.)
	AND id_enseigne in(select id_enseigne from ora12015.requete_enseigne where code= &I_ENSEIGNE.)
	AND id_temps in(select id_temps from work.requete_temps where code= "&I_TEMPS.")
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = 0)
	;
quit;

/*macro pour créer le tableau palmares :*/
%macro tabPalma ();

/*trier la table :*/
proc sort data=work.transi out=work.palma (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

/*étape data pour calculer le réel, l'objectif et l'écart */
data work.palma (keep=Lib_region_com indicateur cumulR cumulO ecart) ;
attrib cumulR label="cumul réel";
attrib cumulO label="cumul objectif";
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

if reel = ''  then do;

end;
else do;
cumulR = cumulR+ reel;
end;

if objectif = ''  then do;

end;
else do;
cumulO = cumulO+ objectif;
end;

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

/*proc transpose pour avoir les valeurs des 3 indicateurs sur une ligne*/
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

/*creation de la table palmares en fonction du filtre indicateur : */
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
/*pour avoir le classement sur la période n-1*/
/*même chose que pour la première partie, mais on change la période */
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
	AND id_magasin in(select id_magasin from ora12015.requete_geo where code = 0)
	;
quit;



proc sort data=work.transiN1 out=work.palman1 (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

data work.palman1 (keep=Lib_region_com indicateur cumulR cumulO ecart) ;
attrib cumulR label="cumul réel";
attrib cumulO label="cumul objectif";
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

if reel = ''  then do;

end;
else do;
cumulR = cumulR+ reel;
end;

if objectif = ''  then do;

end;
else do;
cumulO = cumulO+ objectif;
end;

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

/*creation d'une table avec les valeurs des rang n-1 et l'évolution entre les deux périodes*/
proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.CA_R, n.CA_O, n.CA_ECART, n.VENTES_R, n.VENTES_O, n.VENTES_ECART, n.MARGE_R , n.MARGE_O, n.MARGE_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

/*affichage de la table :*/
proc print data= work.palmaresfinal noobs;

sum CA_R CA_O ventes_o ventes_r marge_r marge_o;
run;
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

/*creation d'une table avec les valeurs des rang n-1 et l'évolution entre les deux périodes*/
proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.CA_R, n.CA_O, n.CA_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

/*affichage de la table :*/
proc print data= work.palmaresfinal noobs;
sum CA_R CA_O;
run;
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

/*creation d'une table avec les valeurs des rang n-1 et l'évolution entre les deux périodes*/
proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.VENTES_R, n.VENTES_O, n.VENTES_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;

/*affichage de la table :*/
proc print data= work.palmaresfinal noobs;
sum ventes_r ventes_o;
run;
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

/*creation d'une table avec les valeurs des rang n-1 et l'évolution entre les deux périodes*/
proc sql;
create table work.palmaresFinal as
select n.Lib_region_com, n.MARGE_R , n.MARGE_O, n.MARGE_ECART, n.N as N, n1.N as N1, n1.N - n.N  as evo
from work.palmaresRang n, work.palmaresn1Rang n1
where n.Lib_region_com = n1.Lib_region_com;
run;
quit;
/*affichage de la table :*/
proc print data= work.palmaresfinal noobs;
sum marge_r marge_o;
run;

%end;


%mend;

/*macro pour le tableau palmares s'il n'y a pas de données sur la periode n-1*/
%macro tabPalmabis ();
proc sort data=work.transi out=work.palma (keep=id_region_com lib_region_com id_famille_produit lib_famille_Produit indicateur objectif reel);
by id_region_com indicateur ;

data work.palma (keep=Lib_region_com indicateur cumulR cumulO ecart) ;

attrib cumulR label="cumul réel";
attrib cumulO label="cumul objectif";
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

if reel = ''  then do;

end;
else do;
cumulR = cumulR+ reel;
end;

if objectif = ''  then do;

end;
else do;
cumulO = cumulO+ objectif;
end;

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

proc print data=work.palmaresrang noobs;
sum ca_o ca_r ventes_r ventes_o marge_o marge_r;
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

proc print data=work.palmaresrang noobs;
sum ca_o ca_r;
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

proc print data=work.palmaresrang noobs;
sum ventes_o ventes_r;
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

proc print data=work.palmaresrang noobs;
sum marge_o marge_r;
run;
%end;

%mend;

%macro tabPalma2 ();

proc sql noprint;
select distinct count(*) into: methode1
from work.transi;
quit;

proc sql noprint;
select ordre into : ordren1
from ORA12015.select_temps
where code = "&I_TEMPS.";
quit;

%if &methode1. = 0 %then %do;

%end;
%else %do;
	%if &ordren1. = 40 or &ordren1. > 40 %then %do;
	%tabPalmabis();

	%end;
	%else %do;
	%tabPalma();
	%end;
%end;

%mend;

%tabPalma2();

* Début du code EG généré (ne pas modifier cette ligne);
;*';*";*/;quit;
%STPEND;

* Fin du code EG généré (ne pas modifier cette ligne);

