<?php

class ClassWithProperties {
	
	var $_var;
	
	public $_public;
	
	protected $_protected;
	
	private $_private;
	
	public $_boolean = true;
	
	public $_integer = 1;

	public $_decimal = 3.1;
	
	public $_string = "stringalong";
	
	public $_array = array(1, 2, 3);
	
	public $_assoc_array = array(
		'one' => array('one', 'two', 'three'),
		'two' => array('one', 'two', 'three'),
	);
	
	public $_nested_array = array(	
		'one' => array(111, 222, 333),
		'two' => array('one', 'two', array(1,2,3)),		
	);
	
	public $_decl_array = array(
		array(111, 222, 333),
		array(444, 555, 666),
		array(777, 888, 999),	
	);
	
}