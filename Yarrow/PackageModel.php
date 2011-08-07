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
 * Represents a package, namespace, or code module, which may depend on the
 * particular conventions used by a project.
 */
class PackageModel extends CodeModel {
	private $name;
	private $classes;
	
	function __construct($name) {
		$this->name = $name;
		$this->classes = array();
		$this->functions = array();
		$this->constants = array();
		$this->files = array();
	}
	
	public static function create($name) {
		return CodeRegistry::createPackage($name);
	}
	
	public function getName() {
		return $this->name;
	}
	
	function addFile($file) {
		$this->files[] = $file;
	}

	function addClass($class) {
		if ($class) {
			$this->classes[] = $class;
			$class->setPackage($this);
		}
	}

	function addFunction($function) {
		$this->functions[] = $function;
	}

	function addConstant($constant) {
		$this->constants[] = $constant;
	}

	function __toString() {
		return 'Package ' . $this->name;
	}

	function getClasses() {
		return $this->classes;
	}	
	
}