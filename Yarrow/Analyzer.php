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
	 * Just shreds a PHP token stream for dockblocks in a single namespace.
	 *
	 * Attaches a docblock, class and method count.
	 */
	function analyzeFile($filename) {
		$tokens = token_get_all(file_get_contents($filename));
		
		$parser = new CodeParser($tokens);
		$parser->parse();

		$this->classes = $parser->classes;
	}
}