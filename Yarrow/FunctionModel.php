<?php

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