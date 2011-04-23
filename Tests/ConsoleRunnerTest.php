<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ConsoleRunnerTest extends PHPUnit_Framework_TestCase {
	
	function setUp() {
		ob_start();
	}
	
	function tearDown() {
		ob_end_clean();
	}
	
	function testCalledWithNoArgumentsOutputsErrorMessage() {
		ConsoleRunner::main(array('yarrow'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
		$this->assertContains('No documentation targets.', $output);
	}
	
	function testCalledWithVersionSwitchOutputsVersionHeader() {
		ConsoleRunner::main(array('yarrow', '--version'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
	}
	
	function testCalledWithHelpSwitchOutputsUsageInstructions() {
		ConsoleRunner::main(array('yarrow', '--help'));
		$output = ob_get_contents();
		$this->assertStringStartsWith('Yarrow ' . ConsoleRunner::VERSION, $output);
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
}