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

define('T_SCOPE_OPEN', 900);
define('T_SCOPE_CLOSE', 909);
define('T_BRACE_OPEN', 911);
define('T_BRACE_CLOSE', 919);
define('T_TERNARY_IF', 977);
define('T_AMPERSAND', 988);
define('T_SEMICOLON', 990);
define('T_COMMA', 991);
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
		'{' => T_SCOPE_OPEN,
		'}' => T_SCOPE_CLOSE,
		'(' => T_BRACE_OPEN,
		')' => T_BRACE_CLOSE,
		'?' => T_TERNARY_IF,
		'&' => T_AMPERSAND,
		';' => T_SEMICOLON,
		',' => T_COMMA,
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
		$this->default = false;
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
					$this->shredDocblock();
				break;

				case T_CLASS:
				case T_INTERFACE:
					$this->shredClass();
				break;

				case T_CONST:
					$this->shredConstant();
				break;

				case T_FUNCTION:
					$this->shredFunction();
				break;

				case T_SCOPE_OPEN:
					$this->startNestingScope();
				break;

				case T_SCOPE_CLOSE:
					$this->endNestingScope();
				break;

				case T_VAR:
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

				case T_FINAL:
					$this->setFinal();
				break;

				case T_VARIABLE:
					$this->shredProperty();
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
						// cyclomatic complexity calculated but not captured!
					}
				break;

				case T_CURLY_OPEN:
				case T_DOLLAR_OPEN_CURLY_BRACES:
				case T_STRING_VARNAME:
					$this->startNestingScope();
				break;

				case T_STRING:
					$this->shredDefinedStrings();
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
	 * Advance to the symbol at next position in the token stream.
	 */
	function nextToken() {
		return $this->tokens[++$this->current];
	}

	/**
	 * Somewhat of a hack to recognize global constant definitions.
	 */
	function shredDefinedStrings() {
		if ($this->value == 'define') {
			$token = $this->nextToken();
			while ($token[0] != T_SEMICOLON) {
				if ($token[0] == T_CONSTANT_ENCAPSED_STRING) {
					if (!isset($name)) {
						$name = str_replace(array("'", '"'), '', $token[1]);
					} else {
						$value = $token[1];
					}
				} elseif ($token[0] == T_STRING || $token[0] == T_LNUMBER) {
					$value = $token[1];
				}
				$token = $this->nextToken();
			}
			$this->reader->onConstant($name, $value);
		}
	}

	/**
	 * Sets the currently recognized docblock
	 */
	function shredDocblock() {
		$symbol = $this->currentToken();
		if ($this->current == 1) {
			$this->reader->onFileHeader($symbol[1]);
		} else {
			$this->reader->onDocblock($symbol[1]);
		}
	}

	/**
	 * Trigger a class constant event.
	 */
	function shredConstant() {
		$id = $this->current+2;
		$name = $this->tokens[$id][1];
		while($this->tokens[$id+1][1] != '=') {
			$this->tokens[++$id];
		}
		$id++;
		while($this->tokens[$id+1][0] != T_SEMICOLON) {
			if ($this->tokens[++$id][0] != T_WHITESPACE) {
				$value = $this->tokens[$id][1];
			}
		}

		$this->reader->onConstant($name, $value);
	}
	
	/**
	 * Clip the default value off a class property or function argument.
	 */
	function shredValue($endToken=T_SEMICOLON) {		
		$token = $this->nextToken();
		
		while ($token[0] != $endToken) {
			
			switch($token[0]) {

				case T_DNUMBER:
					$this->default = floatval($token[1]);
				break;
				
				case T_LNUMBER:
					$this->default = intval($token[1]);
				break;
				
				case T_STRING:
				case T_CONSTANT_ENCAPSED_STRING:
					$this->default = self::castString($token[1]);
				break;
				
				case T_ARRAY:
					$this->default = $this->readArray();
				break;
				
			}
			
			$token = $this->nextToken();
		}
	}
	
	/**
	 * Captures declarative array syntax and builds a data structure
	 * representing the default values given in the source code.
	 */
	function readArray() {
		$array = array();
		$token = $this->nextToken();
		
		while ($token[0] != T_BRACE_CLOSE) {
			
			switch($token[0]) {
				
				case T_BRACE_OPEN:
					$indices = array();
					$map = false;
				break;
				
				case T_ARRAY:
					array_push($indices, $this->readArray());
				break;
				
				case T_DNUMBER:
					array_push($indices, floatval($token[1]));
				break;
				
				case T_LNUMBER:
					array_push($indices, intval($token[1]));
				break;
				
				case T_STRING:
				case T_CONSTANT_ENCAPSED_STRING:
					array_push($indices, self::castString($token[1]));
				break;
				
				case T_DOUBLE_ARROW:
					$map = true;
				break;
				
				case T_COMMA:
					if ($map) {
						$value = array_pop($indices);
						$key = array_pop($indices);
						$array[$key] = $value;
					} else {
						array_push($array, array_pop($indices));
					}
					
				break;
				
			}
			
			$token = $this->nextToken();
		}
		
		if (count($indices) == 2) {
			$value = array_pop($indices);
			$key = array_pop($indices);
			$array[$key] = $value;
		} elseif (count($indices) == 1) {
			array_push($array, array_pop($indices));
		}
		
		return $array;
	}

	/**
	 * Flip a string value from the parser into a native type.
	 *
	 * @return bool|string
	 */
	private static function castString($value) {
		return ($value == 'true' || $value == 'false') ? (bool)$value : str_replace(array('"', "'"), '', $value);
	}

	/**
	 * If the variable is in a class scope, then trigger a class
	 * property event.
	 */
	function shredProperty() {
		if ($this->state == self::CLASS_SCOPE) {
			$this->shredValue();
			$this->reader->onProperty($this->value, $this->keywords, $this->default);
			$this->resetKeywords();
		}
	}

	/**
	 * Acceptor to build a class name and link to it's ancestor.
	 */
	function shredClass() {

		if ($this->symbol == T_INTERFACE) {
			$this->keywords['interface'] = true;
		}

		$id = $this->current+2;
		$class = $this->tokens[$id][1];
		$parent = ClassModel::BASE_TYPE;

		if ($this->tokens[$id+2][0] == T_EXTENDS) {
			$id += 4;
			$parent = $this->tokens[$id][1];
			while($this->tokens[$id+1][0] != T_WHITESPACE) {
				$parent .= $this->tokens[++$id][1];
			}
		}

		if ($this->tokens[$id+2][0] == T_IMPLEMENTS) {
			$id += 4;
			$implements = $this->tokens[$id][1];
			while($this->tokens[$id+1][0] != T_WHITESPACE) {
				$implements .= $this->tokens[++$id][1];
			}
			$this->keywords['implements'] = $implements;
		}

		$this->reader->onClass($class, $parent, $this->keywords);
		$this->state = self::CLASS_SCOPE;
		$this->resetKeywords();
	}

	/**
	 * Acceptor to build a function signature.
	 */
	function shredFunction() {
		
		while ($this->tokens[$this->current][0] != T_BRACE_OPEN) {
			if ($this->tokens[$this->current][0] == T_STRING) {
				$name = $this->tokens[$this->current][1];
			}
			$this->current++;
		}

		$arguments = $this->shredArguments($this->current+1);

		if ($this->state == self::CLASS_SCOPE) {
			$this->reader->onMethod($name, $arguments, $this->keywords);
		} else {
			$this->reader->onFunction($name, $arguments, $this->keywords);
		}
		
		if (isset($this->keywords['abstract'])) {
			$this->reader->onMethodEnd();
		} else {
			$this->state = self::FUNCTION_SCOPE;
		}
		
		$this->complexity = 0;
		$this->resetKeywords();
	}

	/**
	 * Collects the visibility signature of a function from current position
	 * in the token stream.
	 */
	function setVisibility() {
		$this->keywords['visibility'] = ($this->value == 'var') ? 'public' : $this->value;
	}

	/**
	 * Collects the static keyword of a function from current position
	 * in the token stream.
	 */
	function setStatic() {
		$this->keywords['static'] = true;
	}

	/**
	 * Collects the abstract keyword of a function or class from current position
	 * in the token stream.
	 */
	function setAbstract() {
		$this->keywords['abstract'] = true;
	}

	/**
	 * Collects the final keyword of a class from current position
	 * in the token stream.
	 */
	function setFinal() {
		$this->keywords['final'] = true;
	}

	/**
	 * Resets the keyword list when the scope is popped.
	 */
	function resetKeywords() {
		$this->keywords = array();
		$this->default = false;
	}

	/**
	 * Collects the parameter signature of a function from a given position in
	 * the token stream.
	 */
	function shredArguments($position) {
		$token = $this->currentToken();
		$arguments = array();
		$hint = false;

		while ($token[0] != T_BRACE_CLOSE) {
			if ($token[0] == T_STRING) {
				$hint = $token[1];
			} elseif ($token[0] == T_VARIABLE) {
				$name = (string)$token[1];
				$arguments[$name] = $hint;
				$hint = false;
			}
			$token = $this->nextToken();
		}

		return $arguments;
	}

	/**
	 * Descend into a nested scope marked by an open brace ({...)
	 */
	function startNestingScope() {
		$this->scope->push($this->state);
	}

	/**
	 * Emerge out of a nested scope marked by a closing brace (...})
	 */
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