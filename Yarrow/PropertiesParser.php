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
 * Parses a subset of the Java style .properties format, similar to .ini files.
 */
class PropertiesParser extends Scanner {
	private $properties;
	private $section;

	function __construct($input) {
		$this->properties = array();
		$this->section = false;
		$input = $this->normalizeLineEndings($input);
		parent::__construct($input);
	}
	
	function normalizeLineEndings($input) {
		$input = str_replace("\r\n", "\n", $input);
		$input = str_replace("\r", "\n", $input);
		return $input;
	}
	
	function addSection($section) {
		if (!isset($this->properties[$section])) {
			$this->properties[$section] = array();
			$this->section = $section;
		}
	}
	
	function addProperty($key, $value) {
		$value = $this->convertValue($value);
		if ($this->section) {
			$this->properties[$this->section][$key] = $value;
		} else {
			$this->properties[$key] = $value;
		}
	}
	
	private function convertValue($value) {
		$value = trim($value);
		
		if (strstr($value, ',')) {
			return explode(',', $value);
		}
		
		if (is_numeric($value)) {
			return intval($value);
		}
		
		if (in_array(strtolower($value), array('on','true'))) {
			return true;
		}
		
		if (in_array(strtolower($value), array('off','false'))) {
			return false;
		}
		
		return $value;
	}
	
	const EOL = "\n";
	
	function parse() {		
		do {
			$char = $this->scanForward();
			
			switch($char) {
				
				case ';':
				case '#':
					$this->scanUntil(self::EOL);
					break;
				
				case '[':
					$section = $this->scanUntil("]");
					$this->addSection($section);
					$this->scanUntil(self::EOL);
					break;
					
				default:
					if ($char != self::EOL) {
						$this->skipBack();
						$key = $this->scanUntil(":");
						$this->skipForward();
						$value = $this->scanUntil(self::EOL);
						$this->addProperty($key, $value);						
					}
					break;
			}
		
		} while($this->cursor < $this->length);
		
		return $this->properties;
	}
}