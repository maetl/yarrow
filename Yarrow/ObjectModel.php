<?php

class ObjectModel {
	
	function __construct() {
		//
	}
	
}

class ClassModel {
	private $name;
	private $ancestor;
	private $functions;
	private $docblock;
	
	function __construct($name, $ancestor) {
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
	
	function __toString() {
		return $this->name;
	}
}

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