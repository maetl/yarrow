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
 * Output converter, creates a generator and template converter, and
 * builds the final documentation output.
 */
class Converter {
	
	public function __construct() {
		$this->config = Configuration::instance();
	}
	
}