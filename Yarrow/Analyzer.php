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