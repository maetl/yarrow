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

class FunctionModel {
	private $name;
	private $args;
	private $docblock;
	
	function __construct($name) {
		$this->name = $name;
		$this->args = array();
	}
	
	function addDocBlock($docblock) {
		$this->docblock = $docblock;
	}
	
	function addArgument($argvar) {
		$this->args[] = $argvar;
	}
	
	function __toString() {
		return $this->name;
	}
}