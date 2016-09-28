<?php

namespace App;
use \Goutte\Client;

class SASMacro {

	private static $conf = array();
	
	protected static function _call($macroName, $params = array()) {
		$client = new Client();
		$client->getClient()->setDefaultOption('config/curl/'.CURLOPT_TIMEOUT, 0);
		$params2 = self::$conf['params'];
		$params2['_program'] .= $macroName;
		$params = array_merge($params, $params2);
		$crawler = $client->request('POST', self::$conf['url'], $params);
		return $crawler;
	}
	
	public static function configure($conf) {
		self::$conf = $conf;
	}
	
}