<?php

abstract class Generator {
	
	protected $directory;
	
	protected $objectModel;
	
	/**
	 * @param $target string path to target directory
	 * @param $model object model from analysis
	 */
	public function __construct($target, $model) {
		//$target = full_path_convert($target);
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
		if (!is_dir($target)) mkdir($target);
	}
	
	private function writeFile($filename, $content) {
		$fullpath = $this->directory . '/' . $filename . $this->getFileExtension();
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
		return strtolower(str_replace(' ', '-', str_replace('.php', '', $object)));
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
		
		foreach ($objectMap as $index => $objects) {
			foreach ($objects as $object) {
				$objectKey = ucfirst($index);
				$variables = array(
								$objectKey    => $object,
								'ObjectModel' => $this->objectModel
							 );
				$content = $converter->render($templates[$index], $variables);
				$filename = $this->convertToFilename($object);
				$this->writeFile($filename, $content);
			}
		}
	}
}