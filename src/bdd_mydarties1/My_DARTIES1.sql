
USE `darties1` ;


-- -----------------------------------------------------

-- Table `devise`

-- -----------------------------------------------------

drop table if exists faits_ventes;
drop table if exists dim_magasin;
drop table if exists cours;
drop table if exists devise ;
drop table if exists dim_enseigne ;
drop table if exists dim_departement ;
drop table if exists dim_famille_produit ;
drop table if exists dim_geographique_admin ;
drop table if exists dim_geographique_com ;
drop table if exists france_departements ;
drop table if exists profil ;
drop table if exists securite ;
drop table if exists utilisateur ;

DROP TABLE IF EXISTS cours,devise CASCADE ;
DROP TABLE IF EXISTS securite,securite_star CASCADE ;
DROP TABLE IF EXISTS dim_departement, france_departements, faits_ventes_star, faits_ventes, dim_magasin_star, dim_magasin CASCADE ;
DROP TABLE IF EXISTS dim_enseigne,dim_famille_produit, dim_geographique_admin, dim_geographique_com,dim_temps, utilisateur,profil CASCADE ;
DROP TABLE IF EXISTS`dim_departement` ,`dim_geographique_admin` ,`dim_geographique_com` ,`france_departements` ;



CREATE  TABLE IF NOT EXISTS `devise` (

  `ID_DEVISE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant devise' ,

  `LIB_DEVISE` VARCHAR(10) NOT NULL COMMENT 'Libelle devise' ,

  `ISOCODE` VARCHAR(3) NOT NULL COMMENT 'Code ISO de la device pour le web service d\'alimentation' ,

  `SYMBOLE` VARCHAR(1) NULL DEFAULT NULL COMMENT 'Symbole de la devise' ,

  `FORMAT_BO` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Format a utiliser dans BO' ,

  `COURS_FIXE` DECIMAL(38,2) NULL DEFAULT NULL COMMENT 'Pour les anciennes monnaies avant euro, la conversion fixe � utiliser' ,

  `DATEMAJ_DEVISE` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_DEVISE`) ,

  UNIQUE INDEX `ISOCODE_UNIQUE` (`ISOCODE` ASC) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Devises pour l\'affichage';





-- -----------------------------------------------------

-- Table `cours`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `cours` CASCADE;



CREATE  TABLE IF NOT EXISTS `cours` (

  `ID_DEVISE` INT(11) NOT NULL COMMENT 'Devise du cours' ,

  `MOIS` DECIMAL(38,0) NOT NULL COMMENT 'Mois du cours' ,

  `ANNEE` DECIMAL(38,0) NOT NULL COMMENT 'Annee du cours' ,

  `COURS` DECIMAL(38,2) NOT NULL COMMENT 'Cours par rapport a l\'\'unite de compte (euro)' ,

  `DATEMAJ_COURS` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_DEVISE`, `MOIS`, `ANNEE`) ,

  INDEX `fk_cours_devise1` (`ID_DEVISE` ASC) ,

  CONSTRAINT `fk_cours_devise1`

    FOREIGN KEY (`ID_DEVISE` )

    REFERENCES `devise` (`ID_DEVISE` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Cours fluctuants';





-- -----------------------------------------------------

-- Table `dim_geographique_com`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_geographique_com` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_geographique_com` (

  `ID_REGION_COM` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de la region commerciale' ,

  `LIB_REGION_COM` VARCHAR(50) NOT NULL COMMENT 'Libelle de la region commerciale' ,

  `DATE_DEBUT_VALID_COM` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP COMMENT 'Date de debut de validite de la region commerciale' ,

  `DATE_FIN_VALID_COM` TIMESTAMP NULL DEFAULT NULL COMMENT 'Date de fin de validite de la region commerciale' ,

  `FICHIER_IMAGE_CARTE_REGCOM` VARCHAR(20) NOT NULL COMMENT 'Nom du fichier image la carte de la region commerciale' ,

  `DATEMAJ_GEO_COM` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_REGION_COM`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les regions commerciales (flocon)';





-- -----------------------------------------------------

-- Table `dim_geographique_admin`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_geographique_admin` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_geographique_admin` (

  `ID_REGION_ADMIN` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de la region administrative' ,

  `LIB_REGION_ADMIN` VARCHAR(50) NOT NULL COMMENT 'Libelle de la region administrative' ,

  `DATE_DEBUT_VALID_ADMIN` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP COMMENT 'Date de debut de validite de la region administrative' ,

  `DATE_FIN_VALID_ADMIN` TIMESTAMP NULL DEFAULT NULL COMMENT 'Date de fin de validite de la region administrative' ,

  `FICHIER_IMAGE_CARTE_REGADM` VARCHAR(50) NOT NULL COMMENT 'Nom du fichier image la carte de la region administrative' ,

  `DATEMAJ_GEO_ADMIN` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_REGION_ADMIN`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les regions administratives (flocon)';





-- -----------------------------------------------------

-- Table `france_departements`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `france_departements` CASCADE;



CREATE  TABLE IF NOT EXISTS `france_departements` (

  `CODE_DEPT` VARCHAR(2) NOT NULL COMMENT 'Code INSEE du departement' ,

  `LIB_DEPARTEMENT` VARCHAR(128) NOT NULL COMMENT 'Nom du departement' ,

  `ID_REGION_ADMIN1` DECIMAL(38,0) NOT NULL COMMENT 'Reference a la region administrative ancienne du departement' ,

  `ID_REGION_ADMIN2` DECIMAL(38,0) NOT NULL COMMENT 'Reference a la region administrative nouvelle du departement' ,

  `ID_REGION_COM` DECIMAL(38,0) NOT NULL COMMENT 'Reference a la region commerciale du departement' ,

  PRIMARY KEY (`CODE_DEPT`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les departements de la france metropolitaine';





-- -----------------------------------------------------

-- Table `dim_departement`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_departement` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_departement` (

  `ID_DEPARTEMENT` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du departement' ,

  `CODE_DEPARTEMENT` VARCHAR(2) NOT NULL COMMENT 'Code INSEE du departement' ,

  `LIB_DEPARTEMENT` VARCHAR(128) NOT NULL COMMENT 'Nom du departement' ,

  `ID_REGION_ADMIN1` INT(11) NOT NULL COMMENT 'Reference a la region administrative ancienne du departement' ,

  `ID_REGION_ADMIN2` INT(11) NOT NULL COMMENT 'Reference a la region administrative nouvelle du departement' ,

  `ID_REGION_COM` INT(11) NOT NULL COMMENT 'Reference a la region commerciale du departement' ,

  `DATEMAJ_DEP` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_DEPARTEMENT`) ,

  INDEX `fk_dim_departement_dim_geographique_com1` (`ID_REGION_COM` ASC) ,

  INDEX `fk_dim_departement_dim_geographique_admin1` (`ID_REGION_ADMIN1` ASC) ,

  INDEX `fk_dim_departement_dim_geographique_admin2` (`ID_REGION_ADMIN2` ASC) ,

  INDEX `fk_dim_departement_france_departements1` (`CODE_DEPARTEMENT` ASC) ,

  UNIQUE INDEX `CODE_DEPARTEMENT_UNIQUE` (`CODE_DEPARTEMENT` ASC) ,

  CONSTRAINT `fk_dim_departement_dim_geographique_com1`

    FOREIGN KEY (`ID_REGION_COM` )

    REFERENCES `dim_geographique_com` (`ID_REGION_COM` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION,

  CONSTRAINT `fk_dim_departement_dim_geographique_admin1`

    FOREIGN KEY (`ID_REGION_ADMIN1` )

    REFERENCES `dim_geographique_admin` (`ID_REGION_ADMIN` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION,

  CONSTRAINT `fk_dim_departement_dim_geographique_admin2`

    FOREIGN KEY (`ID_REGION_ADMIN2` )

    REFERENCES `dim_geographique_admin` (`ID_REGION_ADMIN` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION,

  CONSTRAINT `fk_dim_departement_france_departements1`

    FOREIGN KEY (`CODE_DEPARTEMENT` )

    REFERENCES `france_departements` (`CODE_DEPT` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les departement des magasins (flocon)';





-- -----------------------------------------------------

-- Table `dim_enseigne`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_enseigne` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_enseigne` (

  `ID_ENSEIGNE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de l\'enseigne' ,

  `LIB_ENSEIGNE` VARCHAR(32) NOT NULL COMMENT 'Libelle de l\'enseigne' ,

  `FICHIER_IMAGE_LOGO_ENSEIGNE` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Nom du fichier image du logo de l\'enseigne' ,

  `DATEMAJ_ENSEIGNE` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_ENSEIGNE`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les enseignes du groupe Darties (flocon)';





-- -----------------------------------------------------

-- Table `dim_famille_produit`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_famille_produit` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_famille_produit` (

  `ID_FAMILLE_PRODUIT` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de la famille des produits' ,

  `LIB_FAMILLE_PRODUIT` VARCHAR(32) NOT NULL COMMENT 'Libelle de la famille des produits' ,

  `DATEMAJ_FAMPROD` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_FAMILLE_PRODUIT`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les familles des produits';





-- -----------------------------------------------------

-- Table `dim_magasin`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_magasin` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_magasin` (

  `ID_MAGASIN` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du magasin' ,

  `ID_ENSEIGNE` INT(11) NOT NULL COMMENT 'Reference a l\'enseigne du magasin' ,

  `ACTIF` VARCHAR(6) NOT NULL COMMENT 'Statut d\'activite du magasin' ,

  `DATE_OUVERTURE` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP COMMENT 'Date d\'ouverture du magasin' ,

  `DATE_FERMETURE` TIMESTAMP NULL DEFAULT NULL COMMENT 'Date de fermeture du magasin' ,

  `DATE_MAJ` TIMESTAMP NOT NULL  default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT 'Date de la derniere mise � jour' ,

  `EMPLACEMENTS` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Emplacements - Elements d\'adresse du magasin' ,

  `NB_CAISSES` DECIMAL(38,0) NULL DEFAULT NULL COMMENT 'Nombre de caisses dans le magasin' ,

  `VILLE` VARCHAR(32) NOT NULL COMMENT 'Ville du magasin' ,

  `DEP` INT(11) NOT NULL COMMENT 'Departement du magasin' ,

  `FICHIER_IMAGE_CARTE_MAGASIN` VARCHAR(20) NOT NULL COMMENT 'Nom du fichier image la carte du magasin' ,

  PRIMARY KEY (`ID_MAGASIN`) ,

  INDEX `fk_dim_magasin_dim_enseigne1` (`ID_ENSEIGNE` ASC) ,

  INDEX `fk_dim_magasin_dim_departement1` (`DEP` ASC) ,

  CONSTRAINT `fk_dim_magasin_dim_enseigne1`

    FOREIGN KEY (`ID_ENSEIGNE` )

    REFERENCES `dim_enseigne` (`ID_ENSEIGNE` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION,

  CONSTRAINT `fk_dim_magasin_dim_departement1`

    FOREIGN KEY (`DEP` )

    REFERENCES `dim_departement` (`ID_DEPARTEMENT` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les magasins (flocon)';





-- -----------------------------------------------------

-- Table `dim_temps`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `dim_temps` CASCADE;



CREATE  TABLE IF NOT EXISTS `dim_temps` (

  `ID_TEMPS` VARCHAR(8) NOT NULL COMMENT 'Identifiant de la periode de temps' ,

  `MOIS` DECIMAL(38,0) NOT NULL COMMENT 'Mois de la periode de temps' ,

  `LIB_MOIS` VARCHAR(10) NOT NULL COMMENT 'Libelle du mois de la periode de temps' ,

  `TRIMESTRE` DECIMAL(38,0) NOT NULL COMMENT 'Trimestre de la periode de temps' ,

  `SEMESTRE` DECIMAL(38,0) NOT NULL COMMENT 'Semestre de la periode de temps' ,

  `ANNEE` DECIMAL(38,0) NOT NULL COMMENT 'Annee de la periode de temps' ,

  PRIMARY KEY (`ID_TEMPS`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les periodes de temps';





-- -----------------------------------------------------

-- Table `faits_ventes`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `faits_ventes` CASCADE;



CREATE  TABLE IF NOT EXISTS `faits_ventes` (

  `ID_MAGASIN` INT(11) NOT NULL COMMENT 'magasin concerne' ,

  `ID_FAMILLE_PRODUIT` INT(11) NOT NULL COMMENT 'famille de produit concernee' ,

  `ID_TEMPS` VARCHAR(8) NOT NULL COMMENT 'periode de temps concernee' ,

  `VENTES_OBJECTIF` DECIMAL(38,0) NOT NULL COMMENT 'Objectif pour les ventes' ,

  `VENTES_REEL` DECIMAL(38,0) NULL COMMENT 'Nombre de ventes realisees' ,

  `CA_OBJECTIF` DECIMAL(38,2) NOT NULL COMMENT 'Objectif pour le chiffre d\'affaires' ,

  `CA_REEL` DECIMAL(38,2) NULL COMMENT 'Chiffre d\'affaires realise' ,

  `MARGE_OBJECTIF` DECIMAL(38,2) NOT NULL COMMENT 'Objectif pour la marge' ,

  `MARGE_REEL` DECIMAL(38,2) NULL COMMENT 'Marge realisee' ,

  `DATE_MAJ` TIMESTAMP NOT NULL COMMENT 'Date de derniere mise a jour' ,

  PRIMARY KEY (`ID_MAGASIN`, `ID_FAMILLE_PRODUIT`, `ID_TEMPS`) ,

  INDEX `FK_FP` (`ID_FAMILLE_PRODUIT` ASC) ,

  INDEX `FK_FT` (`ID_TEMPS` ASC) ,

  CONSTRAINT `faits_ventes_ibfk_1`

    FOREIGN KEY (`ID_FAMILLE_PRODUIT` )

    REFERENCES `dim_famille_produit` (`ID_FAMILLE_PRODUIT` )

    ON DELETE NO ACTION

    ON UPDATE CASCADE,

  CONSTRAINT `faits_ventes_ibfk_2`

    FOREIGN KEY (`ID_MAGASIN` )

    REFERENCES `dim_magasin` (`ID_MAGASIN` )

    ON DELETE NO ACTION

    ON UPDATE CASCADE,

  CONSTRAINT `faits_ventes_ibfk_3`

    FOREIGN KEY (`ID_TEMPS` )

    REFERENCES `dim_temps` (`ID_TEMPS` )

    ON DELETE NO ACTION

    ON UPDATE CASCADE)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Fait ventes (flocon)';





-- -----------------------------------------------------

-- Table `profil`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `profil` CASCADE;



CREATE  TABLE IF NOT EXISTS `profil` (

  `ID_PROFIL` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du profil' ,

  `LIB_PROFIL` VARCHAR(50) NOT NULL COMMENT 'Libelle du profil' ,

  `TYPE_ZONE` DECIMAL(38,0) NULL DEFAULT NULL COMMENT 'Type de la zone (zone commerciale, magasin) du profil' ,

  `ID_ZONE` DECIMAL(38,0) NULL DEFAULT NULL COMMENT 'Identifiant de la zone concernee (zone commerciale ou magasin) du profil' ,

  `USERNAME_BO` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Identifiant dans SAP Business Objects XI 3.1' ,

  `PASSWORD_BO` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Mot de passe pour SAP BusinessObjects XI 3.1' ,

  `DATEMAJ_PROFIL` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_PROFIL`) )

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'La securite est basee sur les profils.';





-- -----------------------------------------------------

-- Table `securite`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `securite` CASCADE;



CREATE  TABLE IF NOT EXISTS `securite` (

  `ID_MAGASIN` INT(11) NOT NULL COMMENT 'Visibilite des donnees du magasin' ,

  `ID_PROFIL` INT(11) NOT NULL COMMENT 'Visibilite du profil' ,

  `ONGLET` INT(11) NOT NULL COMMENT 'Selon l\'onglet du tableau de bord, des informations peuvent etre necessaires' ,

  `DATEMAJ_SECURITE` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID_MAGASIN`, `ID_PROFIL`, `ONGLET`) ,

  INDEX `fk_securite_profil1` (`ID_PROFIL` ASC) ,

  INDEX `fk_securite_dim_magasin1` (`ID_MAGASIN` ASC) ,

  CONSTRAINT `fk_securite_profil1`

    FOREIGN KEY (`ID_PROFIL` )

    REFERENCES `profil` (`ID_PROFIL` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION,

  CONSTRAINT `fk_securite_dim_magasin1`

    FOREIGN KEY (`ID_MAGASIN` )

    REFERENCES `dim_magasin` (`ID_MAGASIN` )

    ON DELETE NO ACTION

    ON UPDATE NO ACTION)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Visibilite en fonction du profil (flocon)';





-- -----------------------------------------------------

-- Table `utilisateur`

-- -----------------------------------------------------

DROP TABLE IF EXISTS `utilisateur` CASCADE;



CREATE  TABLE IF NOT EXISTS `utilisateur` (

  `ID` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de l\'utilisateur' ,

  `NOM` VARCHAR(50) NOT NULL COMMENT 'Nom de l\'utilisateur' ,

  `PRENOM` VARCHAR(50) NOT NULL COMMENT 'Prenom  de l\'utilisateur' ,

  `USERNAME` VARCHAR(50) NOT NULL COMMENT 'Login de l\'utilisateur' ,

  `PASSWORD` VARCHAR(10) NOT NULL COMMENT 'Mot de passe de l\'utilisateur' ,

  `MAIL` VARCHAR(100) NOT NULL COMMENT 'Adresse electronique de l\'utilisateur' ,

  `ID_PROFIL` INT(11) NOT NULL COMMENT 'Reference au profil de l\'utilisateur' ,

  `DATEMAJ_USER` TIMESTAMP NOT NULL COMMENT 'Date de la derniere mise a jour' ,

  PRIMARY KEY (`ID`) ,

  INDEX `FK_PROFIL` (`ID_PROFIL` ASC) ,

  UNIQUE INDEX `USERNAME_UNIQUE` (`USERNAME` ASC) ,

  UNIQUE INDEX `ID_PROFIL_UNIQUE` (`ID_PROFIL` ASC) ,

  UNIQUE INDEX `MAIL_UNIQUE` (`MAIL` ASC) ,

  CONSTRAINT `UTILISATEUR_ibfk_1`

    FOREIGN KEY (`ID_PROFIL` )

    REFERENCES `profil` (`ID_PROFIL` )

    ON DELETE NO ACTION

    ON UPDATE CASCADE)

ENGINE = InnoDB

DEFAULT CHARACTER SET = utf8

COMMENT = 'Les utilisateurs du portail';


DROP TABLE IF EXISTS dim_magasin_star CASCADE ;


CREATE TABLE dim_magasin_star ENGINE=InnoDB DEFAULT CHARACTER SET = utf8 COMMENT ='Les magasins (etoile)' AS
SELECT DISTINCT ID_MAGASIN,
    ACTIF,
    DATE_OUVERTURE ,
    DATE_FERMETURE ,
    DATE_MAJ ,
    EMPLACEMENTS ,
    NB_CAISSES ,
    VILLE ,
    FICHIER_IMAGE_CARTE_MAGASIN ,
  dim_enseigne.ID_ENSEIGNE,
  LIB_ENSEIGNE,
    FICHIER_IMAGE_LOGO_ENSEIGNE,
  ID_DEPARTEMENT,
    CODE_DEPARTEMENT,
    LIB_DEPARTEMENT ,
    ANC_ADMIN.ID_REGION_ADMIN AS ID_REGION_ANC_ADMIN,
    ANC_ADMIN.LIB_REGION_ADMIN AS LIB_REGION_ANC_ADMIN,
    ANC_ADMIN.DATE_DEBUT_VALID_ADMIN AS DATE_DEBUT_VALID_ANC_ADMIN,
    ANC_ADMIN.DATE_FIN_VALID_ADMIN AS DATE_FIN_VALID_ANC_ADMIN,
    ANC_ADMIN.FICHIER_IMAGE_CARTE_REGADM AS FICHIER_IMG_ANC_REG_ADMIN,
  NOUV_ADMIN.ID_REGION_ADMIN AS ID_REGION_NOUV_ADMIN,
    NOUV_ADMIN.LIB_REGION_ADMIN AS LIB_REGION_NOUV_ADMIN,
    NOUV_ADMIN.DATE_DEBUT_VALID_ADMIN AS DATE_DEBUT_VALID_NOUV_ADMIN,
    NOUV_ADMIN.DATE_FIN_VALID_ADMIN AS DATE_FIN_VALID_NOUV_ADMIN,
    NOUV_ADMIN.FICHIER_IMAGE_CARTE_REGADM AS FICHIER_IMG_NOUV_REG_ADMIN,
  dim_geographique_com.ID_REGION_COM,
    LIB_REGION_COM,
    DATE_DEBUT_VALID_COM ,
    DATE_FIN_VALID_COM ,
    FICHIER_IMAGE_CARTE_REGCOM
  FROM dim_magasin, dim_enseigne, dim_departement, dim_geographique_com, dim_geographique_admin ANC_ADMIN, dim_geographique_admin NOUV_ADMIN
  WHERE dim_magasin.ID_ENSEIGNE=dim_enseigne.ID_ENSEIGNE
  AND dim_departement.ID_DEPARTEMENT=dim_magasin.DEP
  AND dim_geographique_com.ID_REGION_COM=dim_departement.ID_REGION_COM
  AND ANC_ADMIN.ID_REGION_ADMIN=ID_REGION_ADMIN1
  AND NOUV_ADMIN.ID_REGION_ADMIN=ID_REGION_ADMIN2
  ;


ALTER TABLE dim_magasin_star ADD CONSTRAINT PK_dim_magasin_star PRIMARY KEY (ID_MAGASIN);

/*
-- CREATE TABLE AS reprend les commentaires des tables interrogees
   COMMENT ON COLUMN "dim_magasin_star"...*/


DROP TABLE IF EXISTS faits_ventes_star CASCADE;

CREATE TABLE faits_ventes_star ENGINE=InnoDB DEFAULT CHARACTER SET = utf8 COMMENT = 'Fait ventes (etoile)' AS
SELECT * FROM faits_ventes;

/*
-- CREATE TABLE AS reprend les commentaires des tables interrogees
   COMMENT ON COLUMN "faits_ventes_star"...;
*/

--  CREATE UNIQUE INDEX "PK_faits_ventes_star" ON "faits_ventes_star" ("ID_MAGASIN", "ID_FAMILLE_PRODUIT", "ID_TEMPS")  ;


ALTER TABLE faits_ventes_star ADD CONSTRAINT PK_faits_ventes_star PRIMARY KEY (ID_MAGASIN, ID_FAMILLE_PRODUIT, ID_TEMPS);


ALTER TABLE faits_ventes_star ADD CONSTRAINT FK_faits_ventes_SR_DIM_FAMILLE FOREIGN KEY (ID_FAMILLE_PRODUIT)
      REFERENCES dim_famille_produit (ID_FAMILLE_PRODUIT);
/*ALTER TABLE faits_ventes_star ADD CONSTRAINT FK_faits_ventes_SR_dim_magasin FOREIGN KEY (ID_MAGASIN)
      REFERENCES dim_magasin_star (ID_MAGASIN);*/
ALTER TABLE faits_ventes_star ADD CONSTRAINT FK_faits_ventes_star_DIM_TEMPS FOREIGN KEY (ID_TEMPS)
      REFERENCES DIM_TEMPS (ID_TEMPS);


DROP TABLE IF EXISTS securite_star CASCADE ;

CREATE TABLE securite_star ENGINE=InnoDB DEFAULT CHARACTER SET = utf8 COMMENT = 'Visibilite en fonction du profil (etoile)' AS
SELECT * FROM securite;

ALTER TABLE securite_star ADD CONSTRAINT PK_securite_star PRIMARY KEY (ID_PROFIL, ID_MAGASIN, ONGLET) ;

/*
-- CREATE TABLE AS reprend les commentaires des tables interrogees

   COMMENT ON COLUMN "securite_star"...;
*/


CREATE INDEX `fk_securite_star_dim_magasin1` ON securite_star (`ID_MAGASIN` ASC);


ALTER TABLE securite_star ADD CONSTRAINT securite_star_PROFIL_FK FOREIGN KEY (ID_PROFIL)
      REFERENCES PROFIL (ID_PROFIL);




DELIMITER |
CREATE PROCEDURE maj_dim_magasin_star()
BEGIN
  /*ALTER TABLE faits_ventes_star DROP FOREIGN KEY FK_faits_ventes_SR_dim_magasin;*/
	TRUNCATE dim_magasin_star;
    INSERT INTO dim_magasin_star
    SELECT DISTINCT ID_MAGASIN,
    ACTIF,
    DATE_OUVERTURE ,
    DATE_FERMETURE ,
    DATE_MAJ ,
    EMPLACEMENTS ,
    NB_CAISSES ,
    VILLE ,
    FICHIER_IMAGE_CARTE_MAGASIN ,
  dim_enseigne.ID_ENSEIGNE,
  LIB_ENSEIGNE,
    FICHIER_IMAGE_LOGO_ENSEIGNE,
  ID_DEPARTEMENT,
    CODE_DEPARTEMENT,
    LIB_DEPARTEMENT ,
    ANC_ADMIN.ID_REGION_ADMIN AS ID_REGION_ANC_ADMIN,
    ANC_ADMIN.LIB_REGION_ADMIN AS LIB_REGION_ANC_ADMIN,
    ANC_ADMIN.DATE_DEBUT_VALID_ADMIN AS DATE_DEBUT_VALID_ANC_ADMIN,
    ANC_ADMIN.DATE_FIN_VALID_ADMIN AS DATE_FIN_VALID_ANC_ADMIN,
    ANC_ADMIN.FICHIER_IMAGE_CARTE_REGADM AS FICHIER_IMG_ANC_REG_ADMIN,
  NOUV_ADMIN.ID_REGION_ADMIN AS ID_REGION_NOUV_ADMIN,
    NOUV_ADMIN.LIB_REGION_ADMIN AS LIB_REGION_NOUV_ADMIN,
    NOUV_ADMIN.DATE_DEBUT_VALID_ADMIN AS DATE_DEBUT_VALID_NOUV_ADMIN,
    NOUV_ADMIN.DATE_FIN_VALID_ADMIN AS DATE_FIN_VALID_NOUV_ADMIN,
    NOUV_ADMIN.FICHIER_IMAGE_CARTE_REGADM AS FICHIER_IMG_NOUV_REG_ADMIN,
  dim_geographique_com.ID_REGION_COM,
    LIB_REGION_COM,
    DATE_DEBUT_VALID_COM ,
    DATE_FIN_VALID_COM ,
    FICHIER_IMAGE_CARTE_REGCOM
  FROM dim_magasin, dim_enseigne, dim_departement, dim_geographique_com, dim_geographique_admin ANC_ADMIN, dim_geographique_admin NOUV_ADMIN
  WHERE dim_magasin.ID_ENSEIGNE=dim_enseigne.ID_ENSEIGNE
  AND dim_departement.ID_DEPARTEMENT=dim_magasin.DEP
  AND dim_geographique_com.ID_REGION_COM=dim_departement.ID_REGION_COM
  AND ANC_ADMIN.ID_REGION_ADMIN=ID_REGION_ADMIN1
  AND NOUV_ADMIN.ID_REGION_ADMIN=ID_REGION_ADMIN2
  ;
END |
CREATE PROCEDURE maj_faits_ventes_star()
BEGIN
    TRUNCATE faits_ventes_star;
    INSERT INTO faits_ventes_star
    SELECT * FROM faits_ventes;
END |
CREATE PROCEDURE maj_securite_star()
BEGIN
    TRUNCATE securite_star;

    INSERT INTO securite_star
    SELECT * FROM securite;
END |
DELIMITER ;

CALL maj_dim_magasin_star();
CALL maj_faits_ventes_star();
CALL maj_securite_star();

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

--
-- Contenu des tables
--

INSERT INTO `devise` (`ID_DEVISE`, `LIB_DEVISE`, `ISOCODE`, `SYMBOLE`, `FORMAT_BO`, `COURS_FIXE`, `DATEMAJ_DEVISE`) VALUES
(1, 'Euro', 'EUR', '€', NULL, 1.00, '2016-03-25 10:20:53'),
(2, 'dollar', 'USD', '$', NULL, NULL, '2016-03-25 10:20:53'),
(3, 'yen', 'JPY', '¥', NULL, NULL, '2016-03-25 10:20:53');

Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','1','2014','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','1','2015','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','1','2016','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','2','2013','1.51','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','2','2014','1.51','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','2','2015','1.51','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','3','2013','1.5','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','3','2014','1.5','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','3','2015','1.5','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','4','2013','1.49','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','4','2014','1.49','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','4','2015','1.49','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','5','2013','1.48','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','5','2014','1.48','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','5','2015','1.48','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','6','2013','1.47','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','6','2014','1.47','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','6','2015','1.47','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','7','2013','1.46','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','7','2014','1.46','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','7','2015','1.46','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','8','2013','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','8','2014','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','8','2015','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','9','2013','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','9','2014','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','9','2015','1.45','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','10','2013','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','10','2014','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','10','2015','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','11','2013','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','11','2014','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','11','2015','1.44','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','12','2013','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','12','2014','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('2','12','2015','1.43','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','1','2014','1.63','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','1','2015','1.63','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','1','2016','1.63','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','2','2013','1.7','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','2','2014','1.7','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','2','2015','1.7','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','3','2013','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','3','2014','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','3','2015','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','4','2013','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','4','2014','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','4','2015','1.69','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','5','2013','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','5','2014','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','5','2015','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','6','2013','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','6','2014','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','6','2015','1.68','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','7','2013','1.67','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','7','2014','1.67','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','7','2015','1.67','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','8','2013','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','8','2014','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','8','2015','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','9','2013','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','9','2014','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','9','2015','1.66','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','10','2013','1.65','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','10','2014','1.65','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','10','2015','1.65','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','11','2013','1.64','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','11','2014','1.64','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','11','2015','1.64','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','12','2013','1.64','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','12','2014','1.64','25/03/16');
Insert into cours (ID_DEVISE,MOIS,ANNEE,cours,DATEMAJ_cours) values ('3','12','2015','1.64','25/03/16');

INSERT INTO `dim_enseigne` (`ID_ENSEIGNE`, `LIB_ENSEIGNE`, `FICHIER_IMAGE_LOGO_ENSEIGNE`, `DATEMAJ_ENSEIGNE`) VALUES
(1, 'Boulanger', 'boulanger', '2016-03-25 10:24:15'),
(2, 'Darty', 'darty', '2016-03-25 10:24:15'),
(3, 'Leroy_merlin', 'leroy_merlin', '2016-03-25 10:24:15');

INSERT INTO `dim_famille_produit` (`ID_FAMILLE_PRODUIT`, `LIB_FAMILLE_PRODUIT`, `DATEMAJ_FAMPROD`) VALUES
(1, 'Four', '2016-03-25 10:24:15'),
(2, 'Hifi', '2016-03-25 10:24:15'),
(3, 'Magnetoscope', '2016-03-25 10:24:15');

INSERT INTO `dim_geographique_admin` (`ID_REGION_ADMIN`, `LIB_REGION_ADMIN`, `DATE_FIN_VALID_ADMIN`, `FICHIER_IMAGE_CARTE_REGADM`, `DATEMAJ_GEO_ADMIN`) VALUES
(1, 'Alsace', NULL, 'alsace', '2016-03-25 10:20:53'),
(2, 'Aquitaine', NULL, 'aquitaine', '2016-03-25 10:20:53'),
(3, 'Auvergne', NULL, 'auvergne', '2016-03-25 10:20:53'),
(4, 'Basse-Normandie', NULL, 'basse-normandie', '2016-03-25 10:20:53'),
(5, 'Bourgogne', NULL, 'bourgogne', '2016-03-25 10:20:53'),
(6, 'Bretagne', NULL, 'bretagne', '2016-03-25 10:20:53'),
(7, 'Centre', NULL, 'centre', '2016-03-25 10:20:53'),
(8, 'Champagne-Ardenne', NULL, 'champagne-ardenne', '2016-03-25 10:20:53'),
(9, 'Corse', NULL, 'corse', '2016-03-25 10:20:53'),
(10, 'Franche-Comté', NULL, 'franche-comte', '2016-03-25 10:20:53'),
(11, 'Haute-Normandie', NULL, 'haute-normandie', '2016-03-25 10:20:53'),
(12, 'Île-de-France', NULL, 'ile-de-france', '2016-03-25 10:20:53'),
(13, 'Languedoc-Roussillon', NULL, 'languedoc-roussillon', '2016-03-25 10:20:53'),
(14, 'Limousin', NULL, 'limousin', '2016-03-25 10:20:53'),
(15, 'Lorraine', NULL, 'lorraine', '2016-03-25 10:20:53'),
(16, 'Midi-Pyrénées', NULL, 'midi-pyrenees', '2016-03-25 10:20:53'),
(17, 'Nord-Pas-de-Calais', NULL, 'nord-pas-de-calais', '2016-03-25 10:20:53'),
(18, 'Pays-de-la-loire', NULL, 'pays-de-la-loire', '2016-03-25 10:20:53'),
(19, 'Picardie', NULL, 'picardie', '2016-03-25 10:20:53'),
(20, 'Poitou-Charentes', NULL, 'poitou-charentes', '2016-03-25 10:20:53'),
(21, 'Provence-Alpes-Côte d\'Azur', NULL, 'provence-alpes-cote d\'azur', '2016-03-25 10:20:53'),
(22, 'Rhône-Alpes', NULL, 'rhone-alpes', '2016-03-25 10:20:53'),
(23, 'Alsace-Champagne-Ardenne-Lorraine', NULL, 'alsace-champagne-ardenne-lorraine', '2016-03-25 10:20:53'),
(24, 'Aquitaine-Limousin-Poitou-Charentes', NULL, 'aquitaine-limousin-poitou-charentes', '2016-03-25 10:20:53'),
(25, 'Auvergne-Rhônes-Alpes', NULL, 'auvergne-rhones-alpes', '2016-03-25 10:20:53'),
(26, 'Normandie', NULL, 'normandie', '2016-03-25 10:20:53'),
(27, 'Bourgogne-Franche-Comté', NULL, 'bourgogne-franche-comte', '2016-03-25 10:20:53'),
(29, 'Languedoc-Roussillon-Midi-Pyrénées', NULL, 'languedoc-roussillon-midi-pyrenees', '2016-03-25 10:20:53'),
(30, 'Nord-Pas-de-Calais-Picardie', NULL, 'nord-pas-de-calais-picardie', '2016-03-25 10:20:53');

INSERT INTO `dim_geographique_com` (`ID_REGION_COM`, `LIB_REGION_COM`, `DATE_FIN_VALID_COM`, `FICHIER_IMAGE_CARTE_REGCOM`, `DATEMAJ_GEO_COM`) VALUES
(1, 'Nord_Ouest', NULL, 'nord_ouest', '2016-03-25 10:20:53'),
(2, 'Nord_Est', NULL, 'nord_est', '2016-03-25 10:20:53'),
(3, 'Sud_Ouest', NULL, 'sud_ouest', '2016-03-25 10:20:53'),
(4, 'Sud_Est', NULL, 'sud_est', '2016-03-25 10:20:53'),
(5, 'Région_parisienne', NULL, 'region_parisienne', '2016-03-25 10:20:53');

INSERT INTO `dim_magasin` (`ID_MAGASIN`, `ID_ENSEIGNE`, `ACTIF`, `DATE_FERMETURE`, `DATE_MAJ`, `EMPLACEMENTS`, `NB_CAISSES`, `VILLE`, `DEP`, `FICHIER_IMAGE_CARTE_MAGASIN`) VALUES
(1, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Alencon', 32, 'alencon'),
(2, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 14, 'Amiens', 33, 'amiens'),
(3, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 13, 'Angers', 34, 'angers'),
(4, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Angouleme', 24, 'angouleme'),
(5, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Arras', 10, 'arras'),
(6, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Bastia', 35, 'bastia'),
(7, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Besancon', 1, 'besancon'),
(8, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Bobigny', 25, 'bobigny'),
(9, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Bordeaux', 5, 'bordeaux'),
(10, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 15, 'Bourges', 21, 'bourges'),
(11, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Carcassonne', 36, 'carcassonne'),
(12, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Cergy', 26, 'cergy'),
(13, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Chambery', 17, 'chambery'),
(14, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Clermont-Ferrand', 37, 'clermont-ferrand'),
(15, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 14, 'Creteil', 38, 'creteil'),
(16, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Digne', 11, 'digne'),
(17, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 13, 'Dijon', 39, 'dijon'),
(18, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Evry', 40, 'evry'),
(19, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 14, 'Foix', 12, 'foix'),
(20, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Grenoble', 13, 'grenoble'),
(21, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Lille', 41, 'lille'),
(22, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Limoges', 14, 'limoges'),
(23, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 15, 'Lyon', 45, 'lyon'),
(24, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Marseille', 46, 'marseille'),
(25, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Melun', 6, 'melun'),
(26, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 13, 'Metz', 2, 'metz'),
(27, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Nancy', 42, 'nancy'),
(28, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Nanterre', 18, 'nanterre'),
(29, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Nantes', 7, 'nantes'),
(30, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Nice', 19, 'nice'),
(31, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Nimes', 3, 'nimes'),
(32, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 13, 'Paris-Sud', 43, 'paris-sud'),
(33, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Paris-Nord', 43, 'paris-nord'),
(34, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Pau', 20, 'pau'),
(35, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 13, 'Perigueux', 15, 'perigueux'),
(36, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Quimper', 27, 'quimper'),
(37, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Rodez', 4, 'rodez'),
(38, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Rouen', 8, 'rouen'),
(39, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Saint-Brieuc', 16, 'saint-brieuc'),
(40, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Saint-Etienne', 22, 'saint-etienne'),
(41, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Strasbourg', 44, 'strasbourg'),
(42, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Tarbes', 23, 'tarbes'),
(43, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Toulon', 28, 'toulon'),
(44, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 15, 'Tours', 29, 'tours'),
(45, 2, 'Oui', NULL, '2016-03-25 10:20:53', 'Centre_Ville', 16, 'Troyes', 30, 'troyes'),
(46, 3, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Valence', 9, 'valence'),
(47, 1, 'Oui', NULL, '2016-03-25 10:20:53', 'ZAC', 16, 'Valenciennes', 41, 'valenciennes');
INSERT INTO `dim_magasin` (`ID_MAGASIN`, `ID_ENSEIGNE`, `ACTIF`, `DATE_OUVERTURE`, `DATE_FERMETURE`, `DATE_MAJ`, `EMPLACEMENTS`, `NB_CAISSES`, `VILLE`, `DEP`, `FICHIER_IMAGE_CARTE_MAGASIN`) VALUES
(48, 2, 'Oui', '1999-12-31 23:00:00', '1999-12-31 23:00:00', '2016-03-25 10:24:15', 'ZAC', 18, 'Versailles', 31, 'versailles'),
(49, 2, 'Oui', '1999-12-31 23:00:00', '1999-12-31 23:00:00', '2016-03-25 10:23:35', 'ZAC', 14, 'Bonnetable', 31, 'bonnetable');

INSERT INTO `dim_temps` (`ID_TEMPS`, `MOIS`, `LIB_MOIS`, `TRIMESTRE`, `SEMESTRE`, `ANNEE`) VALUES
('201101', 1, 'janvier', 1, 1, 2011),
('201102', 2, 'février', 1, 1, 2011),
('201103', 3, 'mars', 1, 1, 2011),
('201104', 4, 'avril', 2, 1, 2011),
('201105', 5, 'mai', 2, 1, 2011),
('201106', 6, 'juin', 2, 1, 2011),
('201107', 7, 'juillet', 3, 2, 2011),
('201108', 8, 'août', 3, 2, 2011),
('201109', 9, 'septembre', 3, 2, 2011),
('201110', 10, 'octobre', 4, 2, 2011),
('201111', 11, 'novembre', 4, 2, 2011),
('201112', 12, 'décembre', 4, 2, 2011),
('201201', 1, 'janvier', 1, 1, 2012),
('201202', 2, 'février', 1, 1, 2012),
('201203', 3, 'mars', 1, 1, 2012),
('201204', 4, 'avril', 2, 1, 2012),
('201205', 5, 'mai', 2, 1, 2012),
('201206', 6, 'juin', 2, 1, 2012),
('201207', 7, 'juillet', 3, 2, 2012),
('201208', 8, 'août', 3, 2, 2012),
('201209', 9, 'septembre', 3, 2, 2012),
('201210', 10, 'octobre', 4, 2, 2012),
('201211', 11, 'novembre', 4, 2, 2012),
('201212', 12, 'décembre', 4, 2, 2012),
('201301', 1, 'janvier', 1, 1, 2013),
('201302', 2, 'février', 1, 1, 2013),
('201303', 3, 'mars', 1, 1, 2013),
('201304', 4, 'avril', 2, 1, 2013),
('201305', 5, 'mai', 2, 1, 2013),
('201306', 6, 'juin', 2, 1, 2013),
('201307', 7, 'juillet', 3, 2, 2013),
('201308', 8, 'août', 3, 2, 2013),
('201309', 9, 'septembre', 3, 2, 2013),
('201310', 10, 'octobre', 4, 2, 2013),
('201311', 11, 'novembre', 4, 2, 2013),
('201312', 12, 'décembre', 4, 2, 2013),
('201401', 1, 'janvier', 1, 1, 2014),
('201402', 2, 'février', 1, 1, 2014),
('201403', 3, 'mars', 1, 1, 2014),
('201404', 4, 'avril', 2, 1, 2014),
('201405', 5, 'mai', 2, 1, 2014),
('201406', 6, 'juin', 2, 1, 2014),
('201407', 7, 'juillet', 3, 2, 2014),
('201408', 8, 'août', 3, 2, 2014),
('201409', 9, 'septembre', 3, 2, 2014),
('201410', 10, 'octobre', 4, 2, 2014),
('201411', 11, 'novembre', 4, 2, 2014),
('201412', 12, 'décembre', 4, 2, 2014),
('201501', 1, 'janvier', 1, 1, 2015),
('201502', 2, 'février', 1, 1, 2015),
('201503', 3, 'mars', 1, 1, 2015),
('201504', 4, 'avril', 2, 1, 2015),
('201505', 5, 'mai', 2, 1, 2015),
('201506', 6, 'juin', 2, 1, 2015),
('201507', 7, 'juillet', 3, 2, 2015),
('201508', 8, 'août', 3, 2, 2015),
('201509', 9, 'septembre', 3, 2, 2015),
('201510', 10, 'octobre', 4, 2, 2015),
('201511', 11, 'novembre', 4, 2, 2015),
('201512', 12, 'décembre', 4, 2, 2015),
('201601', 1, 'janvier', 1, 1, 2016),
('201602', 2, 'février', 1, 1, 2016),
('201603', 3, 'mars', 1, 1, 2016),
('201604', 4, 'avril', 2, 1, 2016),
('201605', 5, 'mai', 2, 1, 2016),
('201606', 6, 'juin', 2, 1, 2016),
('201607', 7, 'juillet', 3, 2, 2016),
('201608', 8, 'août', 3, 2, 2016),
('201609', 9, 'septembre', 3, 2, 2016),
('201610', 10, 'octobre', 4, 2, 2016),
('201611', 11, 'novembre', 4, 2, 2016),
('201612', 12, 'décembre', 4, 2, 2016),
('201701', 1, 'janvier', 1, 1, 2017),
('201702', 2, 'février', 1, 1, 2017),
('201703', 3, 'mars', 1, 1, 2017),
('201704', 4, 'avril', 2, 1, 2017),
('201705', 5, 'mai', 2, 1, 2017),
('201706', 6, 'juin', 2, 1, 2017),
('201707', 7, 'juillet', 3, 2, 2017),
('201708', 8, 'août', 3, 2, 2017),
('201709', 9, 'septembre', 3, 2, 2017),
('201710', 10, 'octobre', 4, 2, 2017),
('201711', 11, 'novembre', 4, 2, 2017),
('201712', 12, 'décembre', 4, 2, 2017),
('201801', 1, 'janvier', 1, 1, 2018),
('201802', 2, 'février', 1, 1, 2018),
('201803', 3, 'mars', 1, 1, 2018),
('201804', 4, 'avril', 2, 1, 2018),
('201805', 5, 'mai', 2, 1, 2018),
('201806', 6, 'juin', 2, 1, 2018),
('201807', 7, 'juillet', 3, 2, 2018),
('201808', 8, 'août', 3, 2, 2018),
('201809', 9, 'septembre', 3, 2, 2018),
('201810', 10, 'octobre', 4, 2, 2018),
('201811', 11, 'novembre', 4, 2, 2018),
('201812', 12, 'décembre', 4, 2, 2018);

INSERT INTO `france_departements` (`CODE_DEPT`, `LIB_DEPARTEMENT`, `ID_REGION_ADMIN1`, `ID_REGION_ADMIN2`, `ID_REGION_COM`) VALUES
('01', 'Ain', 22, 25, 2),
('02', 'Aisne', 19, 30, 2),
('03', 'Allier', 3, 25, 2),
('04', 'Alpes-de-Haute-Provence', 21, 21, 4),
('05', 'Hautes-Alpes', 21, 21, 4),
('06', 'Alpes-Maritimes', 21, 21, 4),
('07', 'Ardèche', 22, 25, 4),
('08', 'Ardennes', 8, 23, 2),
('09', 'Ariège', 16, 29, 3),
('10', 'Aube', 8, 23, 2),
('11', 'Aude', 13, 29, 3),
('12', 'Aveyron', 16, 29, 3),
('13', 'Bouches-du-Rhône', 21, 21, 4),
('14', 'Calvados', 4, 26, 1),
('15', 'Cantal', 3, 25, 3),
('16', 'Charente', 20, 24, 3),
('17', 'Charente-Maritime', 20, 24, 3),
('18', 'Cher', 7, 7, 2),
('19', 'Corrèze', 14, 24, 3),
('21', 'Côte-d\'Or', 5, 27, 2),
('22', 'Côtes-d\'Armor', 6, 6, 1),
('23', 'Creuse', 14, 24, 3),
('24', 'Dordogne', 2, 24, 3),
('25', 'Doubs', 10, 27, 2),
('26', 'Drôme', 22, 25, 4),
('27', 'Eure', 11, 26, 1),
('28', 'Eure-et-Loir', 7, 7, 1),
('29', 'Finistère', 6, 6, 1),
('2A', 'Haute-Corse', 9, 9, 4),
('2B', 'Corse-du-Sud', 9, 9, 4),
('30', 'Gard', 13, 29, 4),
('31', 'Haute-Garonne', 16, 29, 3),
('32', 'Gers', 16, 29, 3),
('33', 'Gironde', 2, 24, 3),
('34', 'Hérault', 13, 29, 4),
('35', 'Ille-et-Vilaine', 6, 6, 1),
('36', 'Indre', 7, 7, 1),
('37', 'Indre-et-Loire', 7, 7, 1),
('38', 'Isère', 22, 25, 4),
('39', 'Jura', 10, 27, 2),
('40', 'Landes', 2, 24, 3),
('41', 'Loir-et-Cher', 7, 7, 1),
('42', 'Loire', 22, 25, 4),
('43', 'Haute-Loire', 3, 25, 4),
('44', 'Loire-Atlantique', 18, 18, 1),
('45', 'Loiret', 7, 7, 1),
('46', 'Lot', 16, 29, 3),
('47', 'Lot-et-Garonne', 2, 24, 3),
('48', 'Lozère', 13, 29, 4),
('49', 'Maine-et-Loire', 18, 18, 1),
('50', 'Manche', 3, 3, 1),
('51', 'Marne', 8, 23, 2),
('52', 'Haute-Marne', 8, 23, 2),
('53', 'Mayenne', 18, 18, 1),
('54', 'Meurthe-et-Moselle', 15, 23, 2),
('55', 'Meuse', 15, 23, 2),
('56', 'Morbihan', 6, 6, 1),
('57', 'Moselle', 15, 23, 2),
('58', 'Nièvre', 5, 27, 2),
('59', 'Nord', 17, 30, 2),
('60', 'Oise', 19, 30, 2),
('61', 'Orne', 4, 26, 1),
('62', 'Pas-de-Calais', 17, 30, 2),
('63', 'Puy-de-Dôme', 3, 25, 4),
('64', 'Pyrénées-Atlantiques', 2, 24, 3),
('65', 'Hautes-Pyrénées', 16, 29, 3),
('66', 'Pyrénées-Orientales', 13, 29, 3),
('67', 'Bas-Rhin', 1, 23, 2),
('68', 'Haut-Rhin', 1, 23, 2),
('69', 'Rhône', 22, 25, 4),
('70', 'Haute-Saône', 10, 27, 2),
('71', 'Saône-et-Loire', 5, 27, 2),
('72', 'Sarthe', 18, 18, 1),
('73', 'Savoie', 22, 25, 4),
('74', 'Haute-Savoie', 22, 25, 4),
('75', 'Paris', 12, 12, 5),
('76', 'Seine-Maritime', 11, 26, 1),
('77', 'Seine-et-Marne', 12, 12, 5),
('78', 'Yvelines', 12, 12, 5),
('79', 'Deux-Sèvres', 20, 24, 3),
('80', 'Somme', 19, 30, 2),
('81', 'Tarn', 16, 29, 3),
('82', 'Tarn-et-Garonne', 16, 29, 3),
('83', 'Var', 21, 21, 4),
('84', 'Vaucluse', 21, 21, 4),
('85', 'Vendée', 18, 18, 1),
('86', 'Vienne', 20, 24, 3),
('87', 'Haute-Vienne', 14, 24, 3),
('88', 'Vosges', 15, 23, 2),
('89', 'Yonne', 5, 27, 2),
('91', 'Essonne', 12, 12, 5),
('92', 'Hauts-de-Seine', 12, 12, 5),
('93', 'Seine-St-Denis', 12, 12, 5),
('94', 'Val-de-Marne', 12, 12, 5),
('95', 'Val-d\'Oise', 12, 12, 5);

Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('1','25','Doubs','10','27','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('2','57','Moselle','15','23','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('3','30','Gard','13','29','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('4','12','Aveyron','16','29','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('5','33','Gironde','2','24','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('6','77','Seine-et-Marne','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('7','44','Loire-Atlantique','18','18','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('8','76','Seine-Maritime','11','26','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('9','26','Drôme','22','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('10','62','Pas-de-Calais','17','30','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('11','04','Alpes-de-Haute-Provence','21','21','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('12','09','Ariège','16','29','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('13','38','Isère','22','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('14','87','Haute-Vienne','14','24','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('15','24','Dordogne','2','24','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('16','22','Côtes-d''Armor','6','6','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('17','73','Savoie','22','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('18','92','Hauts-de-Seine','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('19','06','Alpes-Maritimes','21','21','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('20','64','Pyrénées-Atlantiques','6','24','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('21','18','Cher','7','7','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('22','42','Loire','22','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('23','65','Hautes-Pyrénées','16','29','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('24','16','Charente','20','24','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('25','93','Seine-St-Denis','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('26','95','Val-d''Oise','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('27','29','Finistère','6','6','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('28','83','Var','21','21','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('29','37','Indre-et-Loire','7','7','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('30','10','Aube','8','23','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('31','78','Yvelines','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('32','61','Orne','4','26','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('33','80','Somme','19','30','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('34','49','Maine-et-Loire','18','18','1','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('35','2B','Corse-du-Sud','9','9','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('36','11','Aude','13','29','3','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('37','63','Puy-de-D�me','3','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('38','94','Val-de-Marne','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('39','21','Côte-d''Or','5','27','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('40','91','Essonne','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('41','59','Nord','17','30','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('42','54','Meurthe-et-Moselle','15','23','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('43','75','Paris','12','12','5','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('44','67','Bas-Rhin','1','23','2','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('45','69','Rhône','22','25','4','25/03/16');
Insert into dim_departement (ID_DEPARTEMENT,CODE_DEPARTEMENT,LIB_DEPARTEMENT,ID_REGION_ADMIN1,ID_REGION_ADMIN2,ID_REGION_COM,DATEMAJ_DEP) values ('46','13','Bouches-du-Rhône','21','21','4','25/03/16');

INSERT INTO `profil` (`ID_PROFIL`, `LIB_PROFIL`, `TYPE_ZONE`, `ID_ZONE`, `USERNAME_BO`, `PASSWORD_BO`, `DATEMAJ_PROFIL`) VALUES
(1, 'Administrateur', NULL, NULL, 'etudiant01', 'P@ssw0rd', '2016-03-25 10:20:54'),
(2, 'Directeur commercial', 3, NULL, 'etudiant02', 'P@ssw0rd', '2016-03-25 10:20:54'),
(3, 'Directeur Alencon', 2, 1, 'etudiant08', 'P@ssw0rd', '2016-03-25 10:20:54'),
(4, 'Directeur Amiens', 2, 2, 'etudiant09', 'P@ssw0rd', '2016-03-25 10:20:54'),
(5, 'Directeur Angers', 2, 3, 'etudiant10', 'P@ssw0rd', '2016-03-25 10:20:54'),
(6, 'Directeur Angouleme', 2, 4, 'etudiant11', 'P@ssw0rd', '2016-03-25 10:20:54'),
(7, 'Directeur Arras', 2, 5, 'etudiant12', 'P@ssw0rd', '2016-03-25 10:20:54'),
(8, 'Directeur Bastia', 2, 6, 'etudiant13', 'P@ssw0rd', '2016-03-25 10:20:54'),
(9, 'Directeur Besancon', 2, 7, 'etudiant14', 'P@ssw0rd', '2016-03-25 10:20:54'),
(10, 'Directeur Bobigny', 2, 8, 'etudiant15', 'P@ssw0rd', '2016-03-25 10:20:54'),
(11, 'Directeur Bordeaux', 2, 9, 'etudiant16', 'P@ssw0rd', '2016-03-25 10:20:54'),
(12, 'Directeur Bourges', 2, 10, 'etudiant17', 'P@ssw0rd', '2016-03-25 10:20:54'),
(13, 'Directeur Carcassonne', 2, 11, 'etudiant18', 'P@ssw0rd', '2016-03-25 10:20:54'),
(14, 'Directeur Cergy', 2, 12, 'etudiant19', 'P@ssw0rd', '2016-03-25 10:20:54'),
(15, 'Directeur Chambery', 2, 13, 'etudiant20', 'P@ssw0rd', '2016-03-25 10:20:54'),
(16, 'Directeur Clermont-Ferrand', 2, 14, 'etudiant21', 'P@ssw0rd', '2016-03-25 10:20:54'),
(17, 'Directeur Creteil', 2, 15, 'etudiant22', 'P@ssw0rd', '2016-03-25 10:20:54'),
(18, 'Directeur Digne', 2, 16, 'etudiant23', 'P@ssw0rd', '2016-03-25 10:20:54'),
(19, 'Directeur Dijon', 2, 17, 'etudiant24', 'P@ssw0rd', '2016-03-25 10:20:54'),
(20, 'Directeur Evry', 2, 18, 'etudiant25', 'P@ssw0rd', '2016-03-25 10:20:54'),
(21, 'Directeur Foix', 2, 19, 'etudiant26', 'P@ssw0rd', '2016-03-25 10:20:54'),
(22, 'Directeur Grenoble', 2, 20, 'etudiant27', 'P@ssw0rd', '2016-03-25 10:20:54'),
(23, 'Directeur Lille', 2, 21, 'etudiant28', 'P@ssw0rd', '2016-03-25 10:20:54'),
(24, 'Directeur Limoges', 2, 22, 'etudiant29', 'P@ssw0rd', '2016-03-25 10:20:54'),
(25, 'Directeur Lyon', 2, 23, 'etudiant30', 'P@ssw0rd', '2016-03-25 10:20:54'),
(26, 'Directeur Marseille', 2, 24, 'etudiant31', 'P@ssw0rd', '2016-03-25 10:20:54'),
(27, 'Directeur Melun', 2, 25, 'etudiant32', 'P@ssw0rd', '2016-03-25 10:20:54'),
(28, 'Directeur Metz', 2, 26, 'etudiant33', 'P@ssw0rd', '2016-03-25 10:20:54'),
(29, 'Directeur Nancy', 2, 27, 'etudiant34', 'P@ssw0rd', '2016-03-25 10:20:54'),
(30, 'Directeur Nanterre', 2, 28, 'etudiant35', 'P@ssw0rd', '2016-03-25 10:20:54'),
(31, 'Directeur Nantes', 2, 29, 'etudiant36', 'P@ssw0rd', '2016-03-25 10:20:54'),
(32, 'Directeur Nice', 2, 30, 'etudiant37', 'P@ssw0rd', '2016-03-25 10:20:54'),
(33, 'Directeur Nimes', 2, 31, 'etudiant38', 'P@ssw0rd', '2016-03-25 10:20:54'),
(34, 'Directeur Nord_Est', 1, 2, 'etudiant04', 'P@ssw0rd', '2016-03-25 10:20:54'),
(35, 'Directeur Nord_Ouest', 1, 1, 'etudiant03', 'P@ssw0rd', '2016-03-25 10:20:54'),
(36, 'Directeur Paris-Sud', 2, 32, 'etudiant39', 'P@ssw0rd', '2016-03-25 10:20:54'),
(37, 'Directeur Paris-Nord', 2, 33, 'etudiant40', 'P@ssw0rd', '2016-03-25 10:20:54'),
(38, 'Directeur Pau', 2, 34, 'etudiant41', 'P@ssw0rd', '2016-03-25 10:20:54'),
(39, 'Directeur Perigueux', 2, 35, 'etudiant42', 'P@ssw0rd', '2016-03-25 10:20:54'),
(40, 'Directeur Quimper', 2, 36, 'etudiant43', 'P@ssw0rd', '2016-03-25 10:20:54'),
(41, 'Directeur Rodez', 2, 37, 'etudiant44', 'P@ssw0rd', '2016-03-25 10:20:54'),
(42, 'Directeur Rouen', 2, 38, 'etudiant45', 'P@ssw0rd', '2016-03-25 10:20:54'),
(43, 'Directeur Region_parisienne', 1, 5, 'etudiant07', 'P@ssw0rd', '2016-03-25 10:20:54'),
(44, 'Directeur Saint-Brieuc', 2, 39, 'etudiant46', 'P@ssw0rd', '2016-03-25 10:20:54'),
(45, 'Directeur Saint-Etienne', 2, 40, 'etudiant47', 'P@ssw0rd', '2016-03-25 10:20:54'),
(46, 'Directeur Strasbourg', 2, 41, 'etudiant48', 'P@ssw0rd', '2016-03-25 10:20:54'),
(47, 'Directeur Sud_Est', 1, 4, 'etudiant06', 'P@ssw0rd', '2016-03-25 10:20:54'),
(48, 'Directeur Sud_Ouest', 1, 3, 'etudiant05', 'P@ssw0rd', '2016-03-25 10:20:54'),
(49, 'Directeur Tarbes', 2, 42, 'etudiant49', 'P@ssw0rd', '2016-03-25 10:20:54'),
(50, 'Directeur Toulon', 2, 43, 'etudiant50', 'P@ssw0rd', '2016-03-25 10:20:54'),
(51, 'Directeur Tours', 2, 44, 'etudiant51', 'P@ssw0rd', '2016-03-25 10:20:54'),
(52, 'Directeur Troyes', 2, 45, 'etudiant52', 'P@ssw0rd', '2016-03-25 10:20:54'),
(53, 'Directeur Valence', 2, 46, 'etudiant53', 'P@ssw0rd', '2016-03-25 10:20:54'),
(54, 'Directeur Valenciennes', 2, 47, 'etudiant54', 'P@ssw0rd', '2016-03-25 10:20:54'),
(55, 'Directeur Versailles', 2, 48, 'etudiant55', 'P@ssw0rd', '2016-03-25 10:20:54');
(56, 'Profil temporaire', 2, 49, 'etudiant55', 'P@ssw0rd', '2016-03-25 10:20:54');

INSERT INTO `securite` (`ID_MAGASIN`, `ID_PROFIL`, `ONGLET`, `DATEMAJ_SECURITE`) VALUES
(1, 1, 1, '2016-03-25 10:20:54'),
(1, 2, 1, '2016-03-25 10:20:54'),
(1, 3, 1, '2016-03-25 10:20:54'),
(1, 35, 1, '2016-03-25 10:20:54'),
(2, 1, 1, '2016-03-25 10:20:54'),
(2, 2, 1, '2016-03-25 10:20:54'),
(2, 4, 1, '2016-03-25 10:20:54'),
(2, 35, 1, '2016-03-25 10:20:54'),
(3, 1, 1, '2016-03-25 10:20:54'),
(3, 2, 1, '2016-03-25 10:20:54'),
(3, 5, 1, '2016-03-25 10:20:54'),
(3, 35, 1, '2016-03-25 10:20:54'),
(4, 1, 1, '2016-03-25 10:20:54'),
(4, 2, 1, '2016-03-25 10:20:54'),
(4, 6, 1, '2016-03-25 10:20:54'),
(4, 48, 1, '2016-03-25 10:20:54'),
(5, 1, 1, '2016-03-25 10:20:54'),
(5, 2, 1, '2016-03-25 10:20:54'),
(5, 7, 1, '2016-03-25 10:20:54'),
(5, 34, 1, '2016-03-25 10:20:54'),
(6, 1, 1, '2016-03-25 10:20:54'),
(6, 2, 1, '2016-03-25 10:20:54'),
(6, 8, 1, '2016-03-25 10:20:54'),
(6, 47, 1, '2016-03-25 10:20:54'),
(7, 1, 1, '2016-03-25 10:20:54'),
(7, 2, 1, '2016-03-25 10:20:54'),
(7, 9, 1, '2016-03-25 10:20:54'),
(7, 34, 1, '2016-03-25 10:20:54'),
(8, 1, 1, '2016-03-25 10:20:54'),
(8, 2, 1, '2016-03-25 10:20:54'),
(8, 10, 1, '2016-03-25 10:20:54'),
(8, 43, 1, '2016-03-25 10:20:54'),
(9, 1, 1, '2016-03-25 10:20:54'),
(9, 2, 1, '2016-03-25 10:20:54'),
(9, 11, 1, '2016-03-25 10:20:54'),
(9, 48, 1, '2016-03-25 10:20:54'),
(10, 1, 1, '2016-03-25 10:20:54'),
(10, 2, 1, '2016-03-25 10:20:54'),
(10, 12, 1, '2016-03-25 10:20:54'),
(10, 47, 1, '2016-03-25 10:20:54'),
(11, 1, 1, '2016-03-25 10:20:54'),
(11, 2, 1, '2016-03-25 10:20:54'),
(11, 13, 1, '2016-03-25 10:20:54'),
(11, 48, 1, '2016-03-25 10:20:54'),
(12, 1, 1, '2016-03-25 10:20:54'),
(12, 2, 1, '2016-03-25 10:20:54'),
(12, 14, 1, '2016-03-25 10:20:54'),
(12, 43, 1, '2016-03-25 10:20:54'),
(13, 1, 1, '2016-03-25 10:20:54'),
(13, 2, 1, '2016-03-25 10:20:54'),
(13, 15, 1, '2016-03-25 10:20:54'),
(13, 47, 1, '2016-03-25 10:20:54'),
(14, 1, 1, '2016-03-25 10:20:54'),
(14, 2, 1, '2016-03-25 10:20:54'),
(14, 16, 1, '2016-03-25 10:20:54'),
(14, 47, 1, '2016-03-25 10:20:54'),
(15, 1, 1, '2016-03-25 10:20:54'),
(15, 2, 1, '2016-03-25 10:20:54'),
(15, 17, 1, '2016-03-25 10:20:54'),
(15, 43, 1, '2016-03-25 10:20:54'),
(16, 1, 1, '2016-03-25 10:20:54'),
(16, 2, 1, '2016-03-25 10:20:54'),
(16, 18, 1, '2016-03-25 10:20:54'),
(16, 47, 1, '2016-03-25 10:20:54'),
(17, 1, 1, '2016-03-25 10:20:54'),
(17, 2, 1, '2016-03-25 10:20:54'),
(17, 19, 1, '2016-03-25 10:20:54'),
(17, 34, 1, '2016-03-25 10:20:54'),
(18, 1, 1, '2016-03-25 10:20:54'),
(18, 2, 1, '2016-03-25 10:20:54'),
(18, 20, 1, '2016-03-25 10:20:54'),
(18, 43, 1, '2016-03-25 10:20:54'),
(19, 1, 1, '2016-03-25 10:20:54'),
(19, 2, 1, '2016-03-25 10:20:54'),
(19, 21, 1, '2016-03-25 10:20:54'),
(19, 48, 1, '2016-03-25 10:20:54'),
(20, 1, 1, '2016-03-25 10:20:54'),
(20, 2, 1, '2016-03-25 10:20:54'),
(20, 22, 1, '2016-03-25 10:20:54'),
(20, 47, 1, '2016-03-25 10:20:54'),
(21, 1, 1, '2016-03-25 10:20:54'),
(21, 2, 1, '2016-03-25 10:20:54'),
(21, 23, 1, '2016-03-25 10:20:54'),
(21, 34, 1, '2016-03-25 10:20:54'),
(22, 1, 1, '2016-03-25 10:20:54'),
(22, 2, 1, '2016-03-25 10:20:54'),
(22, 24, 1, '2016-03-25 10:20:54'),
(22, 48, 1, '2016-03-25 10:20:54'),
(23, 1, 1, '2016-03-25 10:20:54'),
(23, 2, 1, '2016-03-25 10:20:54'),
(23, 25, 1, '2016-03-25 10:20:54'),
(23, 47, 1, '2016-03-25 10:20:54'),
(24, 1, 1, '2016-03-25 10:20:54'),
(24, 2, 1, '2016-03-25 10:20:54'),
(24, 26, 1, '2016-03-25 10:20:54'),
(24, 47, 1, '2016-03-25 10:20:54'),
(25, 1, 1, '2016-03-25 10:20:54'),
(25, 2, 1, '2016-03-25 10:20:54'),
(25, 27, 1, '2016-03-25 10:20:54'),
(25, 43, 1, '2016-03-25 10:20:54'),
(26, 1, 1, '2016-03-25 10:20:54'),
(26, 2, 1, '2016-03-25 10:20:54'),
(26, 28, 1, '2016-03-25 10:20:54'),
(26, 34, 1, '2016-03-25 10:20:54'),
(27, 1, 1, '2016-03-25 10:20:54'),
(27, 2, 1, '2016-03-25 10:20:54'),
(27, 29, 1, '2016-03-25 10:20:54'),
(27, 34, 1, '2016-03-25 10:20:54'),
(28, 1, 1, '2016-03-25 10:20:54'),
(28, 2, 1, '2016-03-25 10:20:54'),
(28, 30, 1, '2016-03-25 10:20:54'),
(28, 43, 1, '2016-03-25 10:20:54'),
(29, 1, 1, '2016-03-25 10:20:54'),
(29, 2, 1, '2016-03-25 10:20:54'),
(29, 31, 1, '2016-03-25 10:20:54'),
(29, 35, 1, '2016-03-25 10:20:54'),
(30, 1, 1, '2016-03-25 10:20:54'),
(30, 2, 1, '2016-03-25 10:20:54'),
(30, 32, 1, '2016-03-25 10:20:54'),
(30, 47, 1, '2016-03-25 10:20:54'),
(31, 1, 1, '2016-03-25 10:20:54'),
(31, 2, 1, '2016-03-25 10:20:54'),
(31, 33, 1, '2016-03-25 10:20:54'),
(31, 47, 1, '2016-03-25 10:20:54'),
(32, 1, 1, '2016-03-25 10:20:54'),
(32, 2, 1, '2016-03-25 10:20:54'),
(32, 36, 1, '2016-03-25 10:20:54'),
(32, 43, 1, '2016-03-25 10:20:54'),
(33, 1, 1, '2016-03-25 10:20:54'),
(33, 2, 1, '2016-03-25 10:20:54'),
(33, 37, 1, '2016-03-25 10:20:54'),
(33, 43, 1, '2016-03-25 10:20:54'),
(34, 1, 1, '2016-03-25 10:20:54'),
(34, 2, 1, '2016-03-25 10:20:54'),
(34, 38, 1, '2016-03-25 10:20:54'),
(34, 48, 1, '2016-03-25 10:20:54'),
(35, 1, 1, '2016-03-25 10:20:54'),
(35, 2, 1, '2016-03-25 10:20:54'),
(35, 39, 1, '2016-03-25 10:20:54'),
(35, 48, 1, '2016-03-25 10:20:54'),
(36, 1, 1, '2016-03-25 10:20:54'),
(36, 2, 1, '2016-03-25 10:20:54'),
(36, 35, 1, '2016-03-25 10:20:54'),
(36, 40, 1, '2016-03-25 10:20:54'),
(37, 1, 1, '2016-03-25 10:20:54'),
(37, 2, 1, '2016-03-25 10:20:54'),
(37, 41, 1, '2016-03-25 10:20:54'),
(37, 48, 1, '2016-03-25 10:20:54'),
(38, 1, 1, '2016-03-25 10:20:54'),
(38, 2, 1, '2016-03-25 10:20:54'),
(38, 35, 1, '2016-03-25 10:20:54'),
(38, 42, 1, '2016-03-25 10:20:54'),
(39, 1, 1, '2016-03-25 10:20:54'),
(39, 2, 1, '2016-03-25 10:20:54'),
(39, 35, 1, '2016-03-25 10:20:54'),
(39, 44, 1, '2016-03-25 10:20:54'),
(40, 1, 1, '2016-03-25 10:20:54'),
(40, 2, 1, '2016-03-25 10:20:54'),
(40, 45, 1, '2016-03-25 10:20:54'),
(40, 47, 1, '2016-03-25 10:20:54'),
(41, 1, 1, '2016-03-25 10:20:54'),
(41, 2, 1, '2016-03-25 10:20:54'),
(41, 34, 1, '2016-03-25 10:20:54'),
(41, 46, 1, '2016-03-25 10:20:54'),
(42, 1, 1, '2016-03-25 10:20:54'),
(42, 2, 1, '2016-03-25 10:20:54'),
(42, 48, 1, '2016-03-25 10:20:54'),
(42, 49, 1, '2016-03-25 10:20:54'),
(43, 1, 1, '2016-03-25 10:20:54'),
(43, 2, 1, '2016-03-25 10:20:54'),
(43, 48, 1, '2016-03-25 10:20:54'),
(43, 50, 1, '2016-03-25 10:20:54'),
(44, 1, 1, '2016-03-25 10:20:54'),
(44, 2, 1, '2016-03-25 10:20:54'),
(44, 35, 1, '2016-03-25 10:20:54'),
(44, 51, 1, '2016-03-25 10:20:54'),
(45, 1, 1, '2016-03-25 10:20:54'),
(45, 2, 1, '2016-03-25 10:20:54'),
(45, 34, 1, '2016-03-25 10:20:54'),
(45, 52, 1, '2016-03-25 10:20:54'),
(46, 1, 1, '2016-03-25 10:20:54'),
(46, 2, 1, '2016-03-25 10:20:54'),
(46, 47, 1, '2016-03-25 10:20:54'),
(46, 53, 1, '2016-03-25 10:20:54'),
(47, 1, 1, '2016-03-25 10:20:54'),
(47, 2, 1, '2016-03-25 10:20:54'),
(47, 34, 1, '2016-03-25 10:20:54'),
(47, 54, 1, '2016-03-25 10:20:54'),
(48, 1, 1, '2016-03-25 10:20:54'),
(48, 2, 1, '2016-03-25 10:20:54'),
(48, 43, 1, '2016-03-25 10:20:54'),
(48, 55, 1, '2016-03-25 10:20:54');

INSERT INTO `utilisateur` (`ID`, `NOM`, `PRENOM`, `USERNAME`, `PASSWORD`, `MAIL`, `ID_PROFIL`, `DATEMAJ_USER`) VALUES
(1, 'AUDIBERT', 'Javier', 'Javier.AUDIBERT', '4AfgG97', 'Javier.AUDIBERT@darties.com', 1, '2016-03-25 10:20:54'),
(2, 'DROUIN', 'Dominic', 'Dominic.DROUIN', 't2eJ76Z', 'Dominic.DROUIN@darties.com', 2, '2016-03-25 10:20:54'),
(3, 'ROUX', 'Angelique', 'Angelique.ROUX', '7u2Mx4W', 'Angelique.ROUX@darties.com', 3, '2016-03-25 10:20:54'),
(4, 'BOUTOT', 'Angelle', 'Angelle.BOUTOT', '9M2jyH3', 'Angelle.BOUTOT@darties.com', 4, '2016-03-25 10:20:54'),
(5, 'DESCOTEAUX', 'Huguette', 'Huguette.DESCOTEAUX', '33j7UvW', 'Huguette.DESCOTEAUX@darties.com', 5, '2016-03-25 10:20:54'),
(6, 'DUBEAU', 'Pascal', 'Pascal.DUBEAU', '59Cx6eX', 'Pascal.DUBEAU@darties.com', 6, '2016-03-25 10:20:54'),
(7, 'PAIMBOEUF', 'Laurent', 'Laurent.PAIMBOEUF', 'wX2J4a9', 'Laurent.PAIMBOEUF@darties.com', 7, '2016-03-25 10:20:54'),
(8, 'SAUCIER', 'Yves', 'Yves.SAUCIER', 'Un38y7C', 'Yves.SAUCIER@darties.com', 8, '2016-03-25 10:20:54'),
(9, 'GAUTHIER', 'Robert', 'Robert.GAUTHIER', 'F2Se72u', 'Robert.GAUTHIER@darties.com', 9, '2016-03-25 10:20:54'),
(10, 'BERNIER', 'Estelle', 'Estelle.BERNIER', 'CJ62hy9', 'Estelle.BERNIER@darties.com', 10, '2016-03-25 10:20:54'),
(11, 'VIENS', 'Aurore', 'Aurore.VIENS', 'E8X2yd7', 'Aurore.VIENS@darties.Com', 11, '2016-03-25 10:20:54'),
(12, 'GAGNEUX', 'Charles', 'Charles.GAGNEUX', 'Xd64cG9', 'Charles.GAGNEUX@darties.com', 12, '2016-03-25 10:20:54'),
(13, 'MELANSON', 'Gustave', 'Gustave.MELANSON', 'XZy67c6', 'Gustave.MELANSON@darties.com', 13, '2016-03-25 10:20:54'),
(14, 'SAVOIE', 'David', 'David.SAVOIE', 'W63yk8B', 'David.SAVOIE@darties.com', 14, '2016-03-25 10:20:54'),
(15, 'SAINDON', 'Edward', 'Edward.SAINDON', 'hr9F4X9', 'Edward.SAINDON@darties.com', 15, '2016-03-25 10:20:54'),
(16, 'BORDOUX', 'Isabelle', 'Isabelle.BORDOUX', '49Vn6zC', 'Isabelle.BORDOUX@darties.com', 16, '2016-03-25 10:20:54'),
(17, 'LACHARITE', 'Joanna', 'Joanna.LACHARITE', 'y7eN4V9', 'Joanna.LACHARITE@darties.com', 17, '2016-03-25 10:20:54'),
(18, 'BONNEVILLE', 'Damiane', 'Damiane.BONNEVILLE', 'S22tTv2', 'Damiane.BONNEVILLE@darties.com', 18, '2016-03-25 10:20:54'),
(19, 'PROULE', 'Lucas', 'Lucas.PROULE', '3YT56vn', 'Lucas.PROULE@darties.com', 19, '2016-03-25 10:20:54'),
(20, 'CHARPENTIER', 'Jeoffroi', 'Jeoffroi.CHARPENTIER', '8x3Bx3T', 'Jeoffroi.CHARPENTIER@darties.com', 20, '2016-03-25 10:20:54'),
(21, 'SEGIN', 'Stephane ', 'Stephane.SEGIN', '227wTTg', 'Stephane.SEGIN@darties.com', 21, '2016-03-25 10:20:54'),
(22, 'LEJEUNE', 'Romain', 'Romain.LEJEUNE', '4L5Cjh8', 'Romain.LEJEUNE@darties.com', 22, '2016-03-25 10:20:54'),
(23, 'LAFRAMMOISE', 'Paul', 'Paul.LAFRAMMOISE', 'fP67Xb9', 'Paul.LAFRAMMOISE@darties.com', 23, '2016-03-25 10:20:54'),
(24, 'MOREL', 'Claude', 'Claude.MOREL', '9zP6vS2', 'Claude.MOREL@darties.com', 24, '2016-03-25 10:20:54'),
(25, 'GODDU', 'Bertrand', 'Bertrand.GODDU', '28Qi9Wk', 'Bertrand.GODDU@darties.com', 25, '2016-03-25 10:20:54'),
(26, 'LEPICIER', 'Laetitia', 'Laetitia.LEPICIER', 'bqT483T', 'Laetitia.LEPICIER@darties.com', 26, '2016-03-25 10:20:54'),
(27, 'CHANDONNET', 'Marguerite', 'Marguerite.CHANDONNET', '2jN8i2X', 'Marguerite.CHANDONNET@darties.com', 27, '2016-03-25 10:20:54'),
(28, 'LECHAMPS', 'Maurice', 'Maurice.LECHAMPS', 'x4Br95Z', 'Maurice.LECHAMPS@darties.com', 28, '2016-03-25 10:20:54'),
(29, 'DELAPOSE', 'Audrey ', 'Audrey.DELAPOSE', '4sgV93U', 'Audrey.DELAPOSE@darties.com', 29, '2016-03-25 10:20:54'),
(30, 'AUDRAN', 'Emilie', 'Emilie.AUDRAN', '8qeP56Y', 'Emilie.AUDRAN@darties.com', 30, '2016-03-25 10:20:54'),
(31, 'DEDIAUX', 'Benjamin', 'Benjamin.DEDIAUX', '988hRnC', 'Benjamin.DEDIAUX@darties.com', 31, '2016-03-25 10:20:54'),
(32, 'LAURENT', 'Thomas', 'Thomas.LAURENT', '3Me5Z9h', 'Thomas.LAURENT@darties.com', 32, '2016-03-25 10:20:54'),
(33, 'DEY', 'Benoit', 'Benoit.DEY', '8G7Lfi6', 'Benoit.DEY@darties.com', 33, '2016-03-25 10:20:54'),
(34, 'DELAUNAY', 'Angelique', 'Angelique.DELAUNAY', 'g6Gb25T', 'Angelique.DELAUNAY@darties.com', 34, '2016-03-25 10:20:54'),
(35, 'LEGRAND', 'Alexis', 'Alexis.LEGRAND', '7u4d5XP', 'Alexis.LEGRAND@darties.com', 35, '2016-03-25 10:20:54'),
(36, 'VALLE', 'Marc', 'Marc.VALLE', 'c63L9zG', 'Marc.VALLE@darties.com', 36, '2016-03-25 10:20:54'),
(37, 'GIGUERE', 'Gilbert', 'Gilbert.GIGUERE', 'MT8t6w8', 'Gilbert.GIGUERE@darties.com', 37, '2016-03-25 10:20:54'),
(38, 'BEAULIEU', 'Theophile', 'Theophile.BEAULIEU', '9znW65L', 'Theophile.BEAULIEU@darties.com', 38, '2016-03-25 10:20:54'),
(39, 'TANGUAY', 'Lea', 'Lea.TANGUAY', 'x9F6zN9', 'Lea.TANGUAY@darties.com', 39, '2016-03-25 10:20:54'),
(40, 'ZACHARE', 'Patrick', 'Patrick.ZACHARE', '6jAg55V', 'Patrick.ZACHARE@darties.com', 40, '2016-03-25 10:20:54'),
(41, 'FROCHET', 'Elise', 'Elise.FROCHET', '4e69aEB', 'Elise.FROCHET@darties.com', 41, '2016-03-25 10:20:54'),
(42, 'FORTER', 'Louis', 'Louis.FORTER', 'ja82R2Z', 'Louis.FORTER@darties.com', 42, '2016-03-25 10:20:54'),
(43, 'JACKSON', 'William', 'William.JACKSON', 'fV9rY56', 'William.JACKSON@darties.com', 43, '2016-03-25 10:20:54'),
(44, 'ADAMS', 'Georges', 'Georges.ADAMS', 'gPzY863', 'Georges.ADAMS@darties.com', 44, '2016-03-25 10:20:54'),
(45, 'CARTER', 'Harry', 'Harry.CARTER', 'zB5e3D8', 'Harry.CARTER@darties.com', 45, '2016-03-25 10:20:54'),
(46, 'JOHNSON', 'Jimmy', 'Jimmy.JOHNSON', '579BHrp', 'Jimmy.JOHNSON@darties.com', 46, '2016-03-25 10:20:54'),
(47, 'BUCHANAN', 'Martin', 'Martin.BUCHANAN', 'mDPp867', 'Martin.BUCHANAN@darties.com', 47, '2016-03-25 10:20:54'),
(48, 'PIERCE', 'James', 'James.PIERCE', 'P58qg3J', 'James.PIERCE@darties.com', 48, '2016-03-25 10:20:54'),
(49, 'COOLIDGE', 'Emma', 'Emma.COOLIDGE', 'qW436sF', 'Emma.COOLIDGE@darties.com', 49, '2016-03-25 10:20:54'),
(50, 'HAYES', 'Richard', 'Richard.HAYES', '5n8Hs2W', 'Richard.HAYES@darties.com', 50, '2016-03-25 10:20:54'),
(51, 'CLEVELAND', 'Taylor', 'Taylor.CLEVELAND', '662wYNv', 'Taylor.CLEVELAND@darties.com', 51, '2016-03-25 10:20:54'),
(52, 'MADISON', 'Warren', 'Warren.MADISON', 'J95Pdx8', 'Warren.MADISON@darties.com', 52, '2016-03-25 10:20:54'),
(53, 'REAGAN', 'Arthur', 'Arthur.REAGAN', '3Jeh6G7', 'Arthur.REAGAN@darties.com', 53, '2016-03-25 10:20:54'),
(54, 'EVENO', 'Julie', 'Julie.EVENO', '7DusL99', 'Julie.EVENO@darties.com', 54, '2016-03-25 10:20:54'),
(55, 'OLIVER', 'Aurelie', 'Aurelie.OLIVER', 'tkHS596', 'Aurelie.OLIVER@darties.com', 55, '2016-03-25 10:20:54');


SET SQL_MODE=@OLD_SQL_MODE;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

CALL maj_dim_magasin_star();
CALL maj_faits_ventes_star();
CALL maj_securite_star();
