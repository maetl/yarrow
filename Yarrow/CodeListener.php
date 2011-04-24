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