<?php

namespace App;

class Token extends Model
{
	
    public static function connect($login, $password){
        $user = User::where('LOWER(MAIL)', strtolower(trim($login)))
			->where('PASSWORD', $password)
			->find_one();

		if (is_object($user)) {
            
            session_start();
            
            $_SESSION['USER_ID'] = $user->ID;
            $_SESSION['USER_MDP'] = $user->PASSWORD;
            $_SESSION['USER_NOM'] = $user->NOM;
            $_SESSION['USER_PRENOM'] = $user->PRENOM;
            $_SESSION['USER_USERNAME'] = $user->USERNAME;
            $_SESSION['USER_MAIL'] = $user->MAIL;
            $_SESSION['USER_ID_PROFIL'] = $user->ID_PROFIL;
            $_SESSION['USER_DATEMAJ_USER'] = $user->DATEMAJ_USER;
            $_SESSION['TIMESTAMP'] = date("Y-m-d H:i:s"); 

            $string = "";
            $chaine = "a0b1c2d3e4f5g6h7i8j9klmnpqrstuvwxy123456789";
            srand((double)microtime()*1000000);
            for($i=0; $i<10; $i++){
                $string .= $chaine[rand()%strlen($chaine)];
            }
            
            $_SESSION['TOKEN'] = $string;
               
			return $user;
		}
		
		return false;
    }
    
    public static function getToken(){
        $user = User::where('LOWER(MAIL)', strtolower(trim($_SESSION['USER_MAIL'])))
			->where('PASSWORD', $_SESSION['USER_MDP'])
			->find_one();
        if (is_object($user)) {
            return $user;
        }
        
        return false;
    }
    
    
    public static function updatePasswd($token, $passwd){
        
        if($_SESSION['TOKEN'] == $token){
            $_SESSION['USER_MDP'] = $passwd;
            $user = ORM::for_table('utilisateur')->select('id')->find_one($_SESSION['USER_ID']);
            $user->set('password', $passwd);
            $user->save();
            
        }
        
    }
    
    public static function getUser($token){
        
        if($_SESSION['TOKEN'] == $token){
            return $_SESSION['USER_ID'];
        }
        
    }
    
    public static function getProfil($token){
        
        if($_SESSION['TOKEN'] == $token){
            return $_SESSION['USER_ID_PROFIL'];
        }
        
    }
    
    public static function getTableauAccueilDM($token, $code_select_temps, $code_select_cumul, $code_select_indicateur){
        
        if($_SESSION['TOKEN'] == $token){
            $params['I_DEVISE'] = 0;
            $app = App::getInstance();
            $id = '1';
            $db = ORM::get_db();

            $enseigne = $params['I_ENSEIGNE'];
            $temps = $params['I_TEMPS'];
            $geo = $params['I_REGION'];
            echo $enseigne;
            echo $temps;
            echo $geo;
        }
        
    }

    


}