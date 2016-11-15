<?php

namespace App;

class SQLMacroHistorique {
  //Création des tableau pour l'interface d'historique

  public static function call($params = array()) {

    $params['I_DEVISE'] = 0;
    $app = App::getInstance();
    $id = '1';
    $db = ORM::get_db();

    $enseigne = $params['I_ENSEIGNE'];
    $temps = $params['I_TEMPS'];
    $geo = $params['I_REGION'];
    $ind = $params['I_INDICATEUR'];
    $fam = $params['I_FAMPROD'];


    //Valeurs sans calcul
    $sql = "  CREATE TEMPORARY TABLE histo_transi_".$id." as
    SELECT * FROM data_1
    WHERE id_enseigne IN (select id_enseigne from requete_enseigne where code_enseigne='$enseigne')
    AND id_temps IN (select id_temps from requete_temps_0 where code='$temps')
    AND id_magasin IN (select id_magasin from requete_geo where code ='$geo')";
    $db->exec($sql);

    $sql = "  CREATE TEMPORARY TABLE histo_transi1_".$id." as
    SELECT t2.LIB_FAMILLE_PRODUIT , sum(OBJECTIF) AS SUM_of_VENTES_OBJECTIF, sum(REEL) AS SUM_of_VENTES_REEL, (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) AS Ecart_ventes
    FROM DIM_MAGASIN_STAR t1, histo_transi_".$id." t2
    WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN)
    GROUP BY t2.LIB_FAMILLE_PRODUIT;";
    $db->exec($sql);


    //Valeurs avec calcul
    $sql = "  CREATE TEMPORARY TABLE histo_transi_cumul_".$id." as
    SELECT * FROM data_1
    WHERE id_i ='$ind'
    AND id_famille_produit IN (select id_famille_produit FROM requete_famille where code_famille='$fam')
    AND id_enseigne IN (SELECT id_enseigne FROM requete_enseigne where CODE_ENSEIGNE='$enseigne')
    AND id_temps IN (SELECT id_temps from requete_temps_1 where code='$temps')
    AND id_magasin IN (SELECT id_magasin FROM requete_geo where code ='$geo');";
    $db->exec($sql);

    $sql = "  CREATE TEMPORARY TABLE histo_transi2_".$id." AS
    SELECT t2.LIB_FAMILLE_PRODUIT,
    (SUM(OBJECTIF)) AS SUM_of_VENTES_OBJECTIF_cumul,
    (SUM(REEL)) AS SUM_of_VENTES_REEL_cumul,
    (((SUM(REEL)) - (SUM(OBJECTIF))) / (SUM(OBJECTIF))) AS Ecart_ventes_cumul
    FROM DIM_MAGASIN_STAR t1, histo_transi_cumul_".$id." t2
    WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN )
    GROUP BY t2.LIB_FAMILLE_PRODUIT;";
    $db->exec($sql);

/*
    if(strlen($temps) < 10) then {
      < 10 then put(input(substr(".$temp.",0,4),4.)-1,4.) || substr('$temps',5)
         else put(input(substr('$temps',0,4),4.)-1,4.) || substr('$temps',5,3) || put(input(substr('$temps',8),4.)-1,4.
    }
*/
    //Valeurs non cumulées de l'année précédente
    $sql = "   CREATE TEMPORARY TABLE histo_transi_prec_".$id." as
    SELECT * FROM data_1
    WHERE id_i ='$ind'
    AND id_famille_produit IN (select id_famille_produit FROM requete_famille where code_famille='$fam')
    AND id_enseigne IN (SELECT id_enseigne FROM requete_enseigne where CODE_ENSEIGNE='$enseigne')
    AND id_temps in(select id_temps from requete_temps_0 where code= '$temps')
    AND id_magasin IN (SELECT id_magasin FROM requete_geo where code ='$geo');";
    $db->exec($sql);


    $sql = " CREATE TEMPORARY TABLE histo_transi3_".$id." as
    SELECT t2.lib_famille_produit,
    sum(OBJECTIF) as SUM_of_VENTES_OBJECTIF_prec,
    sum(REEL) as SUM_of_VENTES_REEL_prec,
    (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) as Ecart_ventes_prec
    FROM DIM_MAGASIN_STAR t1, histo_transi_prec_".$id." t2
    WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN)
    GROUP BY t2.LIB_FAMILLE_PRODUIT;";
    $db->exec($sql);


    //Valeurs cumulées de l'année précédente
    $sql = "   CREATE TEMPORARY TABLE histo_transi_cumul_prec_".$id." as
    SELECT * FROM data_1
    WHERE id_i ='$ind'
    AND id_famille_produit IN (select id_famille_produit FROM requete_famille where code_famille='$fam')
    AND id_enseigne IN (SELECT id_enseigne FROM requete_enseigne where CODE_ENSEIGNE='$enseigne')
    AND id_temps in(select id_temps from requete_temps_0 where code= '$temps')
    AND id_magasin IN (SELECT id_magasin FROM requete_geo where code ='$geo');";
    $db->exec($sql);

    $sql = " CREATE TEMPORARY TABLE histo_transi4_".$id." as
    SELECT t2.lib_famille_produit,
    sum(OBJECTIF) as SUM_of_VENTES_OBJECTIF_cum2,
    sum(REEL) as SUM_of_VENTES_REEL_cum2,
    (sum(REEL) - sum(OBJECTIF)) / sum(OBJECTIF) as Ecart_ventes_cum2
    FROM DIM_MAGASIN_STAR t1, histo_transi_cumul_prec_".$id." t2
    WHERE (t1.ID_MAGASIN = t2.ID_MAGASIN)
    GROUP BY t2.LIB_FAMILLE_PRODUIT;";
    $db->exec($sql);

    //Construction du tableau final
    $sql = " CREATE TEMPORARY TABLE HISTORIQUE1_".$id." as
  		SELECT t5.LIB_FAMILLE_PRODUIT,
  		t1.SUM_of_VENTES_OBJECTIF,
  		t1.SUM_of_VENTES_REEL,
  		t1.Ecart_ventes,
  		t2.SUM_of_VENTES_OBJECTIF_cumul,
  		t2.SUM_of_VENTES_REEL_cumul,
  		t2.Ecart_ventes_cumul,
      t3.SUM_of_VENTES_OBJECTIF_prec,
      t3.SUM_of_VENTES_REEL_prec,
      t3.Ecart_ventes_prec,
      t4.SUM_of_VENTES_OBJECTIF_cum2,
      t4.SUM_of_VENTES_REEL_cum2,
      t4.Ecart_ventes_cum2
  		FROM histo_transi1_".$id." t1, histo_transi2_".$id." t2, histo_transi3_".$id." t3, histo_transi4_".$id." t4, DIM_FAMILLE_PRODUIT t5
  		WHERE (t1.LIB_FAMILLE_PRODUIT=t2.LIB_FAMILLE_PRODUIT AND t2.LIB_FAMILLE_PRODUIT = t3.LIB_FAMILLE_PRODUIT AND t3.LIB_FAMILLE_PRODUIT=t4.LIB_FAMILLE_PRODUIT AND t4.LIB_FAMILLE_PRODUIT=t5.LIB_FAMILLE_PRODUIT)
  		ORDER BY t5.LIB_FAMILLE_PRODUIT;";
      $db->exec($sql);


      //Calcul des totaux
      $sql = "  CREATE TEMPORARY TABLE TOTAL1_".$id." as
                SELECT
      					sum(SUM_of_VENTES_OBJECTIF_prec) as SUM_of_VENTES_OBJECTIF_prec,
      					sum(SUM_of_VENTES_REEL_prec) as SUM_of_VENTES_REEL_prec,
      					((sum(SUM_of_VENTES_REEL_prec)-sum(SUM_of_VENTES_OBJECTIF_prec))/sum(SUM_of_VENTES_OBJECTIF_prec)) as Ecart_ventes_prec,

      					sum(SUM_of_VENTES_OBJECTIF_cum2) as SUM_of_VENTES_OBJECTIF_cum2,
      					sum(SUM_of_VENTES_REEL_cum2) as SUM_of_VENTES_REEL_cum2,
      					((sum(SUM_of_VENTES_REEL_cum2)-sum(SUM_of_VENTES_OBJECTIF_cum2))/sum(SUM_of_VENTES_OBJECTIF_cum2)) as Ecart_ventes_cum2,

      					sum(SUM_of_VENTES_OBJECTIF) as SUM_of_VENTES_OBJECTIF,
      					sum(SUM_of_VENTES_REEL) as SUM_of_VENTES_REEL,
      					((sum(SUM_of_VENTES_REEL)-sum(SUM_of_VENTES_OBJECTIF))/sum(SUM_of_VENTES_OBJECTIF)) as Ecart_ventes,

      					sum(SUM_of_VENTES_OBJECTIF_cumul) as SUM_of_VENTES_OBJECTIF_cumul,
      					sum(SUM_of_VENTES_REEL_cumul) as SUM_of_VENTES_REEL_cumul,
      					((sum(SUM_of_VENTES_REEL_cumul)-sum(SUM_of_VENTES_OBJECTIF_cumul))/sum(SUM_of_VENTES_OBJECTIF_cumul)) as Ecart_ventes_cumul
                FROM HISTORIQUE1_".$id.";";
      $db->exec($sql);


      $data = ORM::for_table("HISTORIQUE1_".$id)->find_array();
      $total = ORM::for_table("TOTAL1_".$id)->find_array();
      $table = $app->view()->render("/macro/historique/table.html", array(
        'data' => $data,
        'total'=> $total
      ));

      return $table;
  }
}
