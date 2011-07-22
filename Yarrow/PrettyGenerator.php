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
 * Experimental default for testing.
 */
class PrettyGenerator extends Generator {

	protected function convertToFilename($object) {
		return strtolower(str_replace(' ', '/', str_replace('.php', '', $object)));
	}
	
	protected function getObjectMap() {
		return array(
				'index'  => array('index'),
				'file'   => $this->objectModel->getFiles(),
				'class'  => $this->objectModel->getClasses(),
				'function' => $this->objectModel->getFunctions(),
			   );
	}
	
	protected function getTemplateMap() {
		return array(
				'index'  =>  'index.html',
				'file'   =>  'file.html',
				'class'  =>  'class.html',
				'function' => 'function.html'
			   );
	}
	
	protected function getConverter() {
		return new TwigConverter(dirname(__FILE__).'/Themes/Pretty');
	}
}