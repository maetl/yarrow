<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ConfigTest extends PHPUnit_Framework_TestCase {

	function testConfigInstance() {
		$config1 = Configuration::instance();
		$config2 = Configuration::instance();
		$this->assertSame($config1, $config2);
	}

	function testDefaultSettingsLoadedByClass() {
		$config = Configuration::instance();
		$this->assertEquals('Default Project', $config->meta['title']);
	}
	
	function testConfigurationMerge() {
		$config = Configuration::instance();
		$config->clear();
		$config->merge(array(
			'meta' => array(
				'title' => 'Should Be Overwritten'
			)
		));
		$this->assertEquals('Should Be Overwritten', $config->meta['title']);
		$this->assertEquals('Project Author', $config->meta['author']);
	}
	
	function testConfigurationAppend() {
		$config = Configuration::instance();
		$config->clear();
		$config->append(array(
			'meta' => array(
				'title' => 'Should Be Overwritten',
				'editor' => 'Erika Mustermann'
			)
		));
		$this->assertEquals('Default Project', $config->meta['title']);
		$this->assertEquals('Erika Mustermann', $config->meta['editor']);
	}
}