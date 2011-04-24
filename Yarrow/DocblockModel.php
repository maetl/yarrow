<?php
/**
 * Yarrow
 * Simple Documentation Generator
 * <http://yarrowdoc.org>
 *
 * Copyright (c) 2010-2011, Mark Rickerby <http://maetl.net>
 * All rights reserved.
 * 
 * This library is free software; refer to the terms in the LICENSE file found
 * with this source code for details about modification and redistribution.
 */

class DocblockModel {
	private $source;
	
	function __construct($docblock) {
		$this->source = $docblock;
	}
	
}