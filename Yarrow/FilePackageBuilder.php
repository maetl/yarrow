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
 * Treats PHP code files as separate packages.
 */
class FilePackageBuilder implements PackageBuilder {

	public function getFromFile($file) {
		return substr(str_replace('.php', '', $file->getRelativePath()), 1);
	}
	
}