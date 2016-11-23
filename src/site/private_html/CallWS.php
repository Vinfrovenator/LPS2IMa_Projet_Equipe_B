<?php

namespace App;

define('_', dirname(__DIR__));
require _.'/vendor/autoload.php';
require _.'/app/_config.php';
require _.'/private_html/FunctionsWS.php';

date_default_timezone_set('Europe/Paris');

$app = new App($slimConf);
ORM::configure($idiormConf);
SASMacro::configure($SASMacroConf);

// Enregistre une nouvelle fonction Twig pour appeller facilement les methodes statiques d'une classe
$twig = $app->view()->getEnvironment();
$twigFunction = new \Twig_SimpleFunction('static',  function ($class, $method) {
    return call_user_func(array(__NAMESPACE__ .'\\'.$class, $method));
});
$twig->addFunction($twigFunction);

$urlPath = array_filter(explode('/', rtrim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/')));
foreach($urlPath as $value) {
	if ($value != 'index.php') {
		$app->urlPath .= '/'.$value;
	}
	else {
		break;
	}
}

$app->get('/loginwebservice', function() use ($app) {
	$app->render('/macro/testwebservice/login.html');
});

$app->get('/newpassword', function() use ($app) {
	$app->render('/macro/testwebservice/newpasswordform.html');
});

$app->post('/connection', function() use ($app) {

    $email = $app->request->post('email');
    $password = $app->request->post('mdp');
    
    $response = array();
    
    $token = FunctionsWS::connect($email, $password);

    if ($token) {
        echo "Connection de ".$_SESSION['USER_PRENOM']." ".$_SESSION['USER_NOM']."<br>";
        $response["error"] = false;
        $response["message"] = "You are successfully loged in";
        echo json_encode($response, 201);
	}else {
		$response["error"] = true;
        $response["message"] = "Email address or password not valid";
        echo json_encode($response, 200);
	}


});

$app->post('/update', function () use ($app) {

    session_start();

    $update = FunctionsWS::updatePasswd($_SESSION['TOKEN'], $app->request->post('password'));
    $token = FunctionsWS::getUser();
    if (is_object($token)) {
        echo "New password of ".$_SESSION['USER_PRENOM']." ".$_SESSION['USER_NOM']." is now : ".$_SESSION['USER_MDP']."<br>";
        //var_dump($token);
        echo json_encode($token, 201);
    }else {
		echo "Identifiant incorrect!";
	}

});

$app->get('/getuser', function () use ($app) {

    session_start();

    $token = FunctionsWS::getUser($_SESSION['TOKEN']);
    var_dump($token);
    echo json_encode($token, 201);


});

$app->get('/getprofil', function () use ($app) {

    session_start();

    $token = FunctionsWS::getProfil($_SESSION['TOKEN']);
    var_dump($token);
    echo json_encode($token, 201);

});

$app->get('/getselect_temps', function () use ($app) {

    session_start();
    $temps = array();
    $temps = Token::getSelect_temps($_SESSION['TOKEN']);
    var_dump($temps);
    echo json_encode($temps, 201);

});

$app->get('/getTableauAcceuilDM', function () use ($app) {

    session_start();

    $tableau = FunctionsWS::getTableauAccueilDM($_SESSION['TOKEN']);
    var_dump($tableau);
    //echo json_encode($tableau, 201);

});

// Run app
$app->run();
