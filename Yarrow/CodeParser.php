<?php
/**
 * Yarrow
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
 * Parse a PHP token stream and extract useful information about its
 * object oriented structure.
 */
class CodeParser {
	
	/**
	 * Base type for all PHP classes
	 */
	const PHP_stdClass = 'stdClass';
	
	private $tokens;
	private $total;
	private $current;
	private $scope;
	private $file;
	
	/**
	 * @param $tokens array of token identifiers
	 */
	function __construct($tokens, $listener) {
		$this->tokens = $tokens;
		$this->total = count($this->tokens);
		$this->current = 0;
		
		$this->scope = new ScopeStack();
		$this->listener = $listener;
		
		// temporary array storage until listener interface is implemented
		$this->docblocks = array();
		$this->classes = array();
		$this->functions = array();
		$this->globals = array();
		
		$this->docblockScope = false; // replace these with a stack
		$this->classScope = false;	  // that holds nested scope state
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
				break;
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
	 * Acceptor to shred a docblock out of the token stream and
	 * hand it off to a semantic txt parser.
	 */
	function shredDocBlock() {
		$symbol = $this->currentSymbol();
		$this->docblocks[] = $symbol[1];
		$this->listener->addDocblock($symbol[1]);
		$this->docblockScope = true;
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
			$this->classScope = true;
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
		if ($this->classScope) {
			$class = end($this->classes);
			$class->addFunction($func);
		} else {
			$this->globals[] = $func;
		}
	}
	
}