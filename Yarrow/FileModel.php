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

class FileModel {
	private $filename;
	private $classes;
	private $functions;
	private $source;

	function __construct($filename) {
		$this->filename = $filename;
		$this->classes = array();
		$this->functions = array();
	}
	
	function getSource() {
		return $this->source;
	}
	
	function setSource($code) {
		$this->source = $code;
	}
	
	function getClasses() {
		return $this->classes;
	}
	
	function setClasses($classes) {
		$this->classes = $classes;
	}
	
	function setFunctions($functions) {
		$this->functions = $functions;
	}
	
	function addClass($class) {
		$this->classes[] = $class;
	}
	
	function addFunction($function) {
		$this->functions[] = $function;
	}
	
	function __toString() {
		return "File " . $this->filename;
	}
	
}