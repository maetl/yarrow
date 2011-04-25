<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ConsoleRunnerTest extends PHPUnit_Framework_TestCase {
	
	function setUp() {
		ob_start();
	}
	
	function tearDown() {
		ob_end_clean();
	}
	
	function getVersionHeader() {
		return ConsoleRunner::APPNAME . ' ' . ConsoleRunner::VERSION;
	}
	
	function testEmptyArgumentsMessage() {
		$app = new ConsoleRunner(array('yarrow'));
		$app->runApplication();
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader() , $output);
		// inputTarget should equal .
		// outputTarget should equal /docs
	}
	
	function testVersionMessage() {
		$app = new ConsoleRunner(array('yarrow', '-v'));
		$this->assertTrue($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
	}

	function testVersionMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--version'));
		$this->assertTrue($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
	}	
	
	function testHelpMessage() {
		$app = new ConsoleRunner(array('yarrow', '-h'));
		$this->assertTrue($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testHelpMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--help'));
		$this->assertTrue($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testInvalidOptionMessage() {
		$app = new ConsoleRunner(array('yarrow', '-j'));
		$this->assertFalse($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Unrecognized option: -j', $output);
	}
	
	function testInvalidOptionMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--invalid'));
		$this->assertFalse($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Unrecognized option: --invalid', $output);
	}
	
	function testConfigMessageIfFileNotExists() {
		$app = new ConsoleRunner(array('yarrow', '-c:missing.conf'));
		$this->assertFalse($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('File not found: missing.conf', $output);
	}
	
	function testConfigLoadsIfFileExists() {
		$testconfig = dirname(__FILE__).'/Config/.yarrowdoc';
		$app = new ConsoleRunner(array('yarrow', '--config='.$testconfig));
		$this->assertTrue($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertNotContains('File not found', $output);
	}
	
}