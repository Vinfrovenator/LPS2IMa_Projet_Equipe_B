Drop table if exists FAITS_VENTES;
Drop table if exists DIM_MAGASIN;
Drop table if exists COURS;
Drop table if exists  DEVISE ;
Drop table if exists  DIM_ENSEIGNE ;
Drop table if exists  DIM_DEPARTEMENT ;
Drop table if exists  DIM_FAMILLE_PRODUIT ;
Drop table if exists  DIM_GEOGRAPHIQUE_ADMIN ;
Drop table if exists  DIM_GEOGRAPHIQUE_COM ;
Drop table if exists  DIMS ;
Drop table if exists  FRANCE_DEPARTEMENTS ;
Drop table if exists  PROFIL ;
Drop table if exists  SECURITE ;
Drop table if exists  UTILISATEUR ;


CREATE TABLE COURS(
	ID_DEVISE 		INT NOT NULL ,
	MOIS 					INT NOT NULL ,
	ANNEE  				INT NOT NULL ,
	COURS  				DECIMAL,
	DATEMAJ_COURS DATE,
	PRIMARY KEY (ID_DEVISE, MOIS, ANNEE)
);

CREATE TABLE DEVISE(
	ID_DEVISE 			INT			 			NOT NULL ,
	LIB_DEVISE 			VARCHAR(10) 	NOT NULL ,
	ISOCODE 				VARCHAR(3) 		NOT NULL ,
	SYMBOLE 				VARCHAR(1),
	FORMAT_BO 			VARCHAR(20),
	COURS_FIXE 			DECIMAL,
	DATEMAJ_DEVISE	DATE,
	PRIMARY KEY (ID_DEVISE)
);

CREATE TABLE DIM_DEPARTEMENT(
	ID_DEPARTEMENT 		INT 					NOT NULL ,
	CODE_DEPARTEMENT 	VARCHAR(2) 		NOT NULL ,
	LIB_DEPARTEMENT 	VARCHAR(32) 	NOT NULL ,
	ID_REGION_ADMIN1 	INT 					NOT NULL ,
	ID_REGION_ADMIN2	INT 					NOT NULL ,
	ID_REGION_COM 		INT 					NOT NULL ,
	DATEMAJ_DEP 			DATE,
	PRIMARY KEY (ID_DEPARTEMENT)
);

CREATE TABLE DIM_ENSEIGNE(
	ID_ENSEIGNE 				 				INT 					NOT NULL ,
	LIB_ENSEIGNE 								VARCHAR(32) 	NOT NULL ,
	FICHIER_IMAGE_LOGO_ENSEIGNE VARCHAR(20),
	DATEMAJ_ENSEIGNE 						DATE,
	PRIMARY KEY (ID_ENSEIGNE)
) ;

CREATE TABLE DIM_FAMILLE_PRODUIT(
	ID_FAMILLE_PRODUIT 	INT 				NOT NULL ,
	LIB_FAMILLE_PRODUIT	VARCHAR(32)	NOT NULL ,
	DATEMAJ_FAMPROD 		DATE,
	PRIMARY KEY (ID_FAMILLE_PRODUIT)
);

CREATE TABLE DIM_GEOGRAPHIQUE_ADMIN(
	ID_REGION_ADMIN 			 			INT 				NOT NULL ,
	LIB_REGION_ADMIN 						VARCHAR(50)	NOT NULL ,
	DATE_DEBUT_VALID_ADMIN 			DATE 				NOT NULL ,
	DATE_FIN_VALID_ADMIN				DATE,
	FICHIER_IMAGE_CARTE_REGADM	VARCHAR(50),
	DATEMAJ_GEO_ADMIN 					DATE,
	PRIMARY KEY (ID_REGION_ADMIN)
);

CREATE TABLE DIM_GEOGRAPHIQUE_COM(
	ID_REGION_COM 				 			INT 				NOT NULL ,
	LIB_REGION_COM 							VARCHAR(50) NOT NULL ,
	DATE_DEBUT_VALID_COM 				DATE 				NOT NULL ,
	DATE_FIN_VALID_COM 					DATE,
	FICHIER_IMAGE_CARTE_REGCOM 	VARCHAR(20),
	DATEMAJ_GEO_COM 						DATE,
	PRIMARY KEY (ID_REGION_COM)
) ;

CREATE TABLE DIM_MAGASIN(
	ID_MAGASIN 					 				INT 				NOT NULL ,
	ID_ENSEIGNE 				 				INT 				NOT NULL ,
	ACTIF 											VARCHAR(6),
	DATE_OUVERTURE 							DATE,
	DATE_FERMETURE 							DATE,
	DATE_MAJ 										DATE,
	EMPLACEMENTS 								VARCHAR(32),
	NB_CAISSES 					 				INT,
	VILLE 											VARCHAR(32),
	DEP  												INT,
	FICHIER_IMAGE_CARTE_MAGASIN	VARCHAR(20),
	PRIMARY KEY (ID_MAGASIN)
) ;

CREATE TABLE DIMS(
	IDS 			VARCHAR(8) 	NOT NULL ,
	MOIS  		INT 				NOT NULL ,
	LIB_MOIS 	VARCHAR(10) NOT NULL ,
	TRIMESTRE	INT 				NOT NULL ,
	SEMESTRE 	INT 				NOT NULL ,
	ANNEE  		INT 				NOT NULL ,
	PRIMARY KEY (IDS)
) ;

CREATE TABLE FAITS_VENTES(
	ID_MAGASIN 					INT 				NOT NULL ,
	ID_FAMILLE_PRODUIT	INT 				NOT NULL ,
	ID_TEMPS 					VARCHAR(8)	NOT NULL ,
	VENTES_OBJECTIF 		INT,
	VENTES_REEL 				INT,
	CA_OBJECTIF 				DECIMAL,
	CA_REEL 					 	INT,
	MARGE_OBJECTIF 			DECIMAL,
	MARGE_REEL 					DECIMAL,
	DATE_MAJ 						DATE 				NOT NULL ,
	PRIMARY KEY (ID_MAGASIN, ID_FAMILLE_PRODUIT, ID_TEMPS),
	CONSTRAINT FK_FP FOREIGN KEY (ID_FAMILLE_PRODUIT)	REFERENCES DIM_FAMILLE_PRODUIT (ID_FAMILLE_PRODUIT) ,
	CONSTRAINT FK_FT FOREIGN KEY (ID_TEMPS) REFERENCES DIMS (ID_TEMPS) ,
	CONSTRAINT FK_FM FOREIGN KEY (ID_MAGASIN)	REFERENCES DIM_MAGASIN (ID_MAGASIN)
) ;


CREATE TABLE FRANCE_DEPARTEMENTS(
	CODE_DEPT 				VARCHAR(8) 		NOT NULL ,
	LIB_DEPARTEMENT 	VARCHAR(128),
	ID_REGION_ADMIN1	INT,
	ID_REGION_ADMIN2 	INT,
	ID_REGION_COM 		INT,
	PRIMARY KEY (CODE_DEPT)
) ;

CREATE TABLE PROFIL(
	ID_PROFIL 			INT 				NOT NULL ,
	LIB_PROFIL 			VARCHAR(50)	NOT NULL ,
	TYPE_ZONE 			INT,
	ID_ZONE 				INT,
	USERNAME_BO 		VARCHAR(20),
	PASSWORD_BO 		VARCHAR(20),
	DATEMAJ_PROFIL	DATE,
	PRIMARY KEY (ID_PROFIL)
) ;

CREATE TABLE SECURITE(
	ID_MAGASIN 				INT 	NOT NULL ,
	ID_PROFIL 				INT 	NOT NULL ,
	ONGLET  					INT		NOT NULL ,
	DATEMAJ_SECURITE	DATE,
	PRIMARY KEY (ID_MAGASIN, ID_PROFIL, ONGLET)
);

CREATE TABLE UTILISATEUR(
	ID 	 					INT 					NOT NULL ,
	NOM 					VARCHAR(50) 	NOT NULL ,
	PRENOM 				VARCHAR(50) 	NOT NULL ,
	USERNAME			VARCHAR(50) 	NOT NULL ,
	PASSWORD 			VARCHAR(10) 	NOT NULL ,
	MAIL 					VARCHAR(100) 	NOT NULL ,
	ID_PROFIL 		INT 					NOT NULL ,
	DATEMAJ_USER	DATE,
	PRIMARY KEY (ID)
);

CREATE OR REPLACE VIEW REQUETE_ENSEIGNE (CODE, ID_ENSEIGNE) AS
SELECT 0 AS CODE_ENSEIGNE, ID_ENSEIGNE
FROM DIM_ENSEIGNE
UNION ALL
SELECT DIM_ENSEIGNE.ID_ENSEIGNE as CODE_ENSEIGNE, DIM_ENSEIGNE.ID_ENSEIGNE
FROM DIM_ENSEIGNE;

CREATE OR REPLACE VIEW REQUETE_FAMILLE(CODE, ID_FAMILLE_PRODUIT) AS
SELECT 0 AS CODE_FAMILLE, ID_FAMILLE_PRODUIT
FROM DIM_FAMILLE_PRODUIT
UNION ALL
SELECT DIM_FAMILLE_PRODUIT.ID_FAMILLE_PRODUIT as CODE_FAMILLE, DIM_FAMILLE_PRODUIT.ID_FAMILLE_PRODUIT
FROM DIM_FAMILLE_PRODUIT
ORDER BY CODE;

CREATE OR REPLACE VIEW REQUETE_GEO (CODE, ID_MAGASIN) AS
SELECT 0 AS CODE,ID_MAGASIN FROM DIM_MAGASIN
UNION
SELECT DIM_GEOGRAPHIQUE_COM.ID_REGION_COM*100,ID_MAGASIN FROM DIM_GEOGRAPHIQUE_COM,DIM_MAGASIN, DIM_DEPARTEMENT
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_COM.ID_REGION_COM=DIM_DEPARTEMENT.ID_REGION_COM
UNION
SELECT DIM_DEPARTEMENT.ID_REGION_COM*100+ID_MAGASIN as CODE, ID_MAGASIN
FROM DIM_GEOGRAPHIQUE_COM,DIM_MAGASIN, DIM_DEPARTEMENT
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_COM.ID_REGION_COM=DIM_DEPARTEMENT.ID_REGION_COM
UNION
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100 as CODE,ID_MAGASIN
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN1
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN<23
UNION
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100+ID_MAGASIN as CODE,ID_MAGASIN
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN1
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN<23
UNION
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100 as CODE, ID_MAGASIN
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN2
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN>=23
UNION
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100+ID_MAGASIN as CODE, ID_MAGASIN
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN2
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN>=23
ORDER BY CODE;

CREATE OR REPLACE VIEW SELECT_CUMUL(CODE, LIB_CUMUL) AS
SELECT 0 AS CODE,'Cumulé' AS LIB_CUMUL FROM DUAL
UNION ALL
SELECT 1,'Non cumulé' FROM DUAL ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_DEVISE(CODE, LIB_DEVISE) AS
SELECT ID_DEVISE,LIB_DEVISE from DEVISE ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_ENSEIGNE(CODE, LIB_ENSEIGNE) AS
SELECT 0 AS CODE,'Toutes les enseignes' AS LIB_ENSEIGNE FROM DUAL
UNION ALL
SELECT DIM_ENSEIGNE.ID_ENSEIGNE,DIM_ENSEIGNE.LIB_ENSEIGNE FROM DIM_ENSEIGNE
ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_FAMILLE_PRODUIT(CODE, LIB_FAMILLE) AS
SELECT 0 AS CODE,'Toutes les familles' AS LIB_FAMILLE FROM DUAL
UNION ALL
SELECT ID_FAMILLE_PRODUIT, LIB_FAMILLE_PRODUIT FROM DIM_FAMILLE_PRODUIT;

CREATE OR REPLACE VIEW SELECT_INDICATEUR(CODE, LIB_IND) AS
SELECT 0 as CODE, 'Tous les indicateurs' AS LIB_IND FROM dual
UNION ALL
SELECT 1, 'Chiffres d''affaires' FROM DUAL
UNION ALL
SELECT 2, 'Nombres de ventes' FROM DUAL
UNION ALL
SELECT 3, 'Taux de marges' FROM DUAL
ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_ONGLET(CODE, LIB_ONGLET) AS
SELECT 1 AS CODE, 'Acceuil' AS LIB_ONGLET FROM DUAL UNION ALL
SELECT 2, 'Historique' FROM DUAL UNION ALL
SELECT 3, 'Palmarès' FROM DUAL UNION ALL
SELECT 4, 'Détail' FROM DUAL ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_USER(CODE, USERNAME) AS
SELECT ID AS CODE, USERNAME FROM UTILISATEUR
ORDER BY 1;

CREATE OR REPLACE VIEW SELECT_ZONE_GEO(CODE, LIBELLE) AS
SELECT 0 as CODE,'Toute la france' AS LIBELLE FROM DUAL UNION ALL
SELECT DIM_GEOGRAPHIQUE_COM.ID_REGION_COM*100 as CODE,LIB_REGION_COM as LIBELLE
FROM DIM_GEOGRAPHIQUE_COM
UNION ALL
SELECT DIM_DEPARTEMENT.ID_REGION_COM*100+ID_MAGASIN as CODE, VILLE as LIBELLE
FROM DIM_GEOGRAPHIQUE_COM,DIM_MAGASIN, DIM_DEPARTEMENT
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_COM.ID_REGION_COM=DIM_DEPARTEMENT.ID_REGION_COM
UNION ALL
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100 as CODE,LIB_REGION_ADMIN as LIBELLE
FROM DIM_GEOGRAPHIQUE_ADMIN
WHERE ID_REGION_ADMIN<23
UNION ALL
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100+ID_MAGASIN as CODE, VILLE as LIBELLE
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN1
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN<23
UNION ALL
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100 as CODE,LIB_REGION_ADMIN as LIBELLE
FROM DIM_GEOGRAPHIQUE_ADMIN
WHERE ID_REGION_ADMIN>=23
UNION ALL
SELECT (DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN+9)*100+ID_MAGASIN as CODE, VILLE as LIBELLE
FROM DIM_GEOGRAPHIQUE_ADMIN,DIM_DEPARTEMENT,DIM_MAGASIN
WHERE DIM_MAGASIN.DEP=DIM_DEPARTEMENT.ID_DEPARTEMENT AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN=DIM_DEPARTEMENT.ID_REGION_ADMIN2
AND DIM_GEOGRAPHIQUE_ADMIN.ID_REGION_ADMIN>=23
ORDER BY CODE;