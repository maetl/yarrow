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

class PropertyModel extends CodeModel {
	private $name;
	private $keywords;
	private $default;
	
	function __construct($name, $keywords=array(), $default=false) {
		$this->name = $name;
		$this->keywords = $keywords;
		$this->default = $default;
	}
	
	public function getName() {
		return $this->name;
	}
	
	public function isPublic() {
		return ($this->keywords['visibility'] == 'public');
	}
	
	public function isProtected() {
		return ($this->keywords['visibility'] == 'protected');
	}
	
	public function isPrivate() {
		return ($this->keywords['visibility'] == 'private');
	}
	
}