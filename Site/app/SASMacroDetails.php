<?php

namespace App;

class SASMacroDetails extends SASMacro {

	public function call($params = array()) {
		
		$data = array();
		
		$crawler = parent::_call('macroDetails', $params);
		$crawler->filter('table.table tbody tr')->each(function($node, $i) use (&$data) {
			$node->filter('td, th')->each(function($node) use (&$data, $i) {
				$data[$i][] = ($node->text() == '.') ? '—' : $node->text();
			});
		});
		$total = array_pop($data);
		foreach($total as &$value) {
			if ($value == '0') $value = '—';
		}
		
		$ind_id = $params['I_INDICATEUR'];
		switch($ind_id) {
			case 0:
				$tpl = 0;
				$ind_lbl = null;
				break;
			default:
				$tpl = 1;
				$options = Indicateur::getFiltreOptions();
				$ind_lbl = $options[$ind_id]['libelle'];
				break;
		}
		
		$app = App::getInstance();

		$table = $app->view()->render("/macro/details/table_indicateur_$tpl.html", array(
			'ind_lbl' => $ind_lbl,
			'data' => $data,
			'total' => $total
		));
		
		$ca = $v = $mb = null;
		switch($ind_id) {
			case 0:
				$ca = self::indicateur('CA', $total[2], $total[3]);
				$v  = self::indicateur('V', $total[5], $total[6]);
				$mb = self::indicateur('MB', $total[8], $total[9]);
				break;
			case 1:
				$ca = self::indicateur('CA', $total[2], $total[3]);
				break;
			case 2:
				$v = self::indicateur('V', $total[2], $total[3]);
				break;
			case 3:
				$mb = self::indicateur('MB', $total[2], $total[3]);
				break;
		}

		return json_encode(array(
			'ajax_details_ca' => $ca,
			'ajax_details_ventes' => $v,
			'ajax_details_marge' => $mb,
			'ajax_details_table' => $table
		));
	}
	
	public static function indicateur($type, $new, $old) {
		
		if ($new != 0 && $old / $new >= 1.05) {
			$color = 'red';
		}
		elseif ($new != 0 && $old / $new <= 0.95) {
			$color = 'green';
		}
		elseif ($new != 0) {
			$color = 'yellow';
		}
		else {
			$color = 'none';
		}

		if (is_numeric($old)) {
			$old = number_format($old, 2, ',', ' ');
		}
		if (is_numeric($new)) {
			$new = number_format($new, 2, ',', ' ');
		}

		
		$app = App::getInstance();
		return $app->view()->render("/macro/details/indicateur.html", array(
			'color' => $color,
			'ind' => $type,
			'old' => $old,
			'new' => $new
		));
	}
}