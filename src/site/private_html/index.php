<?php
namespace App;

session_start();

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
			echo json_encode(SQLMacroAccueil::call($app->request->post()));
		});

		$app->post('/historique', function() use ($app) {
			echo json_encode(SQLMacroHistorique::call($app->request->post()));
		});

		$app->post('/palmares', function() use ($app) {
			echo SASMacroPalmares::call($app->request->post());
		});

		$app->post('/details', function() use ($app) {
			echo SASMacroDetails::call($app->request->post());
		});

	});
});

$app->get('/loginwebservice', function() use ($app) {
	$app->render('/macro/testwebservice/login.html');
});

$app->get('/newpassword', function() use ($app) {
	$app->render('/macro/testwebservice/newpasswordform.html');
});

$app->post('/connection', function() use ($app) {

    //Reading post params
    $email = $app->request->post('email');
    $password = $app->request->post('mdp');

    $response = array();

    $token = FunctionsWS::connect($email, $password);

    $response = array();
    $profil = FunctionsWS::getProfil($_SESSION["TOKEN"]);
    if ($token) {
        $response["success"] = true;
        $response["id"] = $_SESSION['USER_ID'];
        $response["password"] = $_SESSION['USER_MDP'];
        $response["name"] = $_SESSION['USER_NOM'];
        $response["surname"] = $_SESSION['USER_PRENOM'];
        $response["user_surname"] = $_SESSION['USER_USERNAME'];
        $response["mail"] = $_SESSION['USER_MAIL'];
        $response["profil"] = $_SESSION['USER_ID_PROFIL'];
        $response["date_maj"] = $_SESSION['USER_DATEMAJ_USER'];
        $response["token"] = $_SESSION['TOKEN'];
        $response["lib_profil"] = $profil->LIB_PROFIL;
        $response["type_profil"] = $profil->TYPE_ZONE;
    }else {
        $response["success"] = false;
        $response["message"] = "Un probleme interne est survenu (check var_dump & echo)";
    }

    echo json_encode($response, 200);

});

$app->post('/update', function () use ($app) {

    FunctionsWS::loadSessionFromCookie();

    $password = $app->request->post('password');
    $token = $app->request->post('token');
    $id = $app->request->post('id');

    $user = FunctionsWS::updatePasswd($token, $password, $id);

    $response = array();
    if (is_object($user)) {
        $response["success"] = true;
        $response["password"] = $password;
        $response["message"] = "Mot de passe de ".$id." modifie : ".$password;
    }else {
        $response["success"] = false;
        $response["message"] = "Un problème interne est survenu (check var_dump & echo)";
    }

    echo json_encode($response, 200);

});

$app->get('/getuser', function () use ($app) {

    $token = FunctionsWS::getUser($_SESSION['TOKEN']);
    var_dump($token);
    echo json_encode($token, 201);

});

$app->get('/getprofil', function () use ($app) {

    $token = Token::getProfil($_SESSION['TOKEN']);
    var_dump($token);
    echo json_encode($token, 201);

});

$app->get('/getselect_temps', function () use ($app) {

    $temps = array();
    $temps = FunctionsWS::getSelect_temps($_SESSION['TOKEN']);
    var_dump($temps);
    echo json_encode($temps, 201);

});

$app->get('/getspinnerville', function() use ($app) {

    $lib_profil = $app->request->get('profil');
    $towns = FunctionsWS::getSpinnerVille($lib_profil);
    echo json_encode($towns, 201);

});

$app->get('/addSaisieVente', function () use ($app) {

    //$string = '[{"name":"Hifi","realTurnover":46464,"objTurnover":4943734,"realSales":854,"objSales":484575,"realMargin":8464649,"objMargin":484545},{"name":"Four","realTurnover":56464,"objTurnover":86494,"realSales":5676437,"objSales":79494,"realMargin":7845464,"objMargin":784676}]';

    $string = $app->request->post('string_vente');
    $id_profil = $app->request->post("id_profil");
    $token = $app->request->post("token");

    $json_vente = json_decode($string);

    $insertion = FunctionsWS::addSaisieVente($json_vente, $id_profil, $token);

    $response = array();
    if ($insertion == true) {
        $response["success"] = true;
        $response["message"] = "Ajout avec succes des ventes";
    }else {
        $response["success"] = false;
        $response["message"] = "Un problème interne (echo/vardump) ou violation contrainte primary key";
    }

    echo json_encode($response, 201);

});

$app->get('/getTableauAccueilDM', function () use ($app) {

    $id = $app->request->get('id');
    $id_profil = $app->request->get('id_profil');
    $token = $app->request->get('token');

    $tableau = FunctionsWS::getTableauAccueilDM($id, $id_profil, $token);
    //var_dump($tableau);

    echo json_encode($tableau, 201);

});

$app->get('/getTableauAccueilDR', function () use ($app) {

    $id = $app->request->get('id');
    $id_profil = $app->request->get('id_profil');
    $ville = $app->request->get('ville');
    $token = $app->request->get('token');


    $tableau = FunctionsWS::getTableauAccueilDR($id, $id_profil, $ville, $token);
    //var_dump($tableau);

    echo json_encode($tableau, 201);

});

// Run app
$app->run();
