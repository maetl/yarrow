<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class FileCollectorTest extends PHPUnit_Framework_TestCase {
	
	private function getFiles($manifest) {
		$files = array();
		foreach($manifest as $file) {
			$files[] = $file['filename'];
		}
		return $files;
	}

	function testFilterAllFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->includeByPattern("/\.php$/");
		$manifest = $collector->getManifest();
		$files = $this->getFiles($manifest);

		$this->assertEquals(6, count($manifest));
		$this->assertContains('sample.class.php', $files);
		$this->assertContains('sample.php', $files);
		$this->assertContains('sample_function.php', $files);
		$this->assertContains('SampleInterface.php', $files);
		$this->assertContains('SampleObject.php', $files);
		$this->assertContains('samples.php', $files);
	}

	function testFilterFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->includeByPattern("/\.class\.php$/");
		$manifest = $collector->getManifest();
		$files = $this->getFiles($manifest);

		$this->assertEquals(1, count($manifest));
		$this->assertEquals('sample.class.php', $manifest[0]['filename']);
		$this->assertEquals('Samples/sample.class.php', $manifest[0]['relative_path']);
	}

	function testFilterFilesByExcludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->excludeByPattern("/\.class\.php$/");
		$manifest = $collector->getManifest();

		$this->assertEquals(5, count($manifest));
		$this->assertEquals('sample.php', $manifest[0]['filename']);
		$this->assertEquals('sample_function.php', $manifest[1]['filename']);
		$this->assertEquals('SampleInterface.php', $manifest[2]['filename']);
		$this->assertEquals('SampleObject.php', $manifest[3]['filename']);
		$this->assertEquals('samples.php', $manifest[4]['filename']);
	}

	function testFilterFilesByMultipleExcludePatterns() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->excludeByPattern("/\.class\.php$/");
		$collector->excludeByPattern("/\_function\.php$/");
		$manifest = $collector->getManifest();

		$this->assertEquals(4, count($manifest));
		$this->assertEquals('sample.php', $manifest[0]['filename']);
		$this->assertEquals('SampleInterface.php', $manifest[1]['filename']);
		$this->assertEquals('SampleObject.php', $manifest[2]['filename']);
		$this->assertEquals('samples.php', $manifest[3]['filename']);
	}
}