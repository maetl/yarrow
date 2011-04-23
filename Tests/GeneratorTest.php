<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class StubConverter {
	
	function render($template, $variables) {
		return __METHOD__;
	}
}

class PHPTemplateStubGenerator extends Generator {
	
	protected function getObjectMap() {
		return array(
				'index'  => array('index')
			   );
	}
	
	protected function getTemplateMap() {
		return array(
				'index'  => 'sample.tpl.php'
			   );
	}
	
	protected function getConverter() {
		return new PHPConverter(dirname(__FILE__).'/Templates/PHP');
	}
}

class MismatchingTemplateMethodGenerator extends Generator {
	
	protected function getObjectMap() {
		return array(
				'index'  => array('index'),
				'file'   => array('file')
			   );
	}
	
	protected function getTemplateMap() {
		return array(
				'index'  => 'index.tpl'
			   );
	}
	
	protected function getConverter() {
		return false;
	}
}

class StubGenerator extends Generator {
	
	protected function getObjectMap() {
		return array(
				'index'  => array('index'),
				'file'   => $this->objectModel->getFiles(),
				'class'  => $this->objectModel->getClasses()
			   );
	}
	
	protected function getTemplateMap() {
		return array(
				'index'  =>  'index.tpl',
				'file'   =>  'file.tpl',
				'class'  =>  'class.tpl'
			   );
	}
	
	protected function getConverter() {
		return new StubConverter();
	}
}

class StubObjectModel extends ObjectModel {
	
	/**
	 * Builds an empty class model for testing.
	 */
	function buildStubClassModel() {
		$class = new ClassModel('StubClass');
		$class->addFunction(new FunctionModel('getName'));
		return $class;
	}
	
	function getClasses() {
		$class = $this->buildStubClassModel();
		return array($class);
	}
	
	function getFiles() {
		$file = new FileModel('StubClass.php');
		$file->addClass($this->buildStubClassModel());
		return array($file);
	}
}

class GeneratorTest extends PHPUnit_Framework_TestCase {
	
	public function setUp() {
		$this->target = dirname(__FILE__) . '/SampleDocs';
	}
	
	public function tearDown() {
		if (is_dir($this->target)) rmdir($this->target);
	}
	
	public function testPHPTemplateEngineGeneratesExpectedFiles() {
		$model = new StubObjectModel();
		$generator = new PHPTemplateStubGenerator($this->target, $model);
		$generator->makeDocs();
		
		$generatedIndex = $this->target.'/index.html';
		$this->assertTrue(file_exists($generatedIndex));
		$this->assertContains('PHP Template Sample', file_get_contents($generatedIndex));
		$this->assertContains('StubClass', file_get_contents($generatedIndex));
		
		unlink($generatedIndex);
	}
	
	/**
	 * @expectedException ConfigurationError
	 */
	public function testMismatchingTemplateMethodGeneratorThrowsException() {
		$generator = new MismatchingTemplateMethodGenerator($this->target, false);
	}
	
	public function testGeneratorRecognizesSimpleTemplateMap() {
		$model = new StubObjectModel();
		$generator = new StubGenerator($this->target, $model);
		$generator->makeDocs();
		
		$this->assertTrue(file_exists($this->target.'/index.html'));
		$this->assertTrue(file_exists($this->target.'/file-stubclass.html'));
		$this->assertTrue(file_exists($this->target.'/class-stubclass.html'));
		
		unlink($this->target.'/index.html');
		unlink($this->target.'/file-stubclass.html');
		unlink($this->target.'/class-stubclass.html');
	}
	
	public function testCanMakeTargetDirectoryWhenNotExisting() {
		$model = new ObjectModel();
		$generator = new StubGenerator($this->target, $model);
		
		$this->assertTrue(is_dir($this->target));
	}
	
	public function testCanMakeTargetDirectoryWhenAlreadyExisting() {
		$model = new ObjectModel();
		mkdir($this->target);
		
		$generator = new StubGenerator($this->target, $model);
		$this->assertTrue(is_dir($this->target));
	}
}