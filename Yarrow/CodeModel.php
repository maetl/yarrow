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
 * Base class for code objects.
 */
abstract class CodeModel {
	
	/**
	 * The name declared in the source code for this object.
	 *
	 * @return string
	 */
	abstract public function getName();
	
	/**
	 * Dynamic attribute finder.
	 *
	 * Maps named properties to the corresponding getter method:
	 *
	 * <code>
	 * print $model->name; // calls $model->getName()
	 * print $model->relativeLink; // calls $model->getRelativeLink()
	 * </code>
	 *
	 * @return mixed
	 */
	public function __get($key) {
		$accessor = 'get' . ucfirst($key);
		if (method_exists($this, $accessor)) {
			return $this->$accessor();
		}
	}	
}