<?php

namespace App;

class Profil extends Model
{
	public static $_table = 'profil';
	public static $_id_column = 'ID_PROFIL';
}

class User extends Model
{
	public static $_table = 'utilisateur';
	public static $_id_column = 'ID';
	public static $instance;

	public function profil() {
		static $profil = null;
		
		if (is_null($profil)) {
			$profil = Profil::where('ID_PROFIL', $this->ID_PROFIL)->find_one();
		}
        
		return $profil;
    }
	
	public function isAdmin() {
		return $this->profil()->LIB_PROFIL == 'Administrateur';
	}
	
	public function isDirecteurRegional() {
		return $this->profil()->TYPE_ZONE == 1;
	}
	
	
	public function isDirecteurMagasin() {
		return $this->profil()->TYPE_ZONE == 2;
	}

	
	public function isDirecteurCommercial() {
		return $this->profil()->TYPE_ZONE == 3;
	}
	
	public function posteLibelle() {
		return $this->profil()->LIB_PROFIL;
	}
	
	
	public static function isLogged() {
		return isset(static::$instance->ID);
	}
	
	
	public static function login($email, $mdp) {

		$user = User::where('LOWER(MAIL)', strtolower(trim($email)))
			->where('PASSWORD', $mdp)
			->find_one();

		if (is_object($user)) {
			$app = App::getInstance();
			
			$app->setCookie('USER_ID', $user->ID, '1 days');
			$app->setCookie('USER_MDP', md5($user->PASSWORD), '1 days');
			
			static::$instance=$user;
			return $user;
		}
		
		return false;
		// estelle.bernier@darties.com
		// CJ62hy9
		//SELECT * FROM UTILISATEUR U LEFT JOIN PROFIL P ON U.ID_PROFIL = P.ID_PROFIL WHERE LOWER(U.MAIL) = 'estelle.bernier@darties.com' AND U.PASSWORD = 'CJ62hy9';
	}
	
	
	public static function logout() {
		$app = App::getInstance();
					
		$app->setCookie('USER_ID', '', '-1 days');
		$app->setCookie('USER_MDP', '', '-1 days');
	}
	
	
	public static function loadFromCookie() {
		$app = App::getInstance();
		
		$app->getCookie('USER_ID');
		$app->getCookie('USER_MDP');
		
		$user = User::where('ID', $app->getCookie('USER_ID'))
			//->where('MD5(PASSWORD)', $app->getCookie('USER_MDP'))
			->find_one();
			
		if ($user != false) {
			if (md5($user->PASSWORD) == $app->getCookie('USER_MDP')) {
				static::$instance=$user;
				return $user;
			}
		}
			
		return false;
	}
}