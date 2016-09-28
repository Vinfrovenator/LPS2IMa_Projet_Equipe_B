<?php

namespace App;
use \Goutte\Client;

class SASMacroAccueil extends SASMacro {

	public function call($params = array())
	{
		$params['I_DEVISE'] = 0;
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

		$crawler = parent::_call('Tableau_Accueil'.$suf, $params);
		$app = App::getInstance();
		$data = array();
		$crawler->filter('table.table tbody tr')->each(function($node, $i) use (&$data) {
			$node->filter('td, th')->each(function($node) use (&$data, $i) {
				$data[$i][] = ($node->text() == '.') ? '—' : $node->text();
			});
		});
		$total = array_pop($data);
		foreach($total as &$value) {
			if ($value == '0') $value = '—';
		}
				
		$table = $app->view()->render("/macro/accueil/table.html", array(
			'data' => $data,
			'total' => $total
		));
		
		/* Carte */
		$mapfile = _.'/private_html/img/map_sas/reg'.$params['I_REGION'].'_ens'.$params['I_ENSEIGNE'].'.png';
		if (!file_exists($mapfile)) {
			$params2['select_enseigne'] = $params['I_ENSEIGNE'];
			$params2['select_regioncom'] =  $params['I_REGION'];
			$crawler = parent::_call('mapMacroDynamic', $params2);
			$imgsrc = 'http://ens-dsiva-0002.univ-ubs.fr';
			$crawler->filter('img')->each(function($node, $i) use (&$imgsrc) {
				$imgsrc .= $node->attr('src');
			});
			
			/*$client = new Client();
			$client->getClient()->get($imgsrc, array('save_to' => $mapfile));*/
			//self::save_from_url($imgsrc, $mapfile);
		}
		
		return json_encode(array(
			'ajax_accueil_table' => $table,
			'ajax_accueil_imgsrc' => $mapfile
		));
	}
	
	public function save_from_url($inPath,$outPath)
	{ //Download images from remote server
		$in=    fopen($inPath, "rb");
		$out=   fopen($outPath, "wb");
		while ($chunk = fread($in,8192))
		{
			fwrite($out, $chunk, 8192);
		}
		fclose($in);
		fclose($out);
	}
}