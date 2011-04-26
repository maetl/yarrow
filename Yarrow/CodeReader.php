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

class CodeReader {
	
	function __construct() {
		$this->docblocks = array();
		$this->functions = array();
		$this->files = array();
		$this->classes = array();
		$this->currentClass = false;
		$this->currentFunction = false;
	}
	
	function getClasses() {
		return $this->classes;
	}
	
	function getFunctions() {
		return $this->functions;
	}
	
	function onClass($name, $parent=false, $implements=false, $final=false) {
		$this->currentClass = new ClassModel($name, $parent);
	}
	
	function onAbstractClass($name, $parent, $implements) {
		throw new Exception("not implemented");
	}
	
	function onInterface($name, $implements) {
		throw new Exception("not implemented");		
	}
	
	function onClassEnd() {
		$this->classes[] = $this->currentClass;
		$this->currentClass = false;
	}
	
	function onFunction($function, $arguments) {
		$this->currentFunction = new FunctionModel($function, $arguments);		
	}
	
	function onStaticFunction($name, $arguments) {
		$this->currentFunction = new FunctionModel($function, $arguments);
	}

	function onFunctionEnd() {
		// todo: cyclomatic complexity?
		$this->functions[] = $this->currentFunction;
		$this->currentFunction = false;
	}
	
	function onMethod($function, $arguments, $visibility='public', $final=false) {
		$this->currentFunction = new FunctionModel($function, $arguments);
	}
	
	function onStaticMethod($function, $arguments, $visibility='public', $final=false) {
		$this->currentFunction = new FunctionModel($function, $arguments);
	}

	function onMethodEnd() {
		$this->currentClass->addMethod($this->currentFunction);
		$this->currentFunction = false;
	}
	
	function onInstanceProperty($property, $visibility, $default=null) {
		throw new Exception("not implemented");		
	}
	
	function onStaticProperty($property, $visibility, $default=null) {
		throw new Exception("not implemented");		
	}
}