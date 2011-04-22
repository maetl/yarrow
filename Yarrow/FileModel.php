<?php

class FileModel {
	private $filename;
	private $classes;
	private $functions;

	function __construct($filename) {
		$this->filename = $filename;
		$this->classes = array();
		$this->functions = array();
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