<?php

/**
 * Parse a PHP token stream and extract useful information about its
 * object oriented structure.
 */
class CodeParser {
	
	private $tokens;
	private $current;
	
	/**
	 * @param $tokens array of token identifiers
	 */
	function __construct($tokens) {
		$this->tokens = $tokens;
		$this->total = count($this->tokens);
		$this->current = 0;
		
		// temporary array storage until listener interface is implemented
		$this->docblocks = array();
		$this->classes = array();
		$this->functions = array();
		$this->docblockScope = false;		
	}
	
	/**
	 * Shreds a PHP token stream for dockblocks in a single namespace.
	 *
	 * Attaches a docblock, class and method count.
	 */
	function parse() {
		for ($this->current = 0; $this->current < $this->total; $this->current++) {
			
			if ($this->skipSyntax()) continue;
			
			list($token, $value) = $this->currentSymbol();
			
			echo $value;
			
			switch ($token) {
				case T_DOC_COMMENT: {
					$this->shredDocBlock();
				}
				break;

				case T_CLASS: {
					$this->shredClass();
				}
				break;
				
				case T_FUNCTION: {
					$this->shredFunction();
				}
			}
		}
	}
	
	/**
	 * Return the symbol at current position in the token stream.
	 */
	function currentSymbol() {
		return $this->tokens[$this->current];
	}
	
	/**
	 * Returns true if a token symbol is a raw string and can be skipped
	 */
	function skipSyntax() {
		return (is_string($this->currentSymbol()));
	}
	
	/**
	 * Acceptor to build a class name and link to it's ancestor.
	 */
	function shredClass() {
		$t = $this->tokens;
		$i = $this->current;
		
		if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_EXTENDS) {
			$parent = '';
			while (is_array($t[$i+1]) && $t[$i+1][0] !== T_WHITESPACE) $parent .= $t[++$i][1];
		} else {
			$parent = self::PHP_stdClass;
		}
		$class = new ClassModel($t[$i+2][1], $parent);
		if ($this->docblockScope) {
			$class->addDocblock(array_pop($this->docblocks));
			$this->docblockScope = false;
		}
		$this->classes[] = $class;
	}

	/**
	 * Acceptor to build a function signature.
	 */
	function shredFunction() {
		$t = $this->tokens;
		$i = $this->current;
		
		$func = new FunctionModel($t[$i+2][1]);
		$cur = $i+4;
		$tok = $t[$cur];
		$hint = '';
		while($tok != ')') {
			if ($tok && is_array($tok)) {
				if ($tok[0] == T_STRING) {
					$hint = $tok[1];
				} elseif ($tok[0] == T_VARIABLE) {
					$func->addArgument($tok[1].':'.$hint);
					$hint = '';
				}
			}
			$cur++;
			$tok = $t[$cur];
		}
		if ($this->docblockScope) {
			$func->addDocblock(array_pop($this->docblocks));
			$this->docblockScope = false;
		}
		$class = end($this->classes);
		$class->addFunction($func);
	}
	
	/**
	 * Acceptor to shred a docblock out of the token stream and
	 * hand it off to a semantic txt parser.
	 */
	function shredDocBlock() {
		$symbol = $this->currentSymbol();
		$this->docblocks[] = $symbol[1];
		$this->docblockScope = true;
	}
	
}