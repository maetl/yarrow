<?php
require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class FileCollectorTest extends PHPUnit_Framework_TestCase {
	
	function testFilterAllFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->includeByPattern("/\.php$/");
		$manifest = $collector->getManifest();
		
		$this->assertEquals(4, count($manifest));
		$this->assertEquals('sample.class.php', $manifest[0]['filename']);
		$this->assertEquals('sample.php', $manifest[1]['filename']);
		$this->assertEquals('sample_function.php', $manifest[2]['filename']);
		$this->assertEquals('SampleObject.php', $manifest[3]['filename']);
		
	}
	
	function testFilterFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->includeByPattern("/\.class\.php$/");
		$manifest = $collector->getManifest();
		
		$this->assertEquals(1, count($manifest));
		$this->assertEquals('sample.class.php', $manifest[0]['filename']);
		$this->assertEquals('Samples/sample.class.php', $manifest[0]['relative_path']);
	}
	
	function testFilterFilesByExcludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->excludeByPattern("/\.class\.php$/");
		$manifest = $collector->getManifest();
		
		$this->assertEquals(3, count($manifest));
		$this->assertEquals('sample.php', $manifest[0]['filename']);
		$this->assertEquals('sample_function.php', $manifest[1]['filename']);	
		$this->assertEquals('SampleObject.php', $manifest[2]['filename']);	
	}
	
	function testFilterFilesByMultipleExcludePatterns() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->excludeByPattern("/\.class\.php$/");
		$collector->excludeByPattern("/\_function\.php$/");
		$manifest = $collector->getManifest();
		
		$this->assertEquals(2, count($manifest));
		$this->assertEquals('sample.php', $manifest[0]['filename']);
		$this->assertEquals('SampleObject.php', $manifest[1]['filename']);		
	}
}