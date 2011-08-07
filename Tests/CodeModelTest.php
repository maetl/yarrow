<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class CodeModelTest extends PHPUnit_Framework_TestCase {

	public function tearDown() {
		CodeRegistry::reset();
	}

	function testEmptyAggregateRoot() {
		$model = new ObjectModel();
		$this->assertEquals(array(), $model->getPackages());
		$this->assertEquals(array(), $model->getClasses());
		$this->assertEquals(array(), $model->getFunctions());
		$this->assertEquals(array(), $model->getFiles());
		$this->assertEquals(array(), $model->getConstants());
	}

}