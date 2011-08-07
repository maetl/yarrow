<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

/**
 * This is indeed a very amusing piece of machinery.
 */
class ClassBlockTest extends PHPUnit_Framework_TestCase {

	public function tearDown() {
		CodeRegistry::reset();
	}

	public function testAnalyzeFile() {
		$analyzer = new Analyzer();
		$analyzer->analyzeFile(new FileListing(__FILE__, dirname(__FILE__)));
		
		$model = $analyzer->getModel();
		$this->assertEquals($model->classCount(), 1);
		
		$classes = $model->getClasses();
		$methods = $classes[0]->getMethods();
		
		$this->assertEquals($classes[0]->methodCount(), 5);
		$this->assertEquals($classes[0]->getSummary(), "This is indeed a very amusing piece of machinery.");
		$this->assertFalse($methods[2]->isPublic());
		$this->assertTrue($methods[3]->isPublic());
		$this->assertEquals($methods[3]->getSummary(), "This is the public API, and should be documented.");
		$this->assertEquals($methods[4]->getSummary(), "This is the public API, and has three arguments.");
	}
	
	/**
	 * This wouldn't be documented, as it is protected.
	 */
	protected function dumpHtml($classes) {
		foreach($classes as $y=>$class) {
			$str = "<h1>$class</h1>";
		}
		return $str;
	}
	
	/**
	 * This is the public API, and should be documented.
	 */
	public function dumpText($classes, $docblocks) {
		foreach($classes as $y=>$classname) {
			$str = "=$classname\n\n";
		}
		return $str;		
	}
	
	/**
	 * This is the public API, and has three arguments.
	 */
	public function dumpAnything($classes, $docblocks, $functions) {
		return $this->dumpText($classes, $docblocks);
	}
}