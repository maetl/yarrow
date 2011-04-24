<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ConsoleRunnerTest extends PHPUnit_Framework_TestCase {
	
	function setUp() {
		ob_start();
	}
	
	function tearDown() {
		ob_end_clean();
	}
	
	function testEmptyArgumentsMessage() {
		ConsoleRunner::main(array('yarrow'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
		$this->assertContains('No documentation targets.', $output);
	}
	
	function testVersionMessage() {
		ConsoleRunner::main(array('yarrow', '-v'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
	}

	function testVersionMessageLong() {
		ConsoleRunner::main(array('yarrow', '--version'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
	}	
	
	function testHelpMessage() {
		ConsoleRunner::main(array('yarrow', '-h'));
		$output = ob_get_contents();
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testHelpMessageLong() {
		ConsoleRunner::main(array('yarrow', '--help'));
		$output = ob_get_contents();
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testInvalidOptionMessage() {
		ConsoleRunner::main(array('yarrow', '-j'));
		$output = ob_get_contents();
		$this->assertContains('Unrecognized option -j', $output);
	}
	
	function testInvalidOptionMessageLong() {
		ConsoleRunner::main(array('yarrow', '-jnvalid'));
		$output = ob_get_contents();
		$this->assertContains('Unrecognized option -jnvalid', $output);
	}
	
}