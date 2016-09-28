<?php

namespace App;
use \App\ORMWrapper as ORMWrapper;

class Model extends \Model {
	
	public static function factory($class_name, $connection_name = null) {
		//$class_name = self::$auto_prefix_models . $class_name;
		$table_name = static::_get_table_name($class_name);

		if ($connection_name == null) {
		   $connection_name = self::_get_static_property(
			   $class_name,
			   '_connection_name',
			   ORMWrapper::DEFAULT_CONNECTION
		   );
		}
		$wrapper = ORMWrapper::for_table($table_name, $connection_name);
		$wrapper->set_class_name($class_name);
		$wrapper->use_id_column(self::_get_id_column_name($class_name));
		return $wrapper;
	}

}