<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class StubTemplateEngine {
	
	function render($template, $variables) {
		$output = "<html><head><title>Doc Test</title></head><body><ul>";
		foreach($variables['ObjectModel']->getClasses() as $class) {
			$output .= "<li>" . $class . "</li>";
		}
		$output .= "</ul></body></html>";
		return $output;
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
	
	protected function getTemplateEngine() {
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
	
	protected function getTemplateEngine() {
		return new StubTemplateEngine();
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
		$this->target = dirname(__FILE__) . '/StubClassDocs';
	}
	
	public function tearDown() {
		if (is_dir($this->target)) rmdir($this->target);
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
		$this->target = dirname(__FILE__).'/Docs';
		$model = new ObjectModel();
		
		$generator = new StubGenerator($this->target, $model);
		$this->assertTrue(is_dir($this->target));
	}
	
	public function testCanMakeTargetDirectoryWhenAlreadyExisting() {
		$this->target = dirname(__FILE__).'/Docs';
		$model = new ObjectModel();
		mkdir($this->target);
		
		$generator = new StubGenerator($this->target, $model);
		$this->assertTrue(is_dir($this->target));
	}
}