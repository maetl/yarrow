<?php

require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {
	
	function testTopLevelFunctionDeclaration() {		
		$tokens = token_get_all(file_get_contents(dirname(__FILE__).'/Samples/sample_function.php'));
		
		$parser = new CodeParser($tokens);
		$parser->parse();
	}
}