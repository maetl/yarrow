<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class StubGenerator extends Generator {
	
}

class GeneratorTest extends PHPUnit_Framework_TestCase {
	
	public function testCanMakeTargetDirectoryWhenNotExisting() {
		$target = dirname(__FILE__).'/Docs';
		$model = new ObjectModel();
		
		$generator = new StubGenerator($target, $model);
		$this->assertTrue(is_dir($target));
		
		rmdir($target);
	}
	
	public function testCanMakeTargetDirectoryWhenAlreadyExisting() {
		$target = dirname(__FILE__).'/Docs';
		$model = new ObjectModel();
		mkdir($target);
		
		$generator = new StubGenerator($target, $model);
		$this->assertTrue(is_dir($target));
		
		rmdir($target);
	}
	
}