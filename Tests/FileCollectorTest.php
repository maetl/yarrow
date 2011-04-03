<?php
require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class FileCollectorTest extends PHPUnit_Framework_TestCase {
	
	function testFilterAllFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__));
		$collector->includeByPattern("/\.php$/");
		$this->assertEquals(4, count($collector->getManifest()));
	}
	
	function testFilterFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__));
		$collector->includeByPattern("/\.class\.php$/");
		$this->assertEquals(1, count($collector->getManifest()));
	}
	
	function testFilterFilesByExcludePattern() {
		$collector = new FileCollector(dirname(__FILE__));
		$collector->excludeByPattern("/\.class\.php$/");
		$this->assertEquals(3, count($collector->getManifest()));
	}
	
	function testFullGeneratorRun() {
		//$generator = new Generator();
		//$generator->run(dirname(__FILE__)."/Samples");
	}
	
}