<?php

namespace App;

class Token extends Model
{

    public static function connect($login, $password){
        $user = User::where('LOWER(MAIL)', strtolower(trim($login)))
			->where('PASSWORD', $password)
			->find_one();

		if (is_object($user)) {

            session_start();

            $_SESSION['USER_ID'] = $user->ID;
            $_SESSION['USER_MDP'] = $user->PASSWORD;
            $_SESSION['USER_NOM'] = $user->NOM;
            $_SESSION['USER_PRENOM'] = $user->PRENOM;
            $_SESSION['USER_USERNAME'] = $user->USERNAME;
            $_SESSION['USER_MAIL'] = $user->MAIL;
            $_SESSION['USER_ID_PROFIL'] = $user->ID_PROFIL;
            $_SESSION['USER_DATEMAJ_USER'] = $user->DATEMAJ_USER;
            $_SESSION['TIMESTAMP'] = date("Y-m-d H:i:s");

            $string = "";
            $chaine = "a0b1c2d3e4f5g6h7i8j9klmnpqrstuvwxy123456789";
            srand((double)microtime()*1000000);
            for($i=0; $i<10; $i++){
                $string .= $chaine[rand()%strlen($chaine)];
            }

            $_SESSION['TOKEN'] = $string;

			return $user;
		}

		return false;
    }

    public static function updatePasswd($token, $passwd){

        if($_SESSION['TOKEN'] == $token){
            $_SESSION['USER_MDP'] = $passwd;
            $user = ORM::for_table('utilisateur')->select('id')->find_one($_SESSION['USER_ID']);
            $user->set('password', $passwd);
            $user->save();

        }

    }

    public static function getUser($token){

        if($_SESSION['TOKEN'] == $token){
            $user = User::where('LOWER(MAIL)', strtolower(trim($_SESSION['USER_MAIL'])))
			->where('PASSWORD', $_SESSION['USER_MDP'])
			->find_one();
            if (is_object($user)) {
                return $user;
            }

            return false;
        }

    }

    public static function getProfil($token){

        if($_SESSION['TOKEN'] == $token){
            $profil = Profil::where('ID_PROFIL', $_SESSION['USER_ID_PROFIL'])->find_one();
            return $profil;
        }

    }

    public static function getSelect_temps($token){
        if($_SESSION['TOKEN'] == $token){
            ORM::configure('return_result_sets', true);
            $stack = array();
            $select_temps = ORM::for_table('select_temps')->find_many();
            $select_cumul = ORM::for_table('select_cumul')->find_many();
            $select_famille_produit = ORM::for_table('select_famille_produit')->find_many();
            $select_indicateur = ORM::for_table('select_indicateur')->find_many();
            array_push($stack, $select_temps, $select_cumul, $select_famille_produit, $select_indicateur);
            return $stack;
        }
    }

    public static function getTableauAccueilDM($token/*, $code_select_temps, $code_select_cumul, $code_select_indicateur*/){

      if($_SESSION['TOKEN'] == $token){

          $profil = Profil::where('ID_PROFIL', $_SESSION['USER_ID_PROFIL'])->find_one();
          foreach($profil as $record){
              $code_select_zone_geo = explode(" ", $record->LIB_PROFIL)[1];
              $id_zone = $record->ID_ZONE;
          }

          $db = ORM::get_db();
          $code_select_devise=1;
          $code_select_cours=1;

          $enseigne = ORM::for_table('dim_magasin_star')->where('ID_MAGASIN', $id_zone)->find_one();
          $code_select_enseigne = $enseigne->LIB_ENSEIGNE;
          $id = $_SESSION['USER_ID'];
          echo $code_select_enseigne;

          //filtrage seulon la liste des invites
          $sql = "  CREATE TEMPORARY TABLE transi".$id." as
          SELECT * from data_0
          WHERE id_enseigne in(select id_enseigne from requete_enseigne where code_enseigne='0')
          AND id_temps in(select id_temps from requete_temps_0 where code='2016_1_2016')
          AND id_magasin in(select id_magasin from requete_geo where code ='0')";
          $db->exec($sql);

          // requête tableau liée au chiffre d'affaire
          $sql = "  CREATE TEMPORARY TABLE accueil_CA_".$id." as
          SELECT  t3.lib_famille_produit,
          SUM(OBJECTIF) as CA_Objectif,
          SUM(REEL) as CA_Reel
          FROM dim_magasin_star t1 ,transi".$id." t2, dim_famille_produit t3
          WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT AND INDICATEUR='CA')
          GROUP BY t3.LIB_FAMILLE_PRODUIT";
          $db->exec($sql);

          //requête tableau liée aux ventes
          $sql = "  CREATE TEMPORARY TABLE accueil_VE_".$id." as
          SELECT  t3.lib_famille_produit,
          SUM(OBJECTIF) as Ventes_Objectif,
          SUM(REEL) as Ventes_Reel
          FROM dim_magasin_star t1 ,transi".$id." t2, dim_famille_produit t3
          WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT AND INDICATEUR='VENTES')
          GROUP BY t3.LIB_FAMILLE_PRODUIT";
          $db->exec($sql);

          //requête tableau dédié aux valeurs de marge
          $sql = "  CREATE TEMPORARY TABLE accueil_MA_".$id." as
          SELECT  t3.lib_famille_produit,
          SUM(OBJECTIF) as Marge_Objectif,
          SUM(REEL) as Marge_Reel
          FROM dim_magasin_star t1, transi".$id." t2, dim_famille_produit t3
          WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN AND t2.ID_FAMILLE_PRODUIT = t3.ID_FAMILLE_PRODUIT)
          GROUP BY t3.LIB_FAMILLE_PRODUIT";
          $db->exec($sql);

          //requête assemblage des 3 tableaux
          $sql = "  CREATE TEMPORARY table transi_Accueil_".$id." as
          SELECT t1.lib_famille_produit, t1.CA_Reel, t1.CA_Objectif, t2.Ventes_Reel, t2.Ventes_Objectif, t3.Marge_Reel, t3.Marge_Objectif
          FROM accueil_CA_".$id." t1, accueil_VE_".$id." t2, accueil_MA_".$id." t3
          WHERE (t1.LIB_FAMILLE_PRODUIT=t2.LIB_FAMILLE_PRODUIT AND t1.LIB_FAMILLE_PRODUIT=t3.LIB_FAMILLE_PRODUIT)";
          $db->exec($sql);

          //requête création d'une table identique pour la requpete suivante
          $sql = "  CREATE TEMPORARY table transi_AccueilBis_".$id." as
          SELECT t1.lib_famille_produit, t1.CA_Reel, t1.CA_Objectif, t2.Ventes_Reel, t2.Ventes_Objectif, t3.Marge_Reel, t3.Marge_Objectif
          FROM accueil_CA_".$id." t1, accueil_VE_".$id." t2, accueil_MA_".$id." t3
          WHERE (t1.LIB_FAMILLE_PRODUIT=t2.LIB_FAMILLE_PRODUIT AND t1.LIB_FAMILLE_PRODUIT=t3.LIB_FAMILLE_PRODUIT)";
          $db->exec($sql);

          //requête ajout d'une ligne total
          $sql = "  CREATE TEMPORARY table accueil_".$id." as
          SELECT *
          FROM transi_Accueil_".$id."
          UNION ALL
          SELECT  'TOTAL' as Total,
          SUM(CA_Reel) as CA_Reel,
          SUM(CA_Objectif) as CA_Objectif,
          SUM(Ventes_Reel) as Ventes_Reel,
          SUM(Ventes_Objectif) as Ventes_Objectif,
          SUM(Marge_Reel) as Marge_Reel,
          SUM(Marge_Objectif) as Marge_Objectif
          FROM transi_AccueilBis_".$id."
          ";
          $db->exec($sql);

          $data = ORM::for_table("accueil_".$id)->find_array();
          return json_encode($data);

      }

  }




}
