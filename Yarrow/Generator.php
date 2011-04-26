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

abstract class Generator {
	
	protected $directory;
	
	protected $objectModel;
	
	/**
	 * @param $target string path to target directory
	 * @param $model object model from analysis
	 */
	public function __construct($target, $model) {
		$this->ensureDirectoryExists($target);
		$this->directory = $target;
		$this->objectModel = $model;
		$this->validateTemplateMethods();
	}
	
	/**
	 * Validate the template methods provided by the subclass.
	 */
	private function validateTemplateMethods() {
		$templateIndex = array_keys($this->getTemplateMap());
		$objectIndex = array_keys($this->getObjectMap());
		
		if ($templateIndex != $objectIndex) {
			throw new ConfigurationError("getTemplateMap and getObjectMap must provide matching keys.");
		}
	}
	
	private function ensureDirectoryExists($target) {
		if (!is_dir($target)) mkdir($target, 0777, true);
	}
	
	private function writeFile($filename, $content) {
		$fullpath = $this->directory . '/' . $filename . $this->getFileExtension();
		$this->ensureDirectoryExists(dirname($fullpath));
		file_put_contents($fullpath, $content);
	}
	
	/**
	 * File extension of generated documentation. Defaults to '.html'.
	 */
	protected function getFileExtension() {
		return '.html';
	}
	
	/**
	 * Convert a model object to a filename.
	 */
	protected function convertToFilename($object) {
		return strtolower(str_replace(' ', '-', str_replace('.php', '', str_replace('/', '-', $object))));
	}
	
	/**
	 * Return an instance of the template converter provided by the generator.
	 */
	abstract protected function getConverter();
	
	/**
	 * Return a mapping between template types and provided object model
	 */
	abstract protected function getObjectMap();
	
	/**
	 * Return a mapping between template types and provided output templates.
	 */
	abstract protected function getTemplateMap();
	
	/**
	 * Generates documentation from template methods provided by subclass.
	 */
	public function makeDocs() {
		$converter = $this->getConverter();
		$templates = $this->getTemplateMap();
		$objectMap = $this->getObjectMap();
		$config	   = Configuration::instance();
		
		foreach ($objectMap as $index => $objects) {
			foreach ($objects as $object) {
				$variables = array(
								'meta'		  => $config->meta,
								$index   	  => $object,
								'objectModel' => $this->objectModel
							 );
				$content = $converter->render($templates[$index], $variables);
				$filename = $this->convertToFilename($object);
				$this->writeFile($filename, $content);
			}
		}
	}
}