<?php

class Configuration {
	private $settings;
	private $context;
	private $reference;
	
	function __construct() {
		$this->settings = array();
		$this->loadFromTarget();
	}
	
	/**
	 * Load the file from specified path.
	 */
	private function loadFromTarget() {
		$source = file_get_contents(dirname(__FILE__).'/Config/.yarrowdoc');
		$source = str_replace(':', '=', $source);
		$settings = parse_ini_string($source, true);
		foreach($settings as $section => $properties) {
			$this->settings[$section] = array();
			foreach($properties as $key => $value) {
				$this->settings[$section][$key] = $this->convertValue($value);
			}
		}
	}
	
	private function convertValue($value) {
		if (strstr($value, ',')) {
			return explode(',', $value);
		}
		return $value;
	}
	
	function __get($key) {
		if (!isset($this->settings[$key])) {
			throw new Exception("Config section [$key] does not exist.");
		}
		return $this->settings[$key];	
	}
	
}

class ConfigurationTest extends PHPUnit_Framework_TestCase {
	
	function testLoadConfigFile() {
		$config = new Configuration();
		$this->assertEquals("Configuration Test", $config->meta['title']);
		$this->assertEquals("Mark Rickerby", $config->meta['author']);
		$this->assertEquals("PEAR", $config->package['namespace']);
		$this->assertEquals(array('one', 'two', 'three'), $config->output['options']);
	}
}