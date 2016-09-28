* Début du code EG généré (ne pas modifier cette ligne);
*
*  Application stockée enregistrée par
*  Enterprise Guide Stored Process Manager V6.1
*
*  ====================================================================
*  Nom de l'application stockée : MDLivres
*
*  Description : Exemple d'application stockée SAS qui génére un flux
*  ====================================================================
*;


*ProcessBody;

* Fin du code EG généré (ne pas modifier cette ligne);


/* Chemin physque : pas recommende !
LIBNAME DAR12015 BASE "D:\SASuserdirs\projets\DARTIES1-2015\Bibliotheque" ;
*/
/*
* Chemin logique défini centralement dans les metadonnees ;
LIBNAME DAR12015 META library="/User Folders/DARTIES1-2015/My Folder/DARTIES1-2015";
*/
/*
Bibliotheque pre-affectee : pas la peine de la declarer !
*/
data _null_;
rc=stpsrv_header('Access-Control-Allow-Credentials','true');
rc=stpsrv_header('Access-Control-Allow-Origin','*');
rc=stpsrv_header('Vary','Origin');
rc=stpsrv_header('Cache-Control','no-cache');
rc=stpsrv_header('Pragma','no-cache');
run;
%stpbegin;
proc print data=DAR12015.LIVRES;
run;
/* Autre bibliotheque */
LIBNAME MDFNUC META LIBRARY="/Shared Data/SASSHARE-MDFNUC";
PROC SQL;
SELECT 	NOM , 
		MOTDEPASSE ,
		DATECOM ,
		TITRE ,
		AUTEURS ,
		RESUME_URL ,
		COUVERTURE_URL ,
		PRIX ,
		NIVEAU ,
		SECURITE , 
		QUANTITE , 
		LIBELLE , 
		sujet_url AS SUJET_URL 
FROM 	( 	( 	(	MDFNUC.Livres 
					LEFT OUTER JOIN
					( 	MDFNUC.Clients 
						LEFT OUTER JOIN MDFNUC.Commandes 
						ON Commandes.CLIENT = Clients.ID ) 
				ON Livres.ID = Commandes.ARTICLE ) 
				LEFT OUTER JOIN MDFNUC.Stocks 
			ON Stocks.ARTICLE = Livres.ID ) 
			LEFT OUTER JOIN MDFNUC.Livres_Sujets 
		ON Livres_Sujets.BOOK_ID = Livres.ID ) 
	LEFT OUTER JOIN MDFNUC.Sujets 
	ON Livres_Sujets.TOPIC_ID = Sujets.ID;
QUIT;
/*
%include "&racine.\Libname.sas";
proc print data=ORA12015.DEVISE;
run;
*/
%stpend;

* Début du code EG généré (ne pas modifier cette ligne);
;*';*";*/;quit;

* Fin du code EG généré (ne pas modifier cette ligne);
