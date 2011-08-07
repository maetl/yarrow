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
 * Represents a class type.
 */
class ClassModel extends CodeModel {
	private $name;
	private $ancestors;
	private $methods;
	private $docblock;
	private $file;
	private $package;
	private $isInterface;
	private $isAbstract;
	private $isFinal;
	private $implements;
	private $properties;
	private $constants;
	
	/**
	 * Base type for all PHP classes
	 */
	const BASE_TYPE = 'stdClass';
	
	function __construct($name, $extends=self::BASE_TYPE, $keywords=array()) {
		$this->name = $name;
		$this->ancestors = array($extends);
		$this->methods = array();
		$this->properties = array();
		$this->constants = array();
		$this->isInterface = (isset($keywords['interface']));
		$this->isAbstract =  (isset($keywords['abstract']));
		$this->isFinal =  (isset($keywords['final']));
		$this->implements = (isset($keywords['interface'])) ? $keywords['interface'] : false;
	}
	
	public static function create($name, $extends=self::BASE_TYPE, $keywords=array()) {
		return CodeRegistry::createClass($name, $extends, $keywords);
	}

	public function isInterface() {
		return $this->isInterface;
	}
	
	function isAbstract() {
		return $this->isAbstract;
	}
	
	function isInstantiable() {
		return ($this->isInterface || $this->isAbstract);
	}
	
	function isFinal() {
		return $this->isFinal;
	}
	
	function getAncestor() {
		return implode(', ', $this->ancestors);
	}
	
	function getParent() {
		return $this->getAncestor();
	}
	
	/**
 	 * Represents a class model conflict where multiple classes with the same
 	 * name are declared in a project.
	 *
	 * This will generally happen when classes are defined in conditional logic.
	 *
	 * Because we're analyzing the code statically, we can't process all the
	 * dynamic stuff that happens at runtime, so we just detect an overlapping
	 * class name and add it to the list of ancestors.
	 */
	function addConflict($ancestor) {
		$this->ancestors[] = $ancestor;
	}
	
	function addDocBlock($docblock) {
		$this->docblock = $docblock;
	}
	
	function addMethod($method) {
		$this->methods[] = $method;
	}
	
	function addProperty($property) {
		$this->properties[] = $property;
	}
	
	function addConstant($constant) {
		$this->constants[] = $constant;
	}

	function setFile($file) {
		$this->file = $file;
	}
	
	function getFile() {
		return $this->file;
	}
	
	function setPackage($package) {
		$this->package = $package;
	}
	
	function getPackage() {
		return $this->package;
	}
	
	function getText() {
		if ($this->docblock) return $this->docblock->getText();
	}
	
	function getSummary() {
		if ($this->docblock) return $this->docblock->getSummary();
	}
	
	function getProperties() {
		return $this->properties;
	}
	
	function getMethods() {
		return $this->methods;
	}
	
	function getConstants() {
		return $this->constants;
	}	
	
	function getDoc() {
		return $this->docblock;
	}
	
	function methodCount() {
		return count($this->methods);
	}
	
	public function getName() {
		return $this->name;
	}
	
	function __toString() {
		return 'Class ' . $this->name;
	}
	
	function getRelativeLink() {
		return strtolower(str_replace(' ', '/', str_replace('.php', '.html', (string)$this)));
	}
}