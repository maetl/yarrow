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
	
	function assertExitSuccess($actual) {
		$this->assertEquals(0, $actual);
	}
	
	function assertExitFailure($actual) {
		$this->assertEquals(1, $actual);
	}
	
	function testVersionMessage() {
		$app = new ConsoleRunner(array('yarrow', '-v'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
	}

	function testVersionMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--version'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
	}	
	
	function testHelpMessage() {
		$app = new ConsoleRunner(array('yarrow', '-h'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testHelpMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--help'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Path to the generated documentation', $output);
		$this->assertContains('Use -o or --option for boolean switches', $output);
	}
	
	function testInvalidOptionMessage() {
		$app = new ConsoleRunner(array('yarrow', '-j'));
		$this->assertExitFailure($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Unrecognized option: -j', $output);
	}
	
	function testInvalidOptionMessageLong() {
		$app = new ConsoleRunner(array('yarrow', '--invalid'));
		$this->assertExitFailure($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('Unrecognized option: --invalid', $output);
	}
	
	function testConfigMessageIfFileNotExists() {
		$app = new ConsoleRunner(array('yarrow', '-c:missing.conf'));
		$this->assertExitFailure($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('File not found: missing.conf', $output);
	}
	
	function testConfigLoadsIfFileExists() {
		$testconfig = dirname(__FILE__).'/Config/.yarrowdoc';
		$app = new ConsoleRunner(array('yarrow', '--config='.$testconfig));
		$this->assertExitSuccess($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertNotContains('File not found', $output);
	}
	
	function testOutputTargetUpdatedFromArgument() {
		$app = new ConsoleRunner(array('yarrow', 'MyDocs'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$config = Configuration::instance();
		$this->assertEquals('MyDocs', $config->outputTarget);	
	}

	function testInputTargetsUpdatedFromArgument() {
		$classpath = dirname(__FILE__).'/../Yarrow';
		$app = new ConsoleRunner(array('yarrow', $classpath, 'MyDocs'));
		$this->assertExitSuccess($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$config = Configuration::instance();
		$this->assertContains($classpath, $config->inputTargets);
		$this->assertEquals('MyDocs', $config->outputTarget);		
	}
	
	function testInputTargetsUpdatedFromArguments() {
		$classpath1 = dirname(__FILE__).'/../Yarrow';
		$classpath2 = dirname(__FILE__).'/Samples';
		$app = new ConsoleRunner(array('yarrow', $classpath1, $classpath2, 'MyDocs'));
		$this->assertExitSuccess($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$config = Configuration::instance();
		$this->assertEquals(2, count($config->inputTargets));
		$this->assertContains($classpath1, $config->inputTargets);
		$this->assertContains($classpath2, $config->inputTargets);
		$this->assertEquals('MyDocs', $config->outputTarget);		
	}
	
	function testInputTargetErrorFromBadArguments() {
		$classpath = dirname(__FILE__).'/../Missing';
		$app = new ConsoleRunner(array('yarrow', $classpath, 'MyDocs'));
		$this->assertExitFailure($app->runApplication());		
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader(), $output);
		$this->assertContains('File not found', $output);
	}

	function testEmptyArgumentsMessage() {
		$app = new ConsoleRunner(array('yarrow'));
		$this->assertExitSuccess($app->runApplication());
		$output = ob_get_contents();
		$this->assertStringStartsWith($this->getVersionHeader() , $output);
		$config = Configuration::instance();
		$this->assertContains($_ENV['PWD'], $config->inputTargets);
		$this->assertEquals($_ENV['PWD'].'/docs', $config->outputTarget);
	}
}