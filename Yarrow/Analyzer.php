<?php

/**
 * Intends to analyze a file, yes.
 */
class Analyzer {

	public function __construct() {
	}

	/**
	 * Analyze the structure of a single code file.
	 */
	function analyzeFile($filename) {
		$tokens = token_get_all(file_get_contents($filename));
		
		$listener = new CodeListener();
		
		$parser = new CodeParser($tokens, $listener);
		$parser->parse();

		$this->classes = $parser->classes;
		$this->globals = $parser->globals;
	}
}