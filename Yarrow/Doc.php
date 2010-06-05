<?php
require_once 'Analyzer.php';
require_once 'Writer.php';

class DocFunction {
	private $name;
	private $args;
	
	function __construct($name) {
		$this->name = $name;
		$this->args = array();
	}
	
	function addArgument($argvar) {
		$this->args[] = $argvar;
	}
	
	function __toString() {
		return $this->name;
	}
	
}