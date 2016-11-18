Portage Oracle vers MySQL
Tous ces fichiers doivent être dans les répertoires :
- D:\eclipse-jee-mars-SR1-win64\tools\mysql-5.7.11-win32 pour créer sur le serveur MySQL 5.7.11 port 3309 (mot de passe root : sif);
- D:\eclipse-jee-mars-SR1-win64\tools\xampp\mysql pour MySQL de la distribution Xampp port 3306 (mot de passe root : rien du tout) .
DARTIES1-mysql-5.7.11.bat et DARTIES1.bat : script de création de l'utilisateur darties1/DARTIES1 soit pour la distribution Xampp soit pour MySQL 5.7.11. Ensuite une base de données darties1 est crée complètement avec créations des tables et alimentation
FAITS_VENTES_DATA_TABLE.dsv : données pour la table de fait
My_DARTIES1.sql : fichier SQL qui crée les tables, vues , vues materialisées et charge les donnéees de la table de fait
Open_darties1-mysql-5.7.11.bat et Open_darties1.bat : ouvre une session mysql connecté à la base darties1 en vue d'un requetage

Michel Dubois


INTRUCTION D'UTILISATION :

-Dézipper le dossier bdd dans votre dossier wamp (même dossier que www)


-Exécuter le fichier DARTIES1.bat


-Entrez le mot de passe root si il existe et cliquer sur entré (DROP bdd & User)


-Entrez le mot de passe root si il existe et cliquer sur entré(Créer new bdd & user)


-ATTENTION !! Veuillez importer le fichier My_DARTES1.sql via PhpMyAdmin sans fermé le terminal (Création et remplissage table)


-De retour sur le terminal, entré le mot de passe DARTIES1 (Import et remplissage de la table fait_ventes de 7000 lignes)


-Entrer à nouveau le mot de passe pour générer les view
-Importer via PhpMyAdmin le fichier My_DARTIES2.sql (Ignorez l'erreur générer à la fin de l'import)

FIN