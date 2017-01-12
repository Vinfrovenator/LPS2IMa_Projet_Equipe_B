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

$app->user = User::loadFromCookie();

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

$app->get('/getTableauAccueilDM', function () use ($app) {

    session_start();

    $tableau = FunctionsWS::getTableauAccueilDM($_SESSION['TOKEN']);
    var_dump($tableau);
    //echo json_encode($tableau, 201);

});

$app->get('/getTableauAccueilDR', function () use ($app) {

    session_start();

    $tableau = FunctionsWS::getTableauAccueilDR($_SESSION['TOKEN']);
    var_dump($tableau);
    //echo json_encode($tableau, 201);

});

// Run app
$app->run();
