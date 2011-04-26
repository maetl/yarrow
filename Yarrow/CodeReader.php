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
	
	function onDocComment($comment) {
		$docblock = new DocblockParser($comment);
		$this->docblocks[] = $docblock->parse();
	}
	
	function onClass($name, $parent=false, $implements=false, $final=false) {
		$this->currentClass = new ClassModel($name, $parent);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentClass->addDocblock($docblock);
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
	
	function onFunction($name, $arguments) {
		$this->currentFunction = new FunctionModel($name, $arguments);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentFunction->addDocblock($docblock);
	}
	
	function onStaticFunction($name, $arguments) {
		$this->currentFunction = new FunctionModel($name, $arguments);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentFunction->addDocblock($docblock);		
	}

	function onFunctionEnd() {
		// todo: cyclomatic complexity?
		$this->functions[] = $this->currentFunction;
		$this->currentFunction = false;
	}
	
	function onMethod($name, $arguments, $visibility='public', $final=false) {
		$this->currentFunction = new FunctionModel($name, $arguments);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentFunction->addDocblock($docblock);		
	}
	
	function onStaticMethod($name, $arguments, $visibility='public', $final=false) {
		$this->currentFunction = new FunctionModel($name, $arguments);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentFunction->addDocblock($docblock);		
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