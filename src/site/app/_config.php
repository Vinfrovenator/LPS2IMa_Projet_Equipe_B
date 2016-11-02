<?php

$slimConf = array(
	'debug' => true,
	'log.enable' => true,
	'log.level' => \Slim\Log::WARN,
	'templates.path' => _.'/templates',
	'view' => new \Slim\Views\Twig(array(
		'auto_reload' => true,
		'autoescape' => true,
		'cache' => _.'/cache/twig',
		'charset' => 'utf-8',
		'strict_variables' => false,
	))
);

$idiormConf = array(
    'connection_string' => 'mysql:host=localhost;dbname=darties1',
    'username' => 'root',
    'password' => 'root',
	'limit_clause_style' => '',
    'caching' => false,
    'return_result_sets' => true,
	'identifier_quote_character' => ""
);

$SASMacroConf = array(
	'url' => 'http://ens-dsiva-0002.univ-ubs.fr/SASStoredProcess/do',
	'params' => array(
		'_username' => 'DARTIES1-2015',
		'_password' => 'P@ssw0rd',
		'_program' => '/User Folders/DARTIES1-2015/My Folder/STP/',
		'_action' => 'execute,nobanner',
		//'_debug' => '131'
	)
);

//http://ens-dsiva-0002.univ-ubs.fr/SASStoredProcess/do?_username=DARTIES1-2015&_password=P@ssw0rd&_program=%2FUser+Folders%2FDARTIES1-2015%2FMy+Folder%2FSTP%2FmacroDetails&_action=execute,nobanner&I_INDICATEUR=1&I_ENSEIGNE=1&I_FAMPROD=1&I_TEMPS=2015_1_2015&I_REGION=0
