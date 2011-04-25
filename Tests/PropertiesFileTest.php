<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class PropertiesTest extends PHPUnit_Framework_TestCase {
	
	function testLoadPropertiesFromFile() {
		$properties = PropertiesFile::load(dirname(__FILE__).'/Config/.yarrowdoc');
		$this->assertInternalType('array', $properties);
		$this->assertEquals("Configuration Test", $properties['meta']['title']);
		$this->assertEquals("Mark Rickerby", $properties['meta']['author']);
		$this->assertEquals("http://yarrowdoc.org", $properties['meta']['website']);
		$this->assertEquals("/path/to/templates", $properties['output']['templates']);
		$this->assertEquals("Twig", $properties['output']['converter']);
		$this->assertEquals(array('one','two','three'), $properties['options']['array']);
		$this->assertEquals(1, $properties['options']['integer']);
		$this->assertSame(true, $properties['options']['truthy']);
		$this->assertSame(false, $properties['options']['falsy']);
	}
}