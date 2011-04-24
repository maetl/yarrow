<?php
/**
 * Yarrow
 * Simple Documentation Generator
 * <http://yarrowdoc.org>
 *
 * Copyright (c) 2010-2011, Mark Rickerby <http://maetl.net>
 * All rights reserved.
 * 
 * This library is free software; refer to the terms in the LICENSE file found
 * with this source code for details about modification and redistribution.
 */

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