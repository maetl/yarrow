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
 * Identity map for CodeModel objects.
 */
class CodeRegistry {
	public $classes;
	public $packages;
	public $files;
	
	/**
	 * Holder for singleton instance.
	 */
	private static $instance = false;
	
	/**
	 * Returns a single instance of an application-wide identity map.
	 * @return CodeRegistry
	 */
	public static function instance() {
		if (!self::$instance) {
			self::$instance = new CodeRegistry();
		}
		return self::$instance;
	}
	
	/**
	 * Reset the registry to empty state.
	 */
	public static function reset() {
		self::$instance = new CodeRegistry();
	}
	
	function __construct() {
		$this->classes = array();
		$this->packages = array();
	}
	
	public static function createPackage($name) {
		$registry = self::instance();
		$package = $registry->getPackage($name);
		if (!$package) {
			$package = new PackageModel($name);
			$registry->addPackage($package);
		}
		return $package;
	}
	
	public static function getPackages() {
		$registry = self::instance();
		return ($registry->packages) ? array_values($registry->packages) : array();
	}
	
	public static function createClass($name, $extends, $keywords) {
		$registry = self::instance();
		$class = $registry->getClass($name);
		if (!$class) {
			$class = new ClassModel($name, $extends, $keywords);
			$registry->addClass($class);
		} elseif ($class->getParent() != $extends) {
			$class->addConflict($extends);
		}
		return $class;
	}
	
	public static function getClasses() {
		$registry = self::instance();
		return ($registry->classes) ? array_values($registry->classes) : array();
	}
	
	public static function createFile($filename) {
		$registry = self::instance();
		$file = $registry->getFile($filename);
		if (!$file) {
			$file = new FileModel($filename);
			$registry->addFile($file);
		}
		return $file;
	}
	
	public static function getFiles() {	
		$registry = self::instance();
		return ($registry->files) ? array_values($registry->files) : array();
	}
	
	function addClass($object) {
		if (!($object instanceof ClassModel)) return;
		
		$key = $object->getName();
		if (!isset($this->classes[$key])) {
			$this->classes[$key] = $object;
		}
	}
	
	function getClass($key) {
		if (isset($this->classes[$key])) return $this->classes[$key];
	}
	
	function addPackage($object) {
		if (!($object instanceof PackageModel)) return;
		
		$key = $object->getName();
		if (!isset($this->packages[$key])) {
			$this->packages[$key] = $object;
		}
	}
	
	function getPackage($key) {
		if (isset($this->packages[$key])) return $this->packages[$key];
	}
	
	function addFile($object) {
		if (!($object instanceof FileModel)) return;
		
		$key = $object->getName();
		if (!isset($this->files[$key])) {
			$this->files[$key] = $object;
		}
	}
	
	function getFile($key) {
		if (isset($this->files[$key])) return $this->files[$key];
	}

}