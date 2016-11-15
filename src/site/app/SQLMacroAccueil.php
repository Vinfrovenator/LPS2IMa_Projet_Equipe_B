<?php

namespace App;

class SQLMacroAccueil {
  //Création des tableau pour l'interface d'accueil

  public static function call($params = array()) {

    $params['I_DEVISE'] = 0;
    $app = App::getInstance();
    $id = '1';
    $db = ORM::get_db();

    $enseigne = $params['I_ENSEIGNE'];
    $temps = $params['I_TEMPS'];
    $geo = $params['I_REGION'];

    //filtrage seulon la liste des invites
    $sql = "  CREATE TEMPORARY TABLE transi".$id." as
    SELECT * from data_0
    WHERE id_enseigne in(select id_enseigne from requete_enseigne where code_enseigne='$enseigne')
    AND id_temps in(select id_temps from requete_temps_0 where code='$temps')
    AND id_magasin in(select id_magasin from requete_geo where code ='$geo')";
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
    $table = $app->view()->render("/macro/accueil/table.html", array(
      'data' => $data
    ));
    //var_dump($table);
    return $table;

  }
}
