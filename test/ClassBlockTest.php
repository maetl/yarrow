<?php
#
# Yarrowdocs yet as experimentation
# plus am still in Ruby mode writing (!!) oops
#
require_once 'simpletest/autorun.php';

/**
 * This is indeed a very amusing piece of machinery.
 */
class ClassBlockTest extends UnitTestCase {

	public function testAnalyzeFile() {
		$this->analyzeFile(__FILE__);
		$html = $this->dumpHtml();
		$this->assertTrue(strstr($html, __CLASS__));
		$this->assertTrue(strstr($html, "amusing piece"));
	}
	
	protected function dumpHtml() {
		foreach($this->classes as $y=>$classname) {
			$str = "<h1>$classname</h1>";
			$str .= "<pre>{$this->docblocks[$y]}</pre>";
		}
		return $str;
	}
	
	/**
	 * Public: Port of constructor to test case
	 */
	protected function initialize() {
		$this->docblocks = array();
		$this->classes = array();
		$this->ancestors = array();
		$this->functions = array();
	}
	
	/**
	 * Intends to analyze a file, yes.
	 */
	public function analyzeFile($filename) {
		$this->initialize();
		$t = token_get_all(file_get_contents($filename));
		$total = count($t);
		
		for ($i = 0; $i < $total; $i++) {
			if (is_string($t[$i])) continue;
			list($token, $value) = $t[$i];
			switch ($token) {
				case T_DOC_COMMENT: {
					$this->docblocks[] = $t[$i][1];
				}
				break;

				case T_CLASS: {
					$this->classes[] = $t[$i+2][1];
					if (isset($t[$i+4]) && is_array($t[$i+4]) && $t[$i+4][0] == T_EXTENDS) {
						$parent = "";
						while (is_array($t[$i+1]) && $t[$i+1][0] !== T_WHITESPACE) {
						   $parent .= $t[++$i][1];
						}
					} else {
						$parent = false;
					}
					if ($parent) $this->ancestors[$t[$i+2][1]] = $parent;
				}
				break;
				
				case T_FUNCTION: {
					$this->functions[] = $t[$i+2][1];
				}
			}
		}
	}
}