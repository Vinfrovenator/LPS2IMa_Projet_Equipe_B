<?php

namespace App;

class Profils extends Filtre {

	public static $_table = 'profil';

	public static function getFiltreProfil()
	{
		static $rtn = array();
		$class = get_called_class();
		
		if (!isset($rtn[$class])) {
			$vars = Model::factory(get_called_class())
				->find_many();

			$rtn[$class] = array();
			foreach($vars as $var)
			{
				$rtn[$class][$var->{'ID_PROFIL'}] = array(
					'id' => $var->{'ID_PROFIL'},
					'libelle' => $var->{'LIB_PROFIL'},
                    'idprofil' => $var->{'ID_PROFIL'}
				);
			}
		}

		return $rtn[$class];
	}
    
    
    public static function getUnusedProfil()
    {
        
        static $rtn2 = array();
		$class = get_called_class();
        
        if (!isset($rtn2[$class])) {
			$vars = ORM::for_table('profil')->raw_query('SELECT * FROM profil WHERE NOT EXISTS (SELECT * FROM utilisateur WHERE profil.ID_PROFIL = utilisateur.ID_PROFIL)')->find_many();
            var_dump($vars);
			$rtn2[$class] = array();
			foreach($vars as $var)
			{
				$rtn2[$class][$var->{'ID_PROFIL'}] = array(
					'id' => $var->{'ID_PROFIL'},
					'libelle' => $var->{'LIB_PROFIL'}
				);
			}
		}

		return $rtn2[$class];
	}
      

}