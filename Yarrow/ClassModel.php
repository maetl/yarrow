<?php

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
	
	function methodCount() {
		return count($this->functions);
	}
	
	function __toString() {
		return $this->name;
	}
}