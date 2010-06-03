<?php
require_once 'simpletest/autorun.php';

require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class ProjectMapTest extends UnitTestCase {
	
	function testCanBuildSingleFileProject() {
		$map = new ProjectMap();
		$map->setName('YarrowTest');
		$map->addFile('ClassBlockTest.php');
	}
	
	
}