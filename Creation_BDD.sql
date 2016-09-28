Drop table "DARTIES1"."FAITS_VENTES" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_MAGASIN" cascade constraints PURGE;
Drop table "DARTIES1"."COURS" cascade constraints PURGE;
Drop table "DARTIES1"."DEVISE" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_ENSEIGNE" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_DEPARTEMENT" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_FAMILLE_PRODUIT" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_GEOGRAPHIQUE_ADMIN" cascade constraints PURGE;
Drop table "DARTIES1"."DIM_GEOGRAPHIQUE_COM" cascade constraints PURGE;
Drop table "DARTIES1"."DIMS" cascade constraints PURGE;
Drop table "DARTIES1"."FRANCE_DEPARTEMENTS" cascade constraints PURGE;
Drop table "DARTIES1"."PROFIL" cascade constraints PURGE;
Drop table "DARTIES1"."SECURITE" cascade constraints PURGE;
Drop table "DARTIES1"."UTILISATEUR" cascade constraints PURGE;
  
  CREATE TABLE "DARTIES1"."COURS" 
   (	"ID_DEVISE" NUMBER(*,0) NOT NULL ENABLE, 
	"MOIS" NUMBER(*,0) NOT NULL ENABLE, 
	"ANNEE" NUMBER(*,0) NOT NULL ENABLE, 
	"COURS" NUMBER(*,2), 
	"DATEMAJ_COURS" DATE, 
	 PRIMARY KEY ("ID_DEVISE", "MOIS", "ANNEE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."DEVISE" 
   (	"ID_DEVISE" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_DEVISE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"ISOCODE" VARCHAR2(3 BYTE) NOT NULL ENABLE, 
	"SYMBOLE" VARCHAR2(1 BYTE), 
	"FORMAT_BO" VARCHAR2(20 BYTE), 
	"COURS_FIXE" NUMBER(*,2), 
	"DATEMAJ_DEVISE" DATE, 
	 PRIMARY KEY ("ID_DEVISE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."DIM_DEPARTEMENT" 
   (	"ID_DEPARTEMENT" NUMBER(*,0) NOT NULL ENABLE, 
	"CODE_DEPARTEMENT" VARCHAR2(2 BYTE) NOT NULL ENABLE, 
	"LIB_DEPARTEMENT" VARCHAR2(32 BYTE) NOT NULL ENABLE, 
	"ID_REGION_ADMIN1" NUMBER(*,0) NOT NULL ENABLE, 
	"ID_REGION_ADMIN2" NUMBER(*,0) NOT NULL ENABLE, 
	"ID_REGION_COM" NUMBER(*,0) NOT NULL ENABLE, 
	"DATEMAJ_DEP" DATE, 
	 PRIMARY KEY ("ID_DEPARTEMENT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."DIM_ENSEIGNE" 
   (	"ID_ENSEIGNE" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_ENSEIGNE" VARCHAR2(32 BYTE) NOT NULL ENABLE, 
	"FICHIER_IMAGE_LOGO_ENSEIGNE" VARCHAR2(20 BYTE), 
	"DATEMAJ_ENSEIGNE" DATE, 
	 PRIMARY KEY ("ID_ENSEIGNE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."DIM_FAMILLE_PRODUIT" 
   (	"ID_FAMILLE_PRODUIT" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_FAMILLE_PRODUIT" VARCHAR2(32 BYTE) NOT NULL ENABLE, 
	"DATEMAJ_FAMPROD" DATE, 
	 PRIMARY KEY ("ID_FAMILLE_PRODUIT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."DIM_GEOGRAPHIQUE_ADMIN" 
   (	"ID_REGION_ADMIN" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_REGION_ADMIN" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"DATE_DEBUT_VALID_ADMIN" DATE NOT NULL ENABLE, 
	"DATE_FIN_VALID_ADMIN" DATE, 
	"FICHIER_IMAGE_CARTE_REGADM" VARCHAR2(50 BYTE), 
	"DATEMAJ_GEO_ADMIN" DATE, 
	 PRIMARY KEY ("ID_REGION_ADMIN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
  
  CREATE TABLE "DARTIES1"."DIM_GEOGRAPHIQUE_COM" 
   (	"ID_REGION_COM" NUMBER(4,0) NOT NULL ENABLE, 
	"LIB_REGION_COM" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"DATE_DEBUT_VALID_COM" DATE NOT NULL ENABLE, 
	"DATE_FIN_VALID_COM" DATE, 
	"FICHIER_IMAGE_CARTE_REGCOM" VARCHAR2(20 BYTE), 
	"DATEMAJ_GEO_COM" DATE, 
	 PRIMARY KEY ("ID_REGION_COM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
  
    CREATE TABLE "DARTIES1"."DIM_MAGASIN" 
   (	"ID_MAGASIN" NUMBER(*,0) NOT NULL ENABLE, 
	"ID_ENSEIGNE" NUMBER(*,0) NOT NULL ENABLE, 
	"ACTIF" VARCHAR2(6 BYTE), 
	"DATE_OUVERTURE" DATE, 
	"DATE_FERMETURE" DATE, 
	"DATE_MAJ" DATE, 
	"EMPLACEMENTS" VARCHAR2(32 BYTE), 
	"NB_CAISSES" NUMBER(*,0), 
	"VILLE" VARCHAR2(32 BYTE), 
	"DEP" NUMBER(*,0), 
	"FICHIER_IMAGE_CARTE_MAGASIN" VARCHAR2(20 BYTE), 
	 PRIMARY KEY ("ID_MAGASIN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
  
    CREATE TABLE "DARTIES1"."DIMS" 
   (	"IDS" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"MOIS" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_MOIS" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"TRIMESTRE" NUMBER(*,0) NOT NULL ENABLE, 
	"SEMESTRE" NUMBER(*,0) NOT NULL ENABLE, 
	"ANNEE" NUMBER(*,0) NOT NULL ENABLE, 
	 PRIMARY KEY ("IDS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
  
  CREATE TABLE "DARTIES1"."FAITS_VENTES" 
   (	"ID_MAGASIN" NUMBER(*,0) NOT NULL ENABLE, 
	"ID_FAMILLE_PRODUIT" NUMBER(*,0) NOT NULL ENABLE, 
	"IDS" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"VENTES_OBJECTIF" NUMBER(*,0), 
	"VENTES_REEL" NUMBER(*,0), 
	"CA_OBJECTIF" NUMBER(*,2), 
	"CA_REEL" NUMBER(*,2), 
	"MARGE_OBJECTIF" NUMBER(*,2), 
	"MARGE_REEL" NUMBER(*,2), 
	"DATE_MAJ" DATE NOT NULL ENABLE, 
	 PRIMARY KEY ("ID_MAGASIN", "ID_FAMILLE_PRODUIT", "IDS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE, 
	 CONSTRAINT "FK_FP" FOREIGN KEY ("ID_FAMILLE_PRODUIT")
	  REFERENCES "DARTIES1"."DIM_FAMILLE_PRODUIT" ("ID_FAMILLE_PRODUIT") ENABLE, 
	 CONSTRAINT "FK_FT" FOREIGN KEY ("IDS")
	  REFERENCES "DARTIES1"."DIMS" ("IDS") ENABLE, 
	 CONSTRAINT "FK_FM" FOREIGN KEY ("ID_MAGASIN")
	  REFERENCES "DARTIES1"."DIM_MAGASIN" ("ID_MAGASIN") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;


  CREATE TABLE "DARTIES1"."FRANCE_DEPARTEMENTS" 
   (	"CODE_DEPT" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"LIB_DEPARTEMENT" VARCHAR2(128 BYTE), 
	"ID_REGION_ADMIN1" NUMBER(*,0), 
	"ID_REGION_ADMIN2" NUMBER(*,0), 
	"ID_REGION_COM" NUMBER(*,0), 
	 PRIMARY KEY ("CODE_DEPT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."PROFIL" 
   (	"ID_PROFIL" NUMBER(*,0) NOT NULL ENABLE, 
	"LIB_PROFIL" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"TYPE_ZONE" NUMBER(*,0), 
	"ID_ZONE" NUMBER(*,0), 
	"USERNAME_BO" VARCHAR2(20 BYTE), 
	"PASSWORD_BO" VARCHAR2(20 BYTE), 
	"DATEMAJ_PROFIL" DATE, 
	 PRIMARY KEY ("ID_PROFIL")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
  
  CREATE TABLE "DARTIES1"."SECURITE" 
   (	"ID_MAGASIN" NUMBER(*,0) NOT NULL ENABLE, 
	"ID_PROFIL" NUMBER(*,0) NOT NULL ENABLE, 
	"ONGLET" NUMBER(*,0) NOT NULL ENABLE, 
	"DATEMAJ_SECURITE" DATE, 
	 PRIMARY KEY ("ID_MAGASIN", "ID_PROFIL", "ONGLET")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;

  CREATE TABLE "DARTIES1"."UTILISATEUR" 
   (	"ID" NUMBER(*,0) NOT NULL ENABLE, 
	"NOM" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"PRENOM" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"USERNAME" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"PASSWORD" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"MAIL" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"ID_PROFIL" NUMBER(*,0) NOT NULL ENABLE, 
	"DATEMAJ_USER" DATE, 
	 PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ETUDIANTS" ;
