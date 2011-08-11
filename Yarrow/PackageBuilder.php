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
 * Interface for classes that resolve package names based on collected input.
 */
interface PackageBuilder {
	
	/**
	 * Get a package name based on a file path.
	 *
	 * @param string path to a code file
	 * @return string package name
	 */
	public function getFromFile($file);
	
}