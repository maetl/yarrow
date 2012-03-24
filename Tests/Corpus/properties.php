<?php

class ClassWithInstanceProperties {
	
	var $myFirst;
	
	public $mySecond;
	
	protected $myThird = false;
	
	private $myFourth = 1;

	private $myFifth = 3.1;
	
	private $mySixth = "stringalong";
	
	private $mySeventh = array(1, 2, 3);
	
	private $myEighth = array(
		'one' => array(888, 999),
		'two' => array('one', 'two', array(1,2,3)),
	);
	
}