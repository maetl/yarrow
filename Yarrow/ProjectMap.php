<?php

class ProjectMap {
	private $class_map;
	
	function __construct() {
		$this->class_map = array();
	}
	
	function addClass($class) {
		$this->class_map = $class;
	}
	
}