<?php

namespace App;

define('_', dirname(__DIR__));
require _.'/vendor/autoload.php';
require _.'/app/_config.php';

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

$app->user = User::loadFromCookie();

// Route
$app->get('/', function() use ($app) {

	$date_maj = ORM::for_table('faits_ventes')->max('date_maj');
	if (User::isLogged()) {
		$email = User::getMAIL();
		$nom = User::getNOM();
		$prenom = User::getPRENOM();
		$id = User::getID();
		$username = User::getUSERNAME();
		$profil = User::getID_PROFIL();
		$date = User::getDATEMAJ_USER();
		$password = User::getPASSWORD();
		$app->render('/layout.html', array('date_maj' => $date_maj, 'email' => $email, 'password' => $password, 'nom' => $nom, 'prenom' => $prenom, 'id' => $id, 'username' => $username, 'profil' => $profil, 'date' => $date));
	}
	else {
		$app->redirect($app->urlPath.'/index.php/login');
	}
});

$app->get('/login', function() use ($app) {
	$app->render('/login.html');
});

//Permet de rediriger l'utilisateur en cas de mauvaise identification
//Propose mot de passe oublié
$app->get('/loginError', function() use ($app) {
	$app->render('/macro/loginError/login.html', ['error' => "mdpForget"]);
});

$app->get('/formMotDePasse', function() use ($app) {
	$app->render('/macro/loginError/formMotDePasse.html');
});

//Permet l'envoie d'un mail à l'utilisateur afin qu'il
//renouvelle son mot de passe
$app->post('/newPassword', function() use ($app) {
    $user = User::valideMail($app->request->post('email'));
    if (is_object($user)) {
		//Envoie d'un mail
        //
        //
        //
        //
        $app->redirect($app->urlPath.'/index.php/loginSent');
	}else{
        $app->redirect($app->urlPath.'/index.php/falseMail');
    }

});

//Page de connexion indiquant que le mail est invalide
$app->get('/falseMail', function() use ($app) {
	$app->render('/macro/loginError/formMotDePasse.html', ['error' => "NoMail"]);
});

//Page de connexion indiquant que le mail a été envoyé
$app->get('/loginSent', function() use ($app) {
	$app->render('/macro/loginError/login.html', ['error' => "mail"]);
});

$app->post('/login', function() use ($app) {
	$user = User::login($app->request->post('email'), $app->request->post('mdp'));

	if (is_object($user)) {
		$app->redirect($app->urlPath.'/');
	}
	else {
		$app->redirect($app->urlPath.'/index.php/loginError');
	}
});


$app->get('/logout', function() use ($app) {
	User::logout();
	$app->redirect($app->urlPath.'/index.php/login');
});

$app->get('/updateUser', function() use ($app) {
	$app->render('/layout.html');
});

$app->post('/updateUser', function() use ($app) {

    $user = User::updatePasswd($app->request->post('id'), $app->request->post('passwd'));

    $app->redirect($app->urlPath.'/index.php/updateUser');
});

$app->get('/updateProfilUser', function() use ($app) {
	$app->render('/layout.html');
});

$app->post('/updateProfilUser', function() use ($app) {

    $user = User::updateProfil($app->request->post('id'), $app->request->post('profilSelect'));

    $app->redirect($app->urlPath.'/index.php/updateProfilUser');
});

$app->get('/test', function() use ($app) {
	var_dump(SASMacroHistorique::call(
		array ( 'I_ENSEIGNE' => 0, 'I_INDICATEUR' => 0, 'I_CUMUL' => 0, 'I_FAMPROD' => 0, 'I_TEMPS' => '2015_1_2015', 'I_REGION' => 508)
	));
});

$app->group('/ajax', function() use ($app) {
	$app->response->headers->set('Cache-Control', 'no-cache, no-store, must-revalidate');
	$app->response->headers->set('Pragma', 'no-cache');
	$app->response->headers->set('Expires', '0');

	$app->group('/tab', function() use ($app) {

    $app->post('/accueil', function() use ($app) {
			//echo json_encode(array('ajax_accueil_table' => print_r($app->request->post(), true)));
			//echo json_encode(SQLMacroAccueil::call($app->request->post()));
		});

		$app->post('/historique', function() use ($app) {
			//echo json_encode(SQLMacroHistorique::call($app->request->post()));
		});

		$app->post('/palmares', function() use ($app) {
			echo SASMacroPalmares::call($app->request->post());
		});

		$app->post('/details', function() use ($app) {
			echo SASMacroDetails::call($app->request->post());
		});

	});
});

$app->post('/connection', function() use ($app) {

    $token = Token::connect($app->request->post('email'), $app->request->post('mdp'));
    
    if (is_object($token)) {
        var_dump($token);
        echo $_SESSION['USER_NOM'];
		return json_encode($token, 201);
	}
	else {
		echo "Identifiant incorrect!";
	}
    
    
});

$app->put('/update/:token', function ($token, Request $request) use ($app) {
    session_start();

    $token = Token::updatePasswd($_SESSION['token'], $app->request->post('passwd'));
    
    return $app->json('No Content', 204);  // 204 = No content
    
});


// Run app
$app->run();
