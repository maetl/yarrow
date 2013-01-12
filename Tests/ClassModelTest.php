<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ClassModelTest extends PHPUnit_Framework_TestCase {

	function testInterfaceNotInstantiable() {
		$model = new ClassModel('TestInterface', ClassModel::BASE_TYPE, array(
			'interface' => true,
		));
		$this->assertFalse($model->isInstantiable());
	}
	
	function testAbstractClassNotInstantiable() {
		$model = new ClassModel('TestAbstract', ClassModel::BASE_TYPE, array(
			'abstract' => true,
		));
		$this->assertFalse($model->isInstantiable());
	}
	
	function testConcreteClassInstantiable() {
		$model = new ClassModel('Test');
		$this->assertTrue($model->isInstantiable());
	}


}