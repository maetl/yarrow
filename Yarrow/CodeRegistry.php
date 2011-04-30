<?php
/**
 * Yarrow {{version}}
 * Simple Documentation Generator
 * <http://yarrowdoc.org>
 *
 * Copyright (c) 2010-2011, Mark Rickerby <http://maetl.net>
 * All rights reserved.
 * 
 * This library is free software; refer to the terms in the LICENSE file found
 * with this source code for details about modification and redistribution.
 */

/**
 * Identity map for ClassModel objects.
 */
class CodeRegistry {
	private $classes;
	
	function __construct() {
		$this->classes = array();
	}
	
	function addClass($object) {
		if (!($object instanceof ClassModel)) return;
		
		$key = $object->getName();
		if (isset($this->classes[$key])) {
			if (!($this->classes[$key] instanceof ConflictedClassModel)) {
				$this->classes[$key] = new ConflictedClassModel($this->classes[$key]);
			}
			$this->classes[$key]->addConflict($object);
		
		} else {
			$this->classes[$key] = $object;
		}
	}
	
	function getClass($key) {
		if (isset($this->classes[$key])) return $this->classes[$key];
	}
	
	function getClasses() {
		return $this->classes;
	}
}