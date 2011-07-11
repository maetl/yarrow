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
			if (is_dir($target)) {
				$collector = new FileCollector($target);
				$collector->includeByPattern("/\.php$/");
				$manifest = array_merge($manifest, $collector->getManifest());
			} elseif (is_file($target)) {
				$manifest[] = array(
					'filename' => basename($target),
					'relative_path' => $target,
					'absolute_path' => realpath($target)
				);
			} else {
				throw new Yarrow_Exception("$target path not found.");
			}
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

		$reader = new CodeReader();

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();

		$file = new FileModel($file['relative_path']);
		$file->setSource($source);
		$file->setClasses($reader->getClasses());
		$file->setFunctions($reader->getFunctions());
		$file->setConstants($reader->getConstants());

		foreach($reader->getClasses() as $class) {
			$this->objectModel->addClass($class);
		}
		foreach($reader->getFunctions() as $func) {
			$this->objectModel->addFunction($func);
		}
		foreach($reader->getConstants() as $const) {
			$this->objectModel->addConstant($const);
		}
		$this->objectModel->addFile($file);
	}

	function getModel() {
		return $this->objectModel;
	}
}