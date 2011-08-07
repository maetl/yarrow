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
class DefaultGenerator extends Generator {

	protected function convertToFilename($object) {
		return strtolower(str_replace(' ', '/', str_replace('.php', '', $object)));
	}
	
	protected function getObjectMap() {
		return array(
				'index'  => array('index'),
				'file'   => $this->objectModel->getFiles(),
				'class'  => $this->objectModel->getClasses(),
				'package'=> $this->objectModel->getPackages()
			   );
	}
	
	protected function getTemplateMap() {
		return array(
				'index'  =>  'index.tpl.php',
				'file'   =>  'file.tpl.php',
				'class'  =>  'class.tpl.php',
				'package'=>	 'package.tpl.php'
			   );
	}
	
	protected function getConverter() {
		return new PhpConverter($this->config->options['theme']);
	}
}