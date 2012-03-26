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
		'one' => array(888, 999),
		'two' => array('one', 'two', array(1,2,3)),
	);
	
}