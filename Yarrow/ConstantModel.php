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

class ConstantModel extends CodeModel {
	private $name;
	private $value;

	public function __construct($name, $value) {
		$this->name = $name;
		$this->value = $value;
	}

	public function getName() {
		return $this->name;
	}

	public function getValue() {
		return $this->value;
	}

}