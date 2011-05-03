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

class MethodModel extends FunctionModel {
	private $visibility;
	private $final;
	private $abstract;
	
	public function __construct($name, $arguments=array(), $keywords=array()) {
		parent::__construct($name, $arguments, $keywords);
		$this->visibility = (isset($keywords['visibility'])) ? $keywords['visibility'] : 'public';
		$this->abstract = (isset($keywords['abstract'])) ? true : false;
		$this->final = (isset($keywords['final'])) ? true : false;
	}
	
	public function isPublic() {
		return ($this->visibility == 'public');
	}
	
	public function isProtected() {
		return ($this->visibility == 'protected');
	}
	
	public function isPrivate() {
		return ($this->visibility == 'private');
	}
	
	public function isVisible() {
		return ($this->visibility == 'public');
	}
	
	public function isAbstract() {
		return $this->abstract;
	}
	
	public function isFinal() {
		return $this->final;
	}	
}