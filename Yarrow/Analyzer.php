<?php

/**
 * Intends to analyze a file, yes.
 */
class Analyzer {

	/**
	 * Public: Port of constructor from test case
	 */
	public function __construct() {
		$this->docblocks = array();
		$this->classes = array();
		$this->ancestors = array();
		$this->functions = array();
	}

	/**
	 * Just shreds a PHP token stream for blockblocks in a single namespace.
	 *
	 * Attaches a docblock, class and method count.
	 */
	function analyzeFile($filename) {
		$t = token_get_all(file_get_contents($filename));
		$total = count($t);
		
		for ($i = 0; $i < $total; $i++) {
			if (is_string($t[$i])) continue;
			list($token, $value) = $t[$i];
			switch ($token) {
				case T_DOC_COMMENT: {
					$this->docblocks[] = $t[$i][1];
				}
				break;

				case T_CLASS: {
					$this->classes[] = $t[$i+2][1];
					if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_EXTENDS) {
						$parent = "";
						while (is_array($t[$i+1]) && $t[$i+1][0] !== T_WHITESPACE) {
						   $parent .= $t[++$i][1];
						}
					} else {
						$parent = false;
					}
					if ($parent) $this->ancestors[$t[$i+2][1]] = $parent;
				}
				break;
				
				case T_FUNCTION: {
					$this->functions[] = $t[$i+2][1];
				}
			}
		}
	}
	
}