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

class FileModel extends CodeModel {
	private $filename;
	private $classes;
	private $functions;
	private $source;
	private $header;

	function __construct($filename) {
		$this->filename = $filename;
		$this->classes = array();
		$this->functions = array();
		$this->constants = array();
	}
	
	public static function create($filename) {
		return CodeRegistry::createFile($filename);
	}

	public function addDocblock($docblock) {
		$this->header = $docblock;
	}

	public function getName() {
		return $this->filename;
	}
	
	public function getPath() {
		return dirname($this->filename);
	}

	function getBaseLinkPrefix() {
		$relativeLink = $this->getRelativeLink();
		return str_repeat('../', substr_count($relativeLink, '/'));
	}

	function getRelativeLink() {
		return strtolower(str_replace(' ', '/', str_replace('.php', '.html', (string)$this)));
	}

	function getSource() {
		return $this->source;
	}

	function setSource($code) {
		$this->source = $code;
	}

	function getClasses() {
		return $this->classes;
	}

	function getFunctions() {
		return $this->functions;
	}

	function setFunctions($functions) {
		$this->functions = $functions;
		foreach($this->functions as $func) {
			if ($func) $func->setFile($this);
		}
	}

	function setConstants($constant) {
		$this->constants[] = $constant;
	}

	function addClass($class) {
		if ($class) {
			$this->classes[] = $class;
			$class->setFile($this);			
		}
	}

	function addFunction($function) {
		$this->functions[] = $function;
	}

	function __toString() {
		return "File " . $this->filename;
	}
}