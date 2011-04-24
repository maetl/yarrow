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

	function __construct($filename) {
		$this->properties = array();
		$this->section = false;
		parent::__construct($this->load($filename));
	}
	
	function __get($key) {
		if (!isset($this->properties[$key])) {
			throw new Exception("Config section [$key] does not exist.");
		}
		return $this->properties[$key];
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
		if (strstr($value, ',')) {
			return explode(',', $value);
		}
		return trim($value);
	}
	
	function load($path) {
		if (!file_exists($path)) {
			throw new Exception("Properties file $path not found.");
		}
		$contents = file_get_contents($path);
		$contents = str_replace("\r\n", "\n", $contents);
		$contents = str_replace("\r", "\n", $contents);
		return $contents;
	}
	
	function parse() {		
		do {
			$this->parseLine();
		} while($this->cursor < $this->length);
	}
	
	function parseLine() {
		$char = $this->scanForward();
		if ($char == ';' || $char == '#') {
			$this->parseComment();
		} elseif ($char == '[') {
			$this->parseSection();
		} elseif ($char != "\n") {
			$this->parseProperty();
		}
	}
	
	function parseProperty() {
		$this->skipBack();
		$key = $this->scanUntil(":");
		$this->skipForward();
		$value = ltrim($this->scanUntil("\n"));
		$this->addProperty($key, $value);
	}
	
	function parseComment() {
		$this->scanUntil("\n");
	}
	
	function parseSection() {
		$section = $this->scanUntil("]");
		$this->addSection($section);
		$this->scanUntil("\n");
	}
	
}

?>