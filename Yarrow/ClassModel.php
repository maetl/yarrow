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
	private $ancestor;
	private $functions;
	private $docblock;
	private $file;
	private $isInterface;
	private $isAbstract;
	private $isFinal;
	private $implements;
	
	/**
	 * Base type for all PHP classes
	 */
	const BASE_TYPE = 'stdClass';
	
	function __construct($name, $extends=self::BASE_TYPE, $keywords=array()) {
		$this->name = $name;
		$this->ancestor = $extends;
		$this->functions = array();
		$this->isInterface = (isset($keywords['interface']));
		$this->isAbstract =  (isset($keywords['abstract']));
		$this->isFinal =  (isset($keywords['final']));
		$this->implements = (isset($keywords['interface'])) ? $keywords['interface'] : false;
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
		return $this->ancestor;
	}
	
	function addDocBlock($docblock) {
		$this->docblock = $docblock;
	}
	
	function addMethod($function) {
		$this->functions[] = $function;
	}

	function setFile($file) {
		$this->file = $file;
	}
	
	function getFile() {
		return $this->file;
	}
	
	function getText() {
		if ($this->docblock) return $this->docblock->getText();
	}
	
	function getSummary() {
		if ($this->docblock) return $this->docblock->getSummary();
	}
	
	function getMethods() {
		return $this->functions;
	}
	
	function getDoc() {
		return $this->docblock;
	}
	
	function methodCount() {
		return count($this->functions);
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