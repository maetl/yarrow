<?php

class CodeListener {
	
	function __construct() {
		$this->model = new ObjectModel();
	}
	
	function addFile($filename) {
		$this->model->addFile(new FileModel($filename));
	}
	
	function addDocblock($docblock) {
	}
	
	function addComment() {
		
	}
	
	function addClass($class) {
		$this->classes[] = $class;
	}
	
	function addFunction() {
		
	}
	
}