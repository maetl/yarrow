<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {
	
	function tokenizeSampleFile($filename) {
		$path = dirname(__FILE__).'/'.$filename;
		return token_get_all(file_get_contents($path));
	}
	
	function testTopLevelFunctionDeclaration() {		
		$tokens = $this->tokenizeSampleFile('Samples/sample_function.php');
		
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
		$tokens = $this->tokenizeSampleFile('Samples/sample.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));
		$reader->expects($this->once())->method('onClass')->with('Sample');
		$reader->expects($this->exactly(5))->method('onMethod');
		$reader->expects($this->exactly(5))->method('onMethodEnd');
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseSamplesClassFile() {
		$tokens = $this->tokenizeSampleFile('Samples/samples.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));
		$reader->expects($this->at(0))->method('onClass')->with('SampleOne');
		$reader->expects($this->at(1))->method('onMethod')->with('hasCCNZero');
		$reader->expects($this->at(2))->method('onMethodEnd');
		$reader->expects($this->at(3))->method('onMethod')->with('hasCCNOne', array('$in'=>null));
		$reader->expects($this->at(4))->method('onMethodEnd');
		$reader->expects($this->at(5))->method('onMethod')->with('hasCCNTwo', array('$in'=>null));
		$reader->expects($this->at(6))->method('onMethodEnd');
		$reader->expects($this->at(7))->method('onClassEnd');
		$reader->expects($this->at(8))->method('onClass')->with('SampleTwo');
		$reader->expects($this->at(9))->method('onMethod')->with('hasCCNFive', array('$in'=>null, '$out'=>null));
		$reader->expects($this->at(10))->method('onMethodEnd');
		$reader->expects($this->at(11))->method('onClassEnd');
		$reader->expects($this->at(12))->method('onClass')->with('SampleThree');
		$reader->expects($this->at(13))->method('onMethod')->with('hasCCNTen', array('$in'=>null, '$out'=>null));
		$reader->expects($this->at(14))->method('onMethodEnd');
		$reader->expects($this->at(15))->method('onClassEnd');
		
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseDeprecatedReferenceOperator() {
		$tokens = $this->tokenizeSampleFile('Corpus/ampersand.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));
		$reader->expects($this->at(1))->method('onMethod')->with('hasReferenceSymbol');
		$reader->expects($this->at(3))->method('onMethod')->with('annoyingWhitespace', array('$argument'=>null));
	
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseConditionallyDeclaredClasses() {
		$tokens = $this->tokenizeSampleFile('Corpus/conditionally.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));
		$reader->expects($this->exactly(6))->method('onClass');
	
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseInterfaces() {
		$tokens = $this->tokenizeSampleFile('Samples/SampleInterface.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));
		$reader->expects($this->exactly(1))->method('onClass')
										   ->with(
												  'SampleInterface',
												  ClassModel::BASE_TYPE
												 );
	
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseMultipleInheritanceInterfaces() {
		$tokens = $this->tokenizeSampleFile('Corpus/implements.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));

		$reader->expects($this->at(0))->method('onClass')
									  ->with(
										 'TypeA',
										 ClassModel::BASE_TYPE,
										 array('interface' => true)
										);
										
		$reader->expects($this->at(9))->method('onClass')
									  ->with(
										 'TypeD',
										 'TypeC',
										 array('interface' => true)
										);
										
		$reader->expects($this->at(12))->method('onClass')
									  ->with(
										 'KlassA',
										 ClassModel::BASE_TYPE,
										 array('implements' => 'TypeA')
										);
										   
	
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseAbstractTypes() {
		$tokens = $this->tokenizeSampleFile('Corpus/abstract.php');
		
		$methods = array('onClass', 'onMethod', 'onMethodEnd', 'onClassEnd');
		$reader = $this->getMock('CodeReader', $methods, array('sample.php'));

		$reader->expects($this->at(0))->method('onClass')
									  ->with(
										 'AbstractBase',
										 ClassModel::BASE_TYPE,
										 array('abstract' => true)
										);
										
		$reader->expects($this->at(3))->method('onMethod')
									  ->with(
										 'getType',
										  array(),
										  array(
										    'abstract' => 'abstract',
										    'visibility' => 'public'	
										  )
										);
										   
	
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
}