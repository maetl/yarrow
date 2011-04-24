<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class DocblockParserTest extends PHPUnit_Framework_TestCase {
	
	function loadDocblock($filename) {
		return file_get_contents(dirname(__FILE__).'/Docblocks/'.$filename);
	}
	
	function testEmptySummary() {
		$parser = new DocblockParser($this->loadDocblock('empty'));
		$parser->parse();
		$this->assertEquals('', $parser->getSummary());
	}
	
	function testSingleLineSummary() {
		$parser = new DocblockParser($this->loadDocblock('singleline'));
		$parser->parse();
		$this->assertEquals('this is a summary', $parser->getSummary());
	}
	
	function testAsciiBorders1Summary() {
		$parser = new DocblockParser($this->loadDocblock('asciiborders1'));
		$parser->parse();
		$this->assertEquals('This is a comment with ASCII borders.', $parser->getSummary());
	}
	
	function testAsciiBorders2Summary() {	
		$parser = new DocblockParser($this->loadDocblock('asciiborders2'));
		$parser->parse();
		$this->assertEquals('This is a comment with ASCII borders.', $parser->getSummary());
	}
	
	function testMultiLineSummary() {
		$parser = new DocblockParser($this->loadDocblock('multiline'));
		$parser->parse();
		$this->assertEquals('This is a comment summary spanning multiple lines.', $parser->getSummary());
	}
	
	function testMultiLinePrefixedSummary() {
		$parser = new DocblockParser($this->loadDocblock('multilineprefixed'));
		$parser->parse();
		$this->assertEquals('This is a comment summary spanning multiple lines.', $parser->getSummary());		
	}
	
	function testMultilineNormalizedText() {
		$parser = new DocblockParser($this->loadDocblock('paragraphs'));
		$parser->parse();
		$expected = "This is a comment summary spanning multiple lines.\n\nThis is an additional paragraph spanning multiple lines.\n\nThis is a final paragraph.";
		$this->assertContains($expected, $parser->getText());
	}
	
	function testMultilinePrefixedNormalizedText() {
		$parser = new DocblockParser($this->loadDocblock('paragraphsprefixed'));
		$parser->parse();
		$expected = "This is a comment summary spanning multiple lines.\n\nThis is an additional paragraph spanning multiple lines.\n\nThis is a final paragraph.";
		$this->assertContains($expected, $parser->getText());
	}
	
}