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

class ClassModel {
	private $name;
	private $ancestor;
	private $functions;
	private $docblock;
	
	/**
	 * Base type for all PHP classes
	 */
	const BASE_TYPE = 'stdClass';
	
	function __construct($name, $ancestor=self::BASE_TYPE) {
		$this->name = $name;
		$this->ancestor = $ancestor;
		$this->functions = array();
	}
	
	function addDocBlock($docblock) {
		$this->docblock = $docblock;
	}
	
	function addFunction($function) {
		$this->functions[] = $function;
	}
	
	function getDoc() {
		return $this->docblock;
	}
	
	function methodCount() {
		return count($this->functions);
	}
	
	function __toString() {
		return 'Class ' . $this->name;
	}
}