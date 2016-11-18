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
            $user = User::where('LOWER(MAIL)', strtolower(trim($_SESSION['USER_MAIL'])))
			->where('PASSWORD', $_SESSION['USER_MDP'])
			->find_one();
            if (is_object($user)) {
                return $user;
            }

            return false;
        }
    
    }
    
    public static function getProfil($token){
        
        if($_SESSION['TOKEN'] == $token){
            $profil = Profil::where('ID_PROFIL', $_SESSION['USER_ID_PROFIL'])->find_one();
            return $profil;
        }
        
    }
    
    public static function getSelect_temps($token){
        if($_SESSION['TOKEN'] == $token){
            ORM::configure('return_result_sets', true);
            $stack = array();
            $select_temps = ORM::for_table('select_temps')->find_many();
            $select_cumul = ORM::for_table('select_cumul')->find_many();
            $select_famille_produit = ORM::for_table('select_famille_produit')->find_many();
            $select_indicateur = ORM::for_table('select_indicateur')->find_many();
            array_push($stack, $select_temps, $select_cumul, $select_famille_produit, $select_indicateur);
            return $stack; 
        }
    }
    
    public static function getTableauAccueilDM($token/*, $code_select_temps, $code_select_cumul, $code_select_indicateur*/){
        
        if($_SESSION['TOKEN'] == $token){
            
            $profil = Profil::where('ID_PROFIL', $_SESSION['USER_ID_PROFIL'])->find_one();
            
            foreach($profil as $record){
                $code_select_zone_geo = explode(" ", $record->LIB_PROFIL)[1];
                $id_zone = $record->ID_ZONE;
            }
            
            $code_select_devise=1;
            
            $code_select_cours=1;
            
            $enseigne = ORM::for_table('dim_magasin_star')->where('ID_MAGASIN', $id_zone)->find_one();
            $code_select_enseigne = $enseigne->LIB_ENSEIGNE;
            echo $code_select_enseigne;
            
            
        }
        
    }

    


}