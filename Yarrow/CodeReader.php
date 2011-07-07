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
		$this->registry = new CodeRegistry();
	}
	
	function getClasses() {
		return $this->registry->getClasses();
	}
	
	function getFunctions() {
		return $this->functions;
	}
	
	function onDocComment($comment) {
		$docblock = new DocblockParser($comment);
		$this->docblocks[] = $docblock->parse();
	}
	
	function onClass($name, $parent, $keywords) {
		$this->currentClass = new ClassModel($name, $parent, $keywords);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentClass->addDocblock($docblock);
	}
	
	function onClassEnd() {
		$this->classes[] = $this->currentClass;
		$this->registry->addClass($this->currentClass);
		$this->currentClass = false;
	}
	
	function onConstant($name, $value) {
		$constant = new ConstantModel($name, $value);
		$this->currentClass->addConstant($constant);
	}
	
	function onProperty($name, $keywords=array(), $default=false) {
		$property = new PropertyModel($name, $keywords, $default);
		$this->currentClass->addProperty($property);
	}
	
	function onFunction($name, $arguments, $keywords=array()) {
		$this->currentFunction = new FunctionModel($name, $arguments, $keywords);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentFunction->addDocblock($docblock);
	}

	function onFunctionEnd() {
		// todo: cyclomatic complexity?
		$this->functions[] = $this->currentFunction;
		$this->currentFunction = false;
	}
	
	function onMethod($name, $arguments, $keywords=array()) {
		$this->currentFunction = new MethodModel($name, $arguments, $keywords);
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