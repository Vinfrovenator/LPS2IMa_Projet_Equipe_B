<?php

namespace app;

class ORM extends \ORM
{

	public static function for_table($table_name, $connection_name = parent::DEFAULT_CONNECTION) {
		static::_setup_db($connection_name);
		return new self($table_name, array(), $connection_name);
	}
	
	protected function _call_aggregate_db_function($sql_function, $column) {
		$alias = strtoupper($sql_function);
		$sql_function = strtoupper($sql_function);
		if('*' != $column) {
			$column = $this->_quote_identifier($column);
		}
		$result_columns = $this->_result_columns;
		$this->_result_columns = array();
		$this->select_expr("$sql_function($column)", $alias);
		$result = $this->find_one();
		$this->_result_columns = $result_columns;

		$return_value = 0;
		if($result !== false && isset($result->$alias)) {
			if (!is_numeric($result->$alias)) {
				$return_value = $result->$alias;
			}
			elseif((int) $result->$alias == (float) $result->$alias) {
				$return_value = (int) $result->$alias;
			} else {
				$return_value = (float) $result->$alias;
			}
		}

		return $return_value;
	}
	
}
