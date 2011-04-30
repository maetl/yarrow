<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ModelIntegrationTest extends PHPUnit_Framework_TestCase {
	
	function testCanModelConditionallyDeclaredClasses() {
		$analyzer = new Analyzer();
		
		$analyzer->analyzeFile(array('absolute_path' => dirname(__FILE__).'/Corpus/conditionally.php',
									 'relative_path' => 'Corpus/conditionally.php'));
									
		
		$model = $analyzer->getModel();
		
		$this->assertEquals(4, count($model->classes));
		$this->assertEquals('FirstType, SecondType', $model->classes[3]->ancestor);
	}
	
}