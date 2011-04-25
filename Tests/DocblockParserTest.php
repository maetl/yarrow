<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class DocblockParserTest extends PHPUnit_Framework_TestCase {
	
	function loadDocblock($filename) {
		return file_get_contents(dirname(__FILE__).'/Docblocks/'.$filename);
	}
	
	function testEmptySummary() {
		$parser = new DocblockParser($this->loadDocblock('empty'));
		$docblock = $parser->parse();
		$this->assertEquals('', $docblock->getSummary());
	}
	
	function testSingleLineSummary() {
		$parser = new DocblockParser($this->loadDocblock('singleline'));
		$docblock = $parser->parse();
		$this->assertEquals('this is a summary', $docblock->getSummary());
	}
	
	function testAsciiBorders1Summary() {
		$parser = new DocblockParser($this->loadDocblock('asciiborders1'));
		$docblock = $parser->parse();
		$this->assertEquals('This is a comment with ASCII borders.', $docblock->getSummary());
	}
	
	function testAsciiBorders2Summary() {	
		$parser = new DocblockParser($this->loadDocblock('asciiborders2'));
		$docblock = $parser->parse();
		$this->assertEquals('This is a comment with ASCII borders.', $docblock->getSummary());
	}
	
	function testMultiLineSummary() {
		$parser = new DocblockParser($this->loadDocblock('multiline'));
		$docblock = $parser->parse();
		$this->assertEquals('This is a comment summary spanning multiple lines.', $docblock->getSummary());
	}
	
	function testMultiLinePrefixedSummary() {
		$parser = new DocblockParser($this->loadDocblock('multilineprefixed'));
		$docblock = $parser->parse();
		$this->assertEquals('This is a comment summary spanning multiple lines.', $docblock->getSummary());		
	}
	
	function testMultilineNormalizedText() {
		$parser = new DocblockParser($this->loadDocblock('paragraphs'));
		$docblock = $parser->parse();
		$expected = "This is a comment summary spanning multiple lines.\n\nThis is an additional paragraph spanning multiple lines.\n\nThis is a final paragraph.";
		$this->assertContains($expected, $docblock->getText());
	}
	
	function testMultilinePrefixedNormalizedText() {
		$parser = new DocblockParser($this->loadDocblock('paragraphsprefixed'));
		$docblock = $parser->parse();
		$expected = "This is a comment summary spanning multiple lines.\n\nThis is an additional paragraph spanning multiple lines.\n\nThis is a final paragraph.";
		$this->assertContains($expected, $docblock->getText());
	}
	
}