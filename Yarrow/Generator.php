<?php

abstract class Generator {
	
	private $directory;
	
	private $objectModel;
	
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
}