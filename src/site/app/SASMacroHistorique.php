<?php

namespace App;

class SASMacroHistorique extends SASMacro {

	public function call($params = array()) {
		$params['I_DEVISE'] = 0;
		$params['I_INDICATEUR'] = ($params['I_INDICATEUR'] != 0) ? $params['I_INDICATEUR'] : 1;
		$app = App::getInstance();

		$suf = '';
		if($app->user->isDirecteurMagasin()) {
			$suf = '_DM';
			$params['I_REGION_DM'] = $params['I_REGION'];
		}
		elseif($app->user->isDirecteurRegional()) {
			$suf = '_DR';
			$params['I_REGION_DR'] = $params['I_REGION'];
		}
		else {
			$suf = '_DC';
			$params['I_REGION_DC'] = $params['I_REGION'];
		}

		$crawler = parent::_call('Tableau_Historique'.$suf, $params);

		$crawler->filter('table td.systemtitle')->each(function($node, $i) use (&$data) {
			$data = $node->text();
		});
		$libelle = explode('|', $data);
		
		$data = array();
		$crawler->filter('table.table tbody tr')->each(function($node, $i) use (&$data) {
			$node->filter('td, th')->each(function($node) use (&$data, $i) {
				$data[$i][] = ($node->text() == '.') ? '—' : $node->text();
			});
		});
		$total = array_pop($data);
		if(is_array($total)) {
			foreach($total as &$value) {
				if ($value == '0') $value = '—';
			}
		}
				
		$table = $app->view()->render("/macro/historique/table.html", array(
			'libelle' => $libelle,
			'data' => $data,
			'total' => $total
		));

		return json_encode(array(
			'ajax_historique_table' => $table
		));
	}
}