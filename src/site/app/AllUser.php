<?php

namespace App;

class AllUser extends Filtre {

	public static $_table   = 'utilisateur';

	public static function getFiltreUser()
	{
		static $rtn = array();
        
        //$class = 'All\AllUser'
		$class = get_called_class();

		if (!isset($rtn[$class])) {
            //$vars contient le résultat de la requête
			$vars = Model::factory(get_called_class())
				->find_many();
            
			$rtn[$class] = array();
			foreach($vars as $var)
			{
				//var_dump($var);
				$rtn[$class][$var->{'ID'}] = array(
					'id' => $var->{'ID'},
					'name' => $var->{'NOM'},
					'surname' => $var->{'PRENOM'},
					'mail' => $var->{'MAIL'},
					'maj' => $var->{'DATEMAJ_USER'},
					'mdp' => $var->{'PASSWORD'},
                    'idprofil' => $var->{'ID_PROFIL'}
				);
			}
		}

		return $rtn[$class];
	}

}