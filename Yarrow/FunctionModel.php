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

class FunctionModel extends CodeModel {
	private $name;
	private $docblock;
	private $arguments;
	private $file;
	
	function __construct($name, $arguments=array()) {
		$this->name = $name;
		$this->arguments = $arguments;
	}
	
	function addDocBlock($docblock) {
		$parser = new DocblockParser($docblock);
		$this->docblock = $parser->parse();
	}
	
	function setFile($file) {
		$this->file = $file;
	}
	
	public function getName() {
		return $this->name;
	}
	
	function addArgument($argvar) {
		$this->args[] = $argvar;
	}
	
	function getArguments() {
		return $this->args;
	}
	
	function getText() {
		if ($this->docblock) return $this->docblock->getText();
	}
	
	function getSummary() {
		if ($this->docblock) return $this->docblock->getSummary();
	}
	
	function getRelativeLink() {
		return strtolower(str_replace(' ', '/', str_replace('.php', '.html', (string)$this)));
	}	
	
	function __toString() {
		return "Function " . $this->name;
	}
}