<?php

/**
 * Intends to analyze a file, yes.
 */
class Analyzer {

	/**
	 * Base type for all PHP classes
	 */
	const PHP_stdClass = 'stdClass';

	public function __construct() {
	}

	/**
	 * Analyze the structure of a single code file.
	 */
	function analyzeFile($filename) {
		$tokens = token_get_all(file_get_contents($filename));
		
		$parser = new CodeParser($tokens);
		$parser->parse();

		$this->classes = $parser->classes;
	}
}