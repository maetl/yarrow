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
 * 
 */
class PearPackageBuilder implements PackageBuilder {
	
	public function getFromFile($file) {
		$name = basename($file['absolute_path'], '.php');
		$basedir = dirname($file['base_path']);
		$package = str_replace('/', '_', $basedir);

		if (is_dir($basedir . '/' . $name)) {
			$package .= '_' . $name;
		}	
		return $package;	
	}
}