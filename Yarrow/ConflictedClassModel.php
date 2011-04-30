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
 * Represents a class model conflict where multiple classes with the same
 * name are declared in a project.
 *
 * This will generally happen when classes are defined conditionally.
 * Because we're analyzing the code statically, we can't process all the
 * dynamic stuff that happens at runtime, so we just detect an overlapping
 * class name and store it in a composite object, letting the presentation
 * layer take care of how to present this situation.
 */
class ConflictedClassModel extends ClassModel {
	private $classes = array();
	
	function __construct($class) {
		$this->classes[] = $class;
		parent::__construct($class->getName(), $class->getAncestor());
	}

	function getAncestor() {
		$ancestors = array();
		foreach($this->classes as $class) {
			$ancestors[] = $class->getAncestor();
		}
		return implode(', ', $ancestors);
	}
	
	function addConflict($class) {
		$this->classes[] = $class;
	}
}