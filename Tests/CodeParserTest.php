<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {

	function tokenizeSampleFile($filename) {
		$path = dirname(__FILE__).'/'.$filename;
		return token_get_all(file_get_contents($path));
	}
	
	function getMockReader($file) {
		$constructor = array(new PackageModel(__CLASS__), new FileModel($file));
		return $this->getMockBuilder('CodeReader')
					->setConstructorArgs($constructor)
					->getMock();
	}

	function testTopLevelFunctionDeclaration() {
		$file = 'Samples/sample_function.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		$reader->expects($this->once())
									->method('onFunction')
									->with('sample_function',
											array('$arg'=>null, // refactor to add default arg values
											));

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseSampleClassFile() {
		$file = 'Samples/sample.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->once())->method('onClass')->with('Sample');
		$reader->expects($this->exactly(5))->method('onMethod');
		$reader->expects($this->exactly(5))->method('onMethodEnd');

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseSamplesClassFile() {
		$file = 'Samples/samples.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

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
		$file = 'Corpus/ampersand.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->at(1))->method('onMethod')->with('hasReferenceSymbol');
		$reader->expects($this->at(3))->method('onMethod')->with('annoyingWhitespace', array('$argument'=>null));

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseConditionallyDeclaredClasses() {
		$file = 'Corpus/conditionally.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->exactly(6))->method('onClass');

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseInterfaces() {
		$file = 'Samples/SampleInterface.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->exactly(1))->method('onClass')
										   ->with('SampleInterface', ClassModel::BASE_TYPE);

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseMultipleInheritanceInterfaces() {
		$file = 'Corpus/implements.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->at(0))->method('onClass')
									  ->with('TypeA', ClassModel::BASE_TYPE, array('interface' => true));

		$reader->expects($this->at(9))->method('onClass')
									  ->with('TypeD', 'TypeC', array('interface' => true));

		$reader->expects($this->at(12))->method('onClass')
									  ->with('KlassA', ClassModel::BASE_TYPE, array('implements' => 'TypeA'));


		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseAbstractTypes() {
		$file ='Corpus/abstract.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->at(0))->method('onClass')
									  ->with('AbstractBase', ClassModel::BASE_TYPE, array('abstract' => true));

		$reader->expects($this->at(3))->method('onMethod')
									  ->with('getType', array(), array('abstract' => true, 'visibility' => 'public'));

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseKeywordVariants() {
		$file = 'Corpus/keywords.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->at(0))->method('onClass')
									  ->with('FinalStatic', ClassModel::BASE_TYPE, array('final' => true));

		$reader->expects($this->at(1))->method('onMethod')
									  ->with('hello', array('$a'=> ''), array('static' => true, 'visibility' => 'public'));


		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseClassInstanceProperties() {
		$file = 'Corpus/properties.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->at(1))->method('onProperty')->with('$myFirst', array('visibility' => 'public'));
		$reader->expects($this->at(2))->method('onProperty')->with('$mySecond', array('visibility' => 'public'));
		$reader->expects($this->at(3))->method('onProperty')->with('$myThird', array('visibility' => 'protected'));
		$reader->expects($this->at(4))->method('onProperty')->with('$myFourth', array('visibility' => 'private', 'default' => NodeBuilder::integer('1')));
		$reader->expects($this->at(5))->method('onProperty')->with('$myFifth', array('visibility' => 'private', 'default' => NodeBuilder::decimal('3.1')));
		$reader->expects($this->at(6))->method('onProperty')->with('$mySixth', array('visibility' => 'private', 'default' => NodeBuilder::string('"stringalong"')));
		$reader->expects($this->at(7))->method('onProperty')->with('$mySeventh', array('visibility' => 'private', 'default' => NodeBuilder::arrayList(array(NodeBuilder::integer('1'), NodeBuilder::integer('2'), NodeBuilder::integer('3')))));
		$reader->expects($this->at(8))->method('onProperty')->with('$myEighth', array('visibility' => 'private', 'default' => NodeBuilder::arrayList(array(NodeBuilder::arrayIndex("'one'", NodeBuilder::arrayList(array(NodeBuilder::integer('888'), NodeBuilder::integer('999')))), NodeBuilder::arrayIndex("'two'", NodeBuilder::arrayList(array(NodeBuilder::string("'one'"), NodeBuilder::string("'two'"), NodeBuilder::arrayList(array(NodeBuilder::integer('1'), NodeBuilder::integer('2'), NodeBuilder::integer('3'))))))))));

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseClassConstants() {
		$file = 'Corpus/constants.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->at(1))->method('onConstant')->with('FIXEDVALUE', 'true');
		$reader->expects($this->at(2))->method('onConstant')->with('NAME', '\'NAME\'');
		$reader->expects($this->at(3))->method('onConstant')->with('NUMBER', '999');

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}

	function testCanParseGlobalConstants() {
		$file = 'Corpus/defines.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);

		$reader->expects($this->at(0))->method('onConstant')->with('GLOBAL_CONST', 'true');
		$reader->expects($this->at(1))->method('onConstant')->with('NUMBER_CONST', '999');
		$reader->expects($this->at(2))->method('onConstant')->with('STRING_CONST', '\'this is a string\'');

		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseClassLevelDocblocks() {
		$file = 'Corpus/classdoc.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->at(0))->method('onFileHeader');
		$reader->expects($this->at(1))->method('onClass');
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
	
	function testCanParseFileLevelDocblocks() {
		$file = 'Corpus/filedoc.php';
		$tokens = $this->tokenizeSampleFile($file);
		$reader = $this->getMockReader($file);
		
		$reader->expects($this->once())->method('onFileHeader')
			   ->with($this->stringContains('Summary for file.'));
		
		$parser = new CodeParser($tokens, $reader);
		$parser->parse();
	}
}