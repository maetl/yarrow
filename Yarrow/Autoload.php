<?php
/**
 * Yarrow {{version}}
 * Simple Documentation Generator
 * <http://yarrowdoc.org>
 *
 * Copyright (c) 2010-2011, Mark Rickerby <http://maetl.net>
 * All rights reserved.
 * 
 * This library is free software; refer to the terms in the LICENSE file found
 * with this source code for details about modification and redistribution.
 */

// remove this when migration to PEAR
// naming convention is complete
require_once 'Exception.php';

class Yarrow_Autoload {
	
	public static function getClassPath() {
		return dirname(__FILE__) . DIRECTORY_SEPARATOR;
	}
	
	public static function loadClassFile($class) {
		$file = $class . '.php';
		//$file = str_replace('_', '/', $class) . '.php';
		if (file_exists(self::getClassPath() . $file)) {
			require_once self::getClassPath() . $file;
		}
	}
}

spl_autoload_register(array('Yarrow_Autoload', 'loadClassFile'));