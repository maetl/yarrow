<?php

class ScopeStack {
	private $elements;
	
	public function __construct() {
		$this->elements = array();
	}
	
	public function push($element) {
		return array_push($this->elements, $element);
	}
	
	public function pop() {
		return array_pop($this->elements);
	}
	
	public function peek() {
		return end($this->elements);
	}
	
	public function nestingLevel() {
		return count($this->elements);
	}
}