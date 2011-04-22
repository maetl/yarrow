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
	}
	
	private function ensureDirectoryExists($target) {
		if (!is_dir($target)) mkdir($target);
	}
	
	private function writeFile($filename, $content) {
		$fullpath = $this->directory . '/' . $filename . $this->getFileExtension();
		file_put_contents($fullpath, $content);
	}
	
	/**
	 * Return an instance of the template engine to convert object mappings
	 * into an output string.
	 */
	abstract protected function getTemplateEngine();
	
	/**
	 * Return a mapping between template types and provided objects.
	 */
	abstract protected function getTemplateMap();
	
	/**
	 * Return the name of a key template mapping
	 */
	protected function getTemplateName($key) {
		$templates = $this->getTemplateMap();
		return (isset($templates[$key])) ? $templates[$key] : false;	
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
	 * Generates documentation from template methods provided by subclass.
	 */
	public function makeDocs() {
		$template = $this->getTemplateEngine();
		$templates = $this->getTemplateMap();
		
		// todo: better strategy for generating static templates
		if ($indexTemplate = $this->getTemplateName('index')) {
			$variables = array('ObjectModel' => $this->objectModel);
			$content = $template->render($indexTemplate, $variables);
			$this->writeFile('index', $content);
		}
		
		// todo: remove duplication by modifying getTemplateMap to generate its own
		//       template bindings from the given list of objects.
		if ($fileTemplate = $this->getTemplateName('file')) {
			foreach($this->objectModel->getFiles() as $file) {
				$variables = array(
								'File' => $file,
								'ObjectModel' => $this->objectModel
							 );
				$content = $template->render($fileTemplate, $variables);
				$filename = $this->convertToFilename($file);
				$this->writeFile($filename, $content);
			}
		}
		
		// todo: remove duplication by modifying getTemplateMap to generate its own
		//       template bindings from the given list of objects.
		if ($classTemplate = $this->getTemplateName('class')) {
			foreach($this->objectModel->getClasses() as $class) {
				$variables = array(
								'Class' => $class,
								'ObjectModel' => $this->objectModel
							 );
				$content = $template->render($classTemplate, $variables);
				$filename = $this->convertToFilename($class);
				$this->writeFile($filename, $content);
			}
		}
	}
}