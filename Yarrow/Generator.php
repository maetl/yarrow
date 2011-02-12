<?php

class Generator {
	
	function run($path) {
		$this->analyzeProject($path);
		$this->generateDocs();
	}
	
	function analyzeProject($path) {
		
		$collector = new FileCollector($path);
		$analyzer = new Analyzer();
		
		
		foreach($collector->getManifest() as $file) {
			$analyzer->analyzeFile($file['absolute_path']);
		}
		
		print_r($analyzer->classes);
		
	}
	
	function generateDocs() {
		// not implemented
	}
	
}