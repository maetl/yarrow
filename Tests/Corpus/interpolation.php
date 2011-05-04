<?php

$globalObject = new stdClass;
$globalObject->buffer = (string)2*2*2*2*2*2*2;
$globalStringy = "Hello {$global->object}";
$value = "actual value";
$meta = "placeholder";
$globalMeta = "Hello ${meta}...";

class Stringify {
	
	private $stringification = 'actual value';
	
	private $variability = 'stringification';
	
	function process() {
		return "Stringify: {$this->variability}";
	}
	
	function generate() {
		return "{$this->$variablity}";
	}
	
}