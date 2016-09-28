<?php

namespace App;

class Temps extends Filtre {

	public static $_table   = 'select_temps';
	public static $_var_lib = 'LIB_TEMPS';

	public static function getFiltreOptions() {
		$annne = date('Y');
		$annees = array($annne, $annne-1, $annne-2);
		$rtn = array();
		foreach($annees as $annee) {
			$rtn[] = array(
				'key'     => $annee.'_1_'.$annee,
				'lv'      => 1,
				'libelle' => 'Année '.$annee,
			);
			foreach(array(1, 2) as $semestre) {
				$rtn[] = array(
					'key'     => $annee.'_2_'.$semestre,
					'lv'      => 2,
					'libelle' => 'Semestre '.$semestre,
				);
				switch($semestre) {
					case 1:
						$trimestres = array(1, 2);
						break;
					case 2:
						$trimestres = array(3, 4);
						break;
				}
				foreach($trimestres as $trimestre) {
					$rtn[] = array(
						'key'     => $annee.'_3_'.$trimestre,
						'lv'      => 3,
						'libelle' => 'Trimestre '.$trimestre,
					);
					switch($trimestre) {
						case 1:
							$mois = array(1 => 'Janvier', 2 => 'Février', 3 => 'Mars');
							break;
						case 2:
							$mois = array(4 => 'Avril', 5 => 'Mai', 6 => 'Juin');
							break;		
						case 3:
							$mois = array(7 => 'Juillet', 8 => 'Août', 9 => 'Septembre');
							break;		
						case 4:
							$mois = array(10 => 'Octobre', 11 => 'Novembre', 12 => 'Décembre');
							break;								
					}
					foreach($mois as $key => $value) {
						$rtn[] = array(
							'key'     => $annee.'_4_'.$key,
							'lv'      => 4,
							'libelle' => $value,
						);
					}
				}
			}
			
		}
		return $rtn;
	}
}