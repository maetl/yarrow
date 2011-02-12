<?php
require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class ProjectMapTest extends PHPUnit_Framework_TestCase {
	
	function testCanCollectFilesFromTestDir() {
		$collector = new FileCollector(dirname(__FILE__));
		$this->assertEquals(2, count($collector->getManifest()));
	}
	
	function testFullGeneratorRun() {
		$generator = new Generator();
		$generator->run(dirname(__FILE__)."/../Yarrow");
	}
	
}