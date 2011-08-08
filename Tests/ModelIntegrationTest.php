<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ModelIntegrationTest extends PHPUnit_Framework_TestCase {
	
	public function tearDown() {
		CodeRegistry::reset();
	}
	
	function testCanModelConditionallyDeclaredClasses() {
		$fileListing = new FileListing(new SplFileObject(dirname(__FILE__).'/Corpus/conditionally.php'));
		
		$analyzer = new Analyzer();
		$analyzer->analyzeFile($fileListing);					
		$model = $analyzer->getModel();
		$classes = $model->getClasses();
		
		$this->assertEquals(4, $model->classCount());
		$this->assertEquals('FirstType, SecondType', $classes[3]->ancestor);
	}
	
	function testHandleComplexStringInterpolation() {
		$fileListing = new FileListing(new SplFileObject(dirname(__FILE__).'/Corpus/interpolation.php'));
		
		$analyzer = new Analyzer();
		$analyzer->analyzeFile($fileListing);							
		$model = $analyzer->getModel();
		$classes = $model->getClasses();
		
		$this->assertEquals(1, count($model->classCount()));
		$this->assertEquals(2, count($classes[0]->getMethods()));
	}	
	
}