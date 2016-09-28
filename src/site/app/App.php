<?php

namespace App;

Class App extends \Slim\Slim {

    public function render($template, $data = array(), $status = null) {
        $data = array_merge($data, array(
			'urlPath' => $this->urlPath,
			'user' => $this->user,
		));
		
        return parent::render($template, $data, $status);
    }
}
