<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ModelIntegrationTest extends PHPUnit_Framework_TestCase {
	
	public function tearDown() {
		CodeRegistry::reset();
	}
	
	function testCanModelConditionallyDeclaredClasses() {
		$analyzer = new Analyzer();
		
		$analyzer->analyzeFile(array('absolute_path' => dirname(__FILE__).'/Corpus/conditionally.php',
									 'relative_path' => 'Corpus/conditionally.php',
									 'base_path'	 => 'Tests/Corpus/conditionally.php'));
									
		
		$model = $analyzer->getModel();
		$classes = $model->getClasses();
		
		$this->assertEquals(4, $model->classCount());
		$this->assertEquals('FirstType, SecondType', $classes[3]->ancestor);
	}
	
	function testHandleComplexStringInterpolation() {
		$analyzer = new Analyzer();
		
		$analyzer->analyzeFile(array('absolute_path' => dirname(__FILE__).'/Corpus/interpolation.php',
									 'relative_path' => 'Corpus/interpolation.php',
									 'base_path'	 => 'Tests/Corpus/interpolation.php'));
									
		
		$model = $analyzer->getModel();
		
		$this->assertEquals(1, count($model->classCount()));
		$classes = $model->getClasses();
		$this->assertEquals(2, count($classes[0]->getMethods()));
	}	
	
}