<?php

require_once dirname(__FILE__).'/../Yarrow/Doc.php';

class CodeParserTest extends PHPUnit_Framework_TestCase {
	
	function testTopLevelFunctionDeclaration() {
		
		$sample = "<?php
			/**
			 * This is a sample function in the top level namespace.
			 */
			function sample_func() { return true; }";
		
		$tokens = token_get_all($sample);
		
		$parser = new CodeParser($tokens);
		$parser->parse(); // FIX THIS!!
	}
}