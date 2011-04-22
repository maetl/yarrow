<?php

class Yarrow_Autoload {
	
	public static function loadClassFile($class) {
		$file = $class . '.php';
		//$file = str_replace('_', '/', $class) . '.php';
		if (file_exists('Yarrow/'. $file)) {
			require_once $file;
		}
	}
}

spl_autoload_register(array('Yarrow_Autoload', 'loadClassFile'));