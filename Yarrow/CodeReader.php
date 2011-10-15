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

/**
 * Event driven parser callbacks to build a code model.
 */
class CodeReader {
	private $currentPackage;
	private $currentFile;
	private $currentClass;
	private $currentFunction;
	private $docblocks;
	private $functions;
	private $files;
	private $constants;
	private $parsePrivate;

	/**
	 * @param PackageModel $package
	 * @param FileModel $file
	 */
	function __construct($package, $file, $pp=false) {
		$this->currentPackage = $package;
		$this->currentFile = $file;
		$this->currentClass = false;
		$this->currentFunction = false;		
		$this->docblocks = array();
		$this->functions = array();
		$this->files = array();
		$this->constants = array();
		$this->parsePrivate = $pp;
	}

	function getFunctions() {
		return $this->functions;
	}

	function getConstants() {
		return $this->constants;
	}

	function onFileHeader($comment) {
		$docblock = new DocblockParser($comment);
		$this->currentFile->addDocblock($docblock->parse());
	}
	
	function onDocblock($comment) {
		$docblock = new DocblockParser($comment);
		$this->docblocks[] = $docblock->parse();
	}

	function onClass($name, $parent, $keywords) {
		$this->currentClass = ClassModel::create($name, $parent, $keywords);
		$docblock = array_pop($this->docblocks);
		if ($docblock) $this->currentClass->addDocblock($docblock);
	}

	function onClassEnd() {
		$this->currentPackage->addClass($this->currentClass);
		$this->currentFile->addClass($this->currentClass);
		$this->currentClass = false;
	}

	function onConstant($name, $value) {
		$constant = new ConstantModel($name, $value);
		if ($this->currentClass) {
			$this->currentClass->addConstant($constant);
		} else {
			$this->constants[] = $constant;
		}
	}

	function onProperty($name, $keywords=array(), $default=false) {
		$property = new PropertyModel($name, $keywords, $default);
		if ($this->parsePrivate || !$property->isPrivate()) {
			$this->currentClass->addProperty($property);
		}
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

	/**
	 * End of method parsing event.
	 *
	 * Pushes current method object onto the current class. Ignores private methods,
	 * unless explicitly specified.
	 */
	function onMethodEnd() {
		if ($this->parsePrivate || !$this->currentFunction->isPrivate()) {
			$this->currentClass->addMethod($this->currentFunction);
		}
		$this->currentFunction = false;
	}
}