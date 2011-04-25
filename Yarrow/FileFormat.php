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
 * Provides a common interface for loading data from particular file formats.
 */
interface FileFormat {

	/**
	 * Convert file in given format to PHP data values.
	 *
	 * @param string $file Path to file
	 * @return array PHP representation of data
	 */
	public static function load($file);
	
	/**
	 * Convert PHP data into formatted string.
	 *
	 * @param array $input PHP data to convert
	 * @return string Result string in given format
	 */
	public static function encode($input);
	
	/**
	 * Convert string in given format to PHP data values.
	 *
	 * @param string $input formatted content to convert
	 * @return array PHP representation of data
	 */
	public static function decode($input);
}