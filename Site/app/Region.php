<?php

namespace App;

class Region extends Filtre {

	public static $_table   = 'select_zone_geo';
	public static $_var_lib = 'LIBELLE';

	public static function getFiltreOptions() {
		$app = App::getInstance();
		$res =  parent::getFiltreOptions();
		
		$minus = 0;
		if ($app->user->isDirecteurRegional()) {
			$minus = 1;
			
			$min_key = $app->user->profil()->ID_ZONE*100;
			$max_key = ($app->user->profil()->ID_ZONE+1)*100-1;
			
			foreach($res as $key => $value) {
				if ($key < $min_key || $key > $max_key) {
					unset($res[$key]);
				}
			}
		}
		elseif ($app->user->isDirecteurMagasin()) {
			$minus = 2;
			
			foreach($res as $key => $value) {
				if (substr($value['id'], -2) != $app->user->profil()->ID_ZONE) {
					unset($res[$key]);
				}
			}
		}
		
		foreach ($res as $key => $value) {
			if ($value['id'] < 1000) {
				$res[$key] = array(
					'id' => $key,
					'libelle' => trim($value['libelle'], '- '),
					'lv' => self::level($value['id'], $minus)
				);
			}
			else {
				unset($res[$key]);
			}
		}
		
		return $res;
	}
	
	private static function level($id, $minus = 0) {
		if($id == 0) {
			return 1 - $minus;
		}
		elseif (substr($id, -2) == 0) { // Region
			return 2 - $minus;
		}
		else {
			return 3 - $minus; // Ville
		}
	}	
}