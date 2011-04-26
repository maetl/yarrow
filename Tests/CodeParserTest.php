<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {
	
	function tokenizeSampleFile($filename) {
		$path = dirname(__FILE__).'/Samples/'.$filename;
		return token_get_all(file_get_contents($path));
	}
	
	function testTopLevelFunctionDeclaration() {		
		$tokens = $this->tokenizeSampleFile('sample_function.php');
		
		$reader = $this->getMock('CodeReader', array('onFunction'), array('sample_function.php'));
		$reader->expects($this->once())
									->method('onFunction')
									->with('sample_function',
											array('$arg'=>null, // refactor to add default arg values
											));
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseSampleClassFile() {
		$tokens = $this->tokenizeSampleFile('sample.php');
		
		$reader = $this->getMock('CodeReader', array('onClass'), array('sample.class.php'));
		$reader->expects($this->once())->method('onClass')->with('Sample');
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseSamplesClassFile() {
		$tokens = $this->tokenizeSampleFile('samples.php');
		
		$reader = $this->getMock('CodeReader', array('onClass'), array('sample.class.php'));
		$reader->expects($this->exactly(3))->method('onClass');
		$reader->expects($this->at(0))->method('onClass')->with('SampleOne');
		$reader->expects($this->at(1))->method('onClass')->with('SampleTwo');
		$reader->expects($this->at(2))->method('onClass')->with('SampleThree');
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
}