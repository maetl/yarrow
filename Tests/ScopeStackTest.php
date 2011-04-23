<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class ScopeStackTest extends PHPUnit_Framework_TestCase {
	
	function testNewStackIsEmpty() {
		$stack = new ScopeStack();
		$this->assertEquals(0, $stack->nestingLevel());
	}
	
	function testPushCreatesNewCount() {
		$stack = new ScopeStack();
		$stack->push(new stdClass());
		$this->assertEquals(1, $stack->nestingLevel());
		$stack->push(new stdClass());
		$this->assertEquals(2, $stack->nestingLevel());
	}
	
	function testPeekReturnsReferenceToTopElement() {
		$stack = new ScopeStack();
		$first = new stdClass();
		$first->property = "first";
		$second = new stdClass();
		$second->property = "second";
		
		$stack->push($first);
		$stack->push($second);
		$this->assertEquals(2, $stack->nestingLevel());
		
		$element1 = $stack->peek();
		$this->assertEquals(2, $stack->nestingLevel());
		
		$element2 = $stack->pop();
		$this->assertEquals(1, $stack->nestingLevel());
		
		$this->assertEquals("second", $element1->property);
		$this->assertSame($element1, $element2);
	}
	
	function testPushAndPopResetsCount() {
		$stack = new ScopeStack();
		$first = new stdClass();
		$first->property = "first";
		$second = new stdClass();
		$second->property = "second";
		$stack->push($first);
		$stack->push($second);
		$stack->pop();
		$this->assertEquals(1, $stack->nestingLevel());
	}
	
	// todo: behavior of stack when empty/null elements
}