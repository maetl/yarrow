<?php

require_once dirname(__FILE__).'/../Yarrow/Doc.php';

/**
 * This is indeed a very amusing piece of machinery.
 */
class ClassBlockTest extends PHPUnit_Framework_TestCase {

	public function testAnalyzeFile() {
		
		$analyzer = new Analyzer();
		$analyzer->analyzeFile(__FILE__);
		
		$writer = new Writer();
		
		$html = $writer->dumpHtml($analyzer->classes, $analyzer->docblocks);
		
		$this->assertContains(__CLASS__, $html);
		$this->assertContains("amusing piece", $html);
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