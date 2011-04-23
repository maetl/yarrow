<?php

class ObjectModel {
	
	function __construct($name='Default') {
		$this->name = $name;
		$this->classes = array();
		$this->functions = array();
		$this->files = array();
	}
	
	function addFile($file) {
		$this->files[] = $file;
	}
	
	function addClass($class) {
		$this->classes[] = $class;
	}
	
	function addFunction($function) {
		$this->functions[] = $function;
	}
	
	function __toString() {
		return $this->name . " " . $this->filename;
	}
	
	/**
	 * A list of all the classes collected in the project
	 */
	function getClasses() {
		return $this->classes;
	}
	
	/**
	 * A list of all the PHP code files collected in the project
	 */
	function getFiles() {
		return $this->files;
	}
}