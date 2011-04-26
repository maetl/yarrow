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

define('T_SCOPE_START', 900);
define('T_SCOPE_END', 909);
define('T_BRACE_OPEN', 911);
define('T_BRACE_CLOSE', 919);
define('T_TERNARY_IF', 977);
define('T_UNKNOWN', 999);

/**
 * Parse a PHP token stream and extract useful information about its
 * object oriented structure.
 */
class CodeParser {
	private $tokens;
	private $total;
	private $current;
	private $line;
	private $scope;
	private $file;
	private $class;
	private $function;
	private $tokenMap = array(
		'{' => T_SCOPE_START,
		'}' => T_SCOPE_END,
		'(' => T_BRACE_OPEN,
		')' => T_BRACE_CLOSE,
		'?' => T_TERNARY_IF
	);
	
	const GLOBAL_SCOPE 	 = 1;
	const CLASS_SCOPE  	 = 2;
	const FUNCTION_SCOPE = 3;
	
	/**
	 * @param $tokens array of token identifiers
	 * @param $reader CodeReader instance
	 */
	function __construct($tokens, $reader) {
		$line = 1;
		
		foreach($tokens as $i => $token) {
			if (!is_array($token)) {
				$tokens[$i] = $this->normalizeToken($token, $line);
			}
			$lines = substr_count($tokens[$i][1], "\n");
			$line += $lines;
		}
		
		$this->tokens = $tokens;
		$this->total = count($this->tokens);
		$this->current = 0;
		$this->state = self::GLOBAL_SCOPE;
		$this->scope = new ScopeStack();
		$this->reader = $reader;
		$this->keywords = array();
		
		//----------------------------------------------------------------

		$this->docblockScope = false; // replace these with a stack
		$this->classScope = false;	  // that holds nested scope state
	}
	
	/**
	 * Converts strings from the PHP tokenizer to the standard format.
	 */
	function normalizeToken($token, $line) {
		$symbol = (isset($this->tokenMap[$token])) ? $this->tokenMap[$token] : T_UNKNOWN;
		return array($symbol, $token, $line);
	}
	
	/**
	 * Shreds a PHP code file for classes, methods, and doc comments.
	 */
	function parse() {
		
		for ($this->current = 0; $this->current < $this->total; $this->current++) {
			
			$token = $this->currentToken();
						
			$this->symbol = $token[0];
			$this->value = $token[1];
			$this->line = $token[1];
			
			switch ($this->symbol) {
				
				case T_OPEN_TAG:
					$this->scope->push($this->state);
				break;
				
				case T_DOC_COMMENT:
					$this->shredDocBlock();
				break;

				case T_CLASS:
				case T_INTERFACE:
					$this->shredClass();
				break;
				
				case T_FUNCTION:
					$this->shredFunction();
					$this->complexity = 0;
				break;
				
				case T_SCOPE_START:
					$this->startNestingScope();
				break;
				
				case T_SCOPE_END:
					$this->endNestingScope();
				break;
				
				case T_PRIVATE:
				case T_PROTECTED:
				case T_PUBLIC:
					$this->setVisibility();
				break;
				
				case T_STATIC:
					$this->setStatic();					
				break;
				
				case T_ABSTRACT:
					$this->setAbstract();
				break;
				
				case T_IF:
				case T_ELSEIF:
				case T_FOR:
				case T_FOREACH:
				case T_WHILE:
				case T_CASE:
				case T_CATCH:
				case T_TERNARY_IF:
					if ($this->state == self::FUNCTION_SCOPE) {
						$this->complexity++;
						// cyclomatic complexity generated, but not captured!
					}
				break;
			}
		}
	}
	
	/**
	 * Return the symbol at current position in the token stream.
	 */
	function currentToken() {
		return $this->tokens[$this->current];
	}
	
	/**
	 * Acceptor to shred a docblock out of the token stream and
	 * hand it off to a semantic txt parser.
	 */
	function shredDocBlock() {
		$symbol = $this->currentToken();
		$this->reader->onDocComment($symbol[1]);
	}
	
	/**
	 * Acceptor to build a class name and link to it's ancestor.
	 */
	function shredClass() {
		$t = $this->tokens;
		$i = $this->current;
		$class = $t[$i+2][1];
		$parent = false;
		
		if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_EXTENDS) {
			$parent = '';
			while (is_array($t[$i+1]) && $t[$i+1][0] !== T_WHITESPACE) $parent .= $t[++$i][1];
		}
		
		$this->reader->onClass($class, $parent);
		$this->state = self::CLASS_SCOPE;
	}

	/**
	 * Acceptor to build a function signature.
	 */
	function shredFunction() {
		$t = $this->tokens;
		$i = $this->current;
		$name = $t[$i+2][1];
		extract($this->keywords);
		
		$arguments = $this->shredArguments($i+4);
		
		if ($this->state == self::CLASS_SCOPE) {
			
			$visibility = (isset($visibility)) ? $visibility : 'public';
			$final = isset($final);
			
			if (isset($static)) {
				$this->reader->onStaticMethod($name, $arguments, $visibility, $final);
			} else {
				$this->reader->onMethod($name, $arguments, $visibility, $final);
			}
			
		} else {
			if (isset($static)) {
				$this->reader->onStaticFunction($name, $arguments);
			} else {
				$this->reader->onFunction($name, $arguments);
			}
		}
		
		$this->state = self::FUNCTION_SCOPE;
	}
	
	/**
	 * Collects the visibility signature of a function from current position
	 * in the token stream.
	 */
	function setVisibility() {
		$this->keywords['visibility'] = $this->value;
	}
	
	function setStatic() {
		$this->keywords['static'] = $this->value;
	}
	
	function setAbstract() {
		$this->keywords['abstract'] = $this->value;
	}
	
	function setFinal() {
		$this->keywords['final'] = $this->value;
	}
	
	function resetKeywords() {
		$this->keywords = array();
	}
	
	/**
	 * Collects the parameter signature of a function from a given position in
	 * the token stream.
	 */
	function shredArguments($position) {
		$token = $this->tokens[$position];
		$arguments = array();
		$pos  = $position;
		$hint = false;
		
		while ($token[0] != T_BRACE_CLOSE) {
			if ($token[0] == T_STRING) {
				$hint = $token[1];
			} elseif ($token[0] == T_VARIABLE) {
				$name = (string)$token[1];
				$arguments[$name] = $hint;
				$hint = false;
			}
			$pos++;
			$token = $this->tokens[$pos];
		}
		
		$this->current = $pos;
		return $arguments;
	}
	
	function startNestingScope() {
		$this->scope->push($this->state);
	}
	
	function endNestingScope() {
		$previous = $this->scope->pop();
		$this->state = $this->scope->peek();

		if ($this->state == self::CLASS_SCOPE) {
			$this->reader->onMethodEnd();

		} elseif ($this->state == self::GLOBAL_SCOPE) {
			if ($previous == self::FUNCTION_SCOPE) {
				$this->reader->onFunctionEnd();
			} else {
				$this->reader->onClassEnd();
			}
		}		
	}
}