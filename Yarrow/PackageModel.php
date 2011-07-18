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
 * Represents a package, namespace, or code module, which may depend on the
 * particular conventions used by a project.
 */
class PackageModel extends CodeModel {
	private $name;
	
	function __construct($name) {
		$this->name = $name;
	}
	
	public function getName() {
		return $this->name;
	}
	
}