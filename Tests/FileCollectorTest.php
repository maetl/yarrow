<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class FileCollectorTest extends PHPUnit_Framework_TestCase {

	function assertNestedArrayContains($expected, $array, $key) {
		$result = false;
		foreach($array as $value) {
			if (isset($value[$key])) {
				if ($value[$key] == $expected) {
					$result = true;
					break;
				}
			}
		}
		$this->assertTrue($result);
	}

	function testFilterAllFilesByIncludePattern() {
		$collector = new FileCollector(dirname(__FILE__).'/Samples');
		$collector->includeByPattern("/\.php$/");
		$manifest = $collector->getManifest();

		$this->assertEquals(6, count($manifest));
		$this->assertNestedArrayContains('sample.class.php', $manifest, 'filename');
		$this->assertNestedArrayContains('sample.php', $manifest, 'filename');
		$this->assertNestedArrayContains('sample_function.php', $manifest, 'filename');
		$this->assertNestedArrayContains('SampleInterface.php', $manifest, 'filename');
		$this->assertNestedArrayContains('SampleObject.php', $manifest, 'filename');
		$this->assertNestedArrayContains('samples.php', $manifest, 'filename');
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