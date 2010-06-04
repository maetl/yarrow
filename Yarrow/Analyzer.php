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

	const PHP_stdClass = 'stdClass';

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
					$this->shredDocBlock($t, $i);
				}
				break;

				case T_CLASS: {
					$this->shredClass($t, $i);
				}
				break;
				
				case T_FUNCTION: {
					$this->shredFunction($t, $i);
				}
			}
		}
	}
	
	/**
	 * Acceptor to build a class name and link to it's ancestor.
	 */
	function shredClass($t, $i) {
		$this->classes[] = $t[$i+2][1];
		if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_EXTENDS) {
			$parent = '';
			while (is_array($t[$i+1]) && $t[$i+1][0] !== T_WHITESPACE) $parent .= $t[++$i][1];
		} else {
			$parent = self::PHP_stdClass;
		}
		$this->ancestors[$t[$i+2][1]] = $parent;
	}

	/**
	 * Acceptor to build a function name and link to it's ancestor.
	 */
	function shredFunction($t, $i) {
		$func = array('name' => $t[$i+2][1]);
		if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_VARIABLE) {
			$func['args'] = $t[$i+4][1];
		}
		$this->functions[] = $func;
	}
	
	/**
	 * Acceptor to shred a docblock out of the token stream and
	 * hand it off to a semantic txt parser.
	 */
	function shredDocBlock($t, $i) {
		$this->docblocks[] = $t[$i][1];
	}
}