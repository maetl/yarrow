<?php

class PropertiesFile {
	
	function __construct() {
		$this->properties = array();
		$this->section = false;
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
		$this->content = $this->load(dirname(__FILE__).'/Config/.yarrowdoc');
		$this->length = strlen($this->content);
		$this->cursor = 0;
		
		do {
			$this->parseLine();
		} while($this->cursor < $this->length);
	}
	
	function scanUntil($string) {
		$anchor = $this->cursor;
		while ($this->cursor < $this->length && strpos($string, $this->content{$this->cursor}) === false) {
			$this->cursor++;
		}
		return substr($this->content, $anchor, $this->cursor - $anchor);
	}
	
	function scanForward() {
		if ($this->cursor < $this->length) {
			return $this->content{$this->cursor++};
		}
	}
	
	function skipForward() {
		if ($this->cursor < $this->length) $this->cursor++;
	}
	
	function skipBack() {
		if ($this->cursor < $this->length) $this->cursor--;
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
	
	function __get($key) {
		if (!isset($this->properties[$key])) {
			throw new Exception("Config section [$key] does not exist.");
		}
		return $this->properties[$key];
	}
	
}

class ConfigurationTest extends PHPUnit_Framework_TestCase {
	
	function testLoadConfigFile() {
		$config = new PropertiesFile();
		$config->parse();
		
		$this->assertEquals("Configuration Test", $config->meta['title']);
		$this->assertEquals("Mark Rickerby", $config->meta['author']);
		$this->assertEquals("http://yarrowdoc.org", $config->meta['website']);
		$this->assertEquals("/path/to/templates", $config->output['templates']);
		$this->assertEquals("Twig", $config->output['converter']);
		$this->assertEquals(array('one','two','three'), $config->options['array']);
		$this->assertEquals(1, $config->options['truthy']);
		$this->assertEquals("false", $config->options['falsy']);
	}
}