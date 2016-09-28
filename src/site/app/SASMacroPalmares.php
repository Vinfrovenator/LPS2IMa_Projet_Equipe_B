<?php

namespace App;

class SASMacroPalmares extends SASMacro {

	public function call($params = array()) {
		$app = App::getInstance();
	
		$data = array();

		$suf = '';
		if ($app->user->isDirecteurMagasin()) {
			$suf = 'Mag';
		}
		
		$crawler = parent::_call('macroPalma'.$suf, $params);
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
		
		$table = $app->view()->render("/macro/palmares/table_indicateur_$tpl.html", array(
			'ind_lbl' => $ind_lbl,
			'data' => $data
		));

		return json_encode(array(
			'ajax_palmares_table' => $table
		));
	}
}