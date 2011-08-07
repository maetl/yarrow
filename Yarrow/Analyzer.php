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
				$collector->excludeByPattern("/\.tpl\.php$/");
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
	 * Look for code organized according to the given package strategy.
	 * Currently locked to PEAR style naming convention only.
	 *
	 * @todo move to strategy classes
	 */
	function getPackageForFile($file) {
		
		$name = basename($file['absolute_path'], '.php');
		$basedir = dirname($file['base_path']);
		$package = str_replace('/', '_', $basedir);
		
		if (is_dir($basedir . '/' . $name)) {
			$package .= '_' . $name;
		}
		
		return PackageModel::create($package);
	}
	
	function getPackageForClass($class) {
		
	}

	/**
	 * Analyze the structure of a single code file.
	 *
	 * @param array manifest list
	 */
	function analyzeFile($file_) {
		$source = file_get_contents($file_['absolute_path']);
		$tokens = token_get_all($source);
		
		$package = $this->getPackageForFile($file_);
		$file = FileModel::create($file_['relative_path']);
		$file->setSource($source);
		$package->addFile($file);
		
		$reader = new CodeReader($package, $file);
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
		
		$file->setFunctions($reader->getFunctions());
		$file->setConstants($reader->getConstants());
	}

	function getModel() {		
		return $this->objectModel;
	}
}