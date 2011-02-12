<?php
require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class ProjectMapTest extends PHPUnit_Framework_TestCase {
	
	function testCanCollectFilesFromTestDir() {
		$collector = new FileCollector(dirname(__FILE__));
		$this->assertEquals(2, count($collector->getManifest()));
	}
	
	function testVisualCheckOfDataStructure() {
		$collector = new FileCollector(dirname(__FILE__)."/../Yarrow");
		print_r($collector->getManifest());		
	}
	
}