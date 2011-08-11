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
	private $objectModel;
	private $config;
	private $packageBuilder;

	function __construct() {
		$this->objectModel = new ObjectModel();
		$this->config = Configuration::instance();
		$packageBuilder = ucfirst($this->config->options['packageStyle']) . 'PackageBuilder';
		$this->packageBuilder = new $packageBuilder();
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
				$manifest[] = new FileListing($target, basedir($target));
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
	 *
	 * @param array $file file object from collector mess
	 */
	function getPackageFromFile($file) {
		$package = $this->packageBuilder->getFromFile($file);
		return PackageModel::create($package);
	}

	/**
	 * Analyze the structure of a single code file.
	 *
	 * @param array manifest list
	 */
	function analyzeFile($file_) {
		$source = file_get_contents($file_->getAbsolutePath());
		$tokens = token_get_all($source);
		
		$package = $this->getPackageFromFile($file_);
		$file = FileModel::create($file_->getRelativePath());
		$file->setSource($source);
		$package->addFile($file);
		
		$reader = new CodeReader($package, $file);
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
		
		$file->setFunctions($reader->getFunctions());
		$file->setConstants($reader->getConstants());
	}

	/**
	 * Returns the complete code model.
	 */
	function getModel() {		
		return $this->objectModel;
	}
}