<?php

namespace App;

class FunctionsWS extends Model {

  public static function connect($login, $password){
    $user = User::where('LOWER(MAIL)', strtolower(trim($login)))
    ->where('PASSWORD', $password)
    ->find_one();

    if (is_object($user)) {

      $string = "";
      $chaine = "a0b1c2d3e4f5g6h7i8j9klmnpqrstuvwxy123456789";
      srand((double)microtime()*1000000);
      for($i=0; $i<10; $i++){
        $string .= $chaine[rand()%strlen($chaine)];
      }

      $_SESSION['USER_ID'] = $user->ID;
      $_SESSION['USER_MDP'] = $user->PASSWORD;
      $_SESSION['USER_NOM'] = $user->NOM;
      $_SESSION['USER_PRENOM'] = $user->PRENOM;
      $_SESSION['USER_USERNAME'] = $user->USERNAME;
      $_SESSION['USER_MAIL'] = $user->MAIL;
      $_SESSION['USER_ID_PROFIL'] = $user->ID_PROFIL;
      $_SESSION['USER_DATEMAJ_USER'] = $user->DATEMAJ_USER;
      $_SESSION['TIMESTAMP'] = date("Y-m-d H:i:s");
      $_SESSION['TOKEN'] = $string;

      return $user;
    }
    return false;
  }

  public static function updatePasswd($token, $passwd, $id){
    if(isset($token)){
      $user = ORM::for_table('utilisateur')->select('id')->find_one($id);
      $user->set('password', $passwd);
      $user->save();
      return $user;
    }
    return false;
  }


  public static function getUser($token){
    if(isset($token)){
      $user = User::where('LOWER(MAIL)', strtolower(trim(User::getMAIL())))
      ->where('PASSWORD', User::getPASSWORD())
      ->find_one();
      if (is_object($user)) {
        return $user;
      }
      return false;
    }
  }

  public static function getProfil($token){
    if(isset($token)){
      $profil = Profil::where('ID_PROFIL', $_SESSION['USER_ID_PROFIL'])->find_one();
      return $profil;
    }
  }

  public static function getSelect_temps($token){
    if(isset($token)){
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

  public static function getSpinnerVille($region){

    $magasins_of_region = array();
    $magasins = ORM::for_table('dim_magasin_star')->where('LIB_REGION_COM', $region)->find_many();
    foreach($magasins as $item){
      array_push($magasins_of_region, $item->VILLE." - ".$item->LIB_ENSEIGNE);
    }
    return $magasins_of_region;

  }

  public static function addSaisieVente($json_vente, $id_profil, $token){

    if(isset($token)){

      foreach($json_vente as $vente){

        $profil = Profil::where('ID_PROFIL', $id_profil)->find_one();
        foreach($profil as $record){
          $id_magasin = $profil->ID_ZONE;
        }

        if($vente->name == "Four") $id_famille_produit = 1;
        if($vente->name == "Hifi") $id_famille_produit = 2;
        if($vente->name == "Magnetoscope") $id_famille_produit = 3;

        $id_temps=date("Y").date("m");
        $ventes_objectif = $vente->objSales;
        $vente_reel = $vente->realSales;
        $ca_objectf = $vente->objTurnover;
        $ca_reel = $vente->realTurnover;
        $marge_objectif = $vente->objMargin;
        $marge_reel = $vente->realMargin;
        $date_maj = date("Y-m-d H:i:s");

        $insert_faits_ventes = ORM::for_table('faits_ventes')->create();

        $insert_faits_ventes->ID_MAGASIN = $id_magasin;
        $insert_faits_ventes->ID_FAMILLE_PRODUIT = $id_famille_produit;
        $insert_faits_ventes->ID_TEMPS = $id_temps;
        $insert_faits_ventes->VENTES_OBJECTIF = $ventes_objectif;
        $insert_faits_ventes->VENTES_REEL = $vente_reel;
        $insert_faits_ventes->CA_OBJECTIF = $ca_objectf;
        $insert_faits_ventes->CA_REEL = $ca_reel;
        $insert_faits_ventes->MARGE_OBJECTIF = $marge_objectif;
        $insert_faits_ventes->MARGE_REEL = $marge_reel;
        $insert_faits_ventes->DATE_MAJ = $date_maj;

        $insert_faits_ventes->save();
      }
    }

    return true;
  }

public static function getTableauAccueilDM($id, $id_profil, $token  /*, $code_select_temps, $code_select_cumul, $code_select_indicateur*/){

  if(isset($token)){

    $profil = Profil::where('ID_PROFIL', $id_profil)->find_one();
    foreach($profil as $record){
      $code_select_zone_geo = explode(" ", $profil->LIB_PROFIL)[1];
      $id_zone = $profil->ID_ZONE;
    }

    $db = ORM::get_db();
    $code_select_devise=1;
    $code_select_cours=1;

    $enseigne = ORM::for_table('dim_magasin_star')->where('ID_MAGASIN', $id_zone)->find_one();
    $code_select_enseigne = $enseigne->LIB_ENSEIGNE;
    $id = $id;
    //echo $code_select_enseigne;

    //filtrage seulon la liste des invites
    $sql = "  CREATE TEMPORARY TABLE transi".$id." as
    SELECT * from data_1
    WHERE id_enseigne in(select id_enseigne from requete_enseigne where code_enseigne='0')
    AND id_temps in(select id_temps from requete_temps_0 where code='2015_1_2015')
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
    //substr pour enlever "Darty" de $data : "Darty[ { ...} ]";
    //var_dump($data);
    return $data;
  }
}

public static function getTableauAccueilDR($id, $id_profil, $ville, $token  /*, $code_select_temps, $code_select_cumul, $code_select_indicateur*/){

  if(isset($token)){

    $profil = Profil::where('ID_PROFIL', $id_profil)->find_one();
    foreach($profil as $record){
      $code_select_zone_geo = explode(" ", $profil->LIB_PROFIL)[1];
      $id_zone = $profil->ID_ZONE;
    }

    $db = ORM::get_db();
    $code_select_devise=1;
    $code_select_cours=1;

    $enseigne = ORM::for_table('dim_magasin_star')->where('ID_MAGASIN', $id_zone)->find_one();
    $code_select_enseigne = $enseigne->LIB_ENSEIGNE;
    $id = $id;
    //echo $code_select_enseigne;

    //filtrage seulon la liste des invites
    $sql = "  CREATE TEMPORARY TABLE transi".$id." as
    SELECT * from data_1
    WHERE id_temps in(select id_temps from requete_temps_0 where code='2015_1_2015')
    AND id_magasin in(select id_magasin from requete_geo where code ='0')
    AND Ville =\"".$ville . "\"";
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
    //substr pour enlever "Darty" de $data : "Darty[ { ...} ]";
    //var_dump($data);
    return $data;
  }

}

}
