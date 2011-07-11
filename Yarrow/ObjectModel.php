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

class ObjectModel extends CodeModel {

	function __construct($name='Default') {
		$this->name = $name;
		$this->classes = array();
		$this->functions = array();
		$this->constants = array();
		$this->files = array();
	}

	public function getName() {
		return $this->name;
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

	function addConstant($constant) {
		$this->constants[] = $constant;
	}

	function __toString() {
		return $this->name . " " . $this->filename;
	}

	function classCount() {
		return count($this->classes);
	}

	function functionCount() {
		return count($this->functions);
	}

	/**
	 * A list of all the global functions collected in the project
	 */
	function getFunctions() {
		return $this->functions;
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