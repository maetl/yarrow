<?php

require_once dirname(__FILE__).'/../Yarrow/Autoload.php';

class IdentityMapTest extends PHPUnit_Framework_TestCase {
	
	function testCanStoreObjectsInEmptyMap() {
		$object1 = new ClassModel('MyClass');
		
		$registry = new CodeRegistry();
		$registry->addClass($object1);
		
		$this->assertSame($object1, $registry->getClass('MyClass'));
	}
	
	function testDuplicateObjectsReturnConflictComposite() {
		$object1 = new ClassModel('MyClass', 'MyParent');
		$object2 = new ClassModel('MyClass', 'MyOtherParent');
		
		$registry = new CodeRegistry();
		$registry->addClass($object1);
		$registry->addClass($object2);
		
		$object = $registry->getClass('MyClass');
		
		$this->assertNotSame($object1, $object);
		$this->assertEquals('MyParent, MyOtherParent', $object->getAncestor());
	}
}