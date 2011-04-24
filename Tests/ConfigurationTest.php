<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ConfigurationTest extends PHPUnit_Framework_TestCase {
	
	function testLoadConfigFile() {
		$config = new PropertiesParser(dirname(__FILE__).'/Config/.yarrowdoc');
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