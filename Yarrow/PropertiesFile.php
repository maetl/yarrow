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

/**
 * Parses a subset of the Java style .properties format, similar to .ini files.
 *
 * @todo rename to Settings (.settings)
 * @todo document file format
 */
class PropertiesFile {
	
	/**
	 * Loads .properties file into a PHP array.
	 *
	 * @param string $file Path to file
	 * @return array PHP representation of data
	 */
	public static function load($file) {
		if (is_file($file)) {
			$input = file_get_contents($file);
			return self::decode($input);
		} else {
			throw new ConfigurationError("File not found: $file");
		}
	}
	
	/**
	 * Convert string in .properties format to PHP data values.
	 *
	 * @param string $input content to convert
	 * @return array PHP representation of data
	 */	
	public static function decode($input) {
		$properties = new PropertiesParser($input);
		return $properties->parse();		
	}	
}