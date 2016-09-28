(Ce fichier a été rédigé par un collègue en projet de synthèse pendant le DUT mais vu qu'il explique assez rapidement les différentes fonctions de git je le remet !)

## Mode d'emploi de GIT

Suite à une petite mise à niveau sur Git vue au hacklab de l'ENSIBS, je me suis dit qu'il serait une bonne idée de faire
un petit tutorial sur comment se servir **correctement** de Git.
Par ce que vous allez voir que si tout le monde fait n'importe quoi on va se retrouver avec un dépôt inutilisable dû au
nombre de merge (fusion) qu'il va falloir faire à la main.

On clone le répertoire comme ça :
```git clone https://github.com/Vinfrovenator/LPS2IMa_Projet_Equipe_B.git```

Il y a plusieurs commandes pour se repérer du genre :
- ```git log``` qui liste les commits
- ```git status``` qui dit quels fichiers ont été changé et n'ont pas été commit
- ```git blame [NOM DU FICHIER]``` pour savoir qui à modifié le fichier spécifié

Donc pour éviter la *zone* sur le dépôt  il faudra suivre plusieurs règles :
1. 2 personnes sur le même fichier est à éviter fortement
2. Quand vous faites vos modifs, créer une branche (voir plus bas)
3. Pas de commit sur la branche master (expliqué plus bas aussi)

#### Les branches :

##### Pourquoi les branches ? 
Parce que admettons que X modifie un fichier sur la branche master et qu'il envoie sa modification sur le serveur.
Pendant ce temps Y modifie un autre fichier et envoie sa modification aussi. On se rend compte que la modification de X casse tout ou que ça marche pas.
Il faudra donc annuler la modification X mais aussi la modification de Y car les commits sont linéaires. C'est à dire
que chaque commit envoyé est basé sur l'état du fichier laissé par les précédents. C'est peut-être pas clair [Voir ici
pour plus d'info](https://leanpub.com/progitreedited/read). Mais en clair si les modifications des uns entraînent celle
des autres quand on fonctionne tous sur la même branche.

Tendis que si l'on crée une branche, les commits sont écrits sur celle-ci mais pas sur la branche principale. Chacun
fait son truc de son côté et à la fin on *merge* les branches crée par chacun. Si quelqu'un à cassé quelque chose on
annule la fusion de sa branche mais la fusion de celle des autres.

##### Comment on fait ?
Pour créer sa branche on fait : ```git branch test```
On va se fixer dessus : ```git checkout test```
Et on balance ses commits tranquillement: ```git commit -a```
```[test 4bd6ec8] Première partie du README
 1 file changed, 38 insertions(+)
 create mode 100644 README.md```

Lorsqu'on a fini et que l'on veut envoyer son tas de modification on va merger : 
```git checkout master```
```git merge test```


