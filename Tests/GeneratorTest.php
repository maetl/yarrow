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
	
	public function testGeneratorRecognizesSimpleTemplateMap() {
		$target = dirname(__FILE__).'/StubClassDocs';
		$model = new StubObjectModel();
		
		$generator = new StubGenerator($target, $model);
		$generator->makeDocs();
		
		$this->assertTrue(file_exists($target.'/index.html'));
		$this->assertTrue(file_exists($target.'/file-stubclass.html'));
		$this->assertTrue(file_exists($target.'/class-stubclass.html'));
		
		unlink($target.'/index.html');
		unlink($target.'/file-stubclass.html');
		unlink($target.'/class-stubclass.html');
		rmdir($target);
	}
	
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