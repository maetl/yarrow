<?php
require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class ProjectMapTest extends PHPUnit_Framework_TestCase {
	
	function testCanReadSingleFileProject() {
		$collector = new FileCollector(dirname(__FILE__)."/../Yarrow");
		//$this->assertEquals(2, count($collector->getProjectMap()));
		print_r($collector->getProjectMap());
	}
	
	function testCanReadMultiFileProject() {
		
	}
	
	function testCanReadNestedFolderProject() {
		
	}
	
}