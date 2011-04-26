<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {
	
	function tokenizeSampleFile($filename) {
		$path = dirname(__FILE__).'/Samples/'.$filename;
		return token_get_all(file_get_contents($path));
	}
	
	function testTopLevelFunctionDeclaration() {		
		$tokens = $this->tokenizeSampleFile('sample_function.php');
		
		$listener = new CodeListener();
		$listener->addFile('Samples/sample_function.php');
		
		$parser = new CodeParser($tokens, $listener);
		$parser->parse();
	}
	
	function testCanParseSampleClassFile() {
		$tokens = $this->tokenizeSampleFile('sample.php');
		
		$file = $this->getMock('FileModel', array('addClass'), array('sample.class.php'));
		$file->expects($this->once())->method('addClass')->with($this->isInstanceOf('ClassModel'));
		
		$parser = new CodeParser($tokens, $file);
		$parser->parse();
	}
	
	function testCanParseSamplesClassFile() {
		$tokens = $this->tokenizeSampleFile('samples.php');
		
		$file = $this->getMock('FileModel', array('addClass'), array('sample.class.php'));
		$file->expects($this->exactly(3))->method('addClass')->with($this->isInstanceOf('ClassModel'));
		
		$parser = new CodeParser($tokens, $file);
		$parser->parse();
	}
	
}