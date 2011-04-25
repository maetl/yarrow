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
 * Intends to analyze a file, yes.
 */
class Analyzer {
	
	function __construct() {
		$this->objectModel = new ObjectModel();
		$this->config = Configuration::instance();
	}

	function analyzeProject() {
		$manifest = array();
		
		foreach($this->config->inputTargets as $target) {
			$collector = new FileCollector($target);
			$collector->includeByPattern("/\.php$/");
			$manifest = array_merge($manifest, $collector->getManifest());
		}
		
		foreach($manifest as $file) {
			$this->analyzeFile($file);
		}
	}

	/**
	 * Analyze the structure of a single code file.
	 *
	 * @param array manifest list
	 */
	function analyzeFile($file) {
		$source = file_get_contents($file['absolute_path']);
		$tokens = token_get_all($source);
		
		// hackety hack to get working end to end
		// this code is currently a mess, but is just
		// used for testing and experimenting with
		// different ways of building a code model
		
		$listener = new CodeListener();
		
		$parser = new CodeParser($tokens, $listener);
		$parser->parse();
		
		$file = new FileModel($file['relative_path']);
		$file->setSource($source);
		$file->setClasses($parser->classes);
		$file->setFunctions($parser->globals);
		
		foreach($parser->classes as $class) {
			$this->objectModel->addClass($class);
		}
		foreach($parser->globals as $func) {
			$this->objectModel->addFunction($func);
		}
		
		$this->objectModel->addFile($file);
	}
	
	function getModel() {
		return $this->objectModel;
	}
}