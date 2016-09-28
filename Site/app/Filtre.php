<?php

namespace App;

class Filtre extends Model {

	public static function getFiltreOptions()
	{
		static $rtn = array();
		$class = get_called_class();
		
		if (!isset($rtn[$class])) {
			$vars = Model::factory(get_called_class())
				->find_many();
			
			$rtn[$class] = array();
			foreach($vars as $var)
			{
				$rtn[$class][$var->{'CODE'}] = array(
					'id' => $var->{'CODE'},
					'libelle' => $var->{static::$_var_lib}
				);
			}
		}

		return $rtn[$class];
	}

}