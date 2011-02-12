<?php

class FileCollector {
	private $iterator;
	private $base_path;
	
	function __construct($path) {
		$this->base_path = $path;
		$this->base_dir = basename($path);
		$this->iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path), true);
	}
	
	function getProjectMap() {
		$map = array();
		foreach($this->iterator as $file) {
			$map[] = $this->base_dir . str_replace($this->base_path, '', $file);
		}
		return $map;
	}
	
}