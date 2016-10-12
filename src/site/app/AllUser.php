<?php

namespace App;

class AllUser extends Filtre {

	public static $_table   = 'select_user';

	public static function getFiltreUser()
	{
		static $rtn = array();
		$class = get_called_class();
		
		if (!isset($rtn[$class])) {
			$vars = Model::factory(get_called_class())
				->find_many();

			$rtn[$class] = array();
			foreach($vars as $var)
			{
				$name = explode(".", $var->{'USERNAME'});
				$rtn[$class][$var->{'CODE'}] = array(
					'id' => $var->{'CODE'},
					'name' => $name[1],
					'surname' => $name[0]
				);
			}
		}

		return $rtn[$class];
	}

}