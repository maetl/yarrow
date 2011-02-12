<?php

class FileCollector {
	private $base_path;
	private $base_dir;
	private $collection;
	
	function __construct($path) {
		$this->base_path = $path;
		$this->base_dir = basename($path);
		$this->collection = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path), true);
	}
	
	function getProjectMap() {
		$map = array();
		foreach($this->collection as $file) {
			$map[] = array(
				"filename" => $file->getFilename(),
				"relative_path" => $this->base_dir . str_replace($this->base_path, '', $file->getPathname()),
				"absolute_path" => $file->getRealPath()
			);
		}
		return $map;
	}
	
}