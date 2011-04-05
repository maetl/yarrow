<?php

require_once dirname(__FILE__).'/../Yarrow/Doc.php';

/**
 * This is indeed a very amusing piece of machinery.
 */
class ClassBlockTest extends PHPUnit_Framework_TestCase {

	public function testAnalyzeFile() {
		$analyzer = new Analyzer();
		$analyzer->analyzeFile(__FILE__);
		
		$this->assertEquals(count($analyzer->classes), 1);
		$this->assertEquals($analyzer->classes[0]->methodCount(), 4);
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
			$str .= "{$docblocks[$y]}";
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