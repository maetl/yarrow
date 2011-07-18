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

abstract class FilePatternFilter extends RecursiveFilterIterator {
	protected $pattern;

	public function __construct(RecursiveIterator $it, $pattern) {
		$this->pattern = $pattern;
		parent::__construct($it);
	}
}

class FileIncludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isFile() && fnmatch($this->pattern, $this->getFilename()));
	}
}

class FileExcludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isFile() && !fnmatch($this->pattern, $this->getFilename()));
	}
}

class FilePatternIncludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isFile() && preg_match($this->pattern, $this->getFilename()));
	}
}

class FilePatternExcludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isFile() && !preg_match($this->pattern, $this->getFilename()));
	}
}

class FileCollector {
	private $base_path;
	private $base_dir;
	private $collection;

	function __construct($path) {
		$this->base_path = $path;
		$this->base_dir = basename($path);
		$this->collection = new RecursiveDirectoryIterator($path);
	}
	
	function includeByMatch($pattern) {
		$this->collection = new FileIncludeFilter($this->collection, $pattern);
	}
	
	function excludeByMatch($pattern) {
		$this->collection = new FileExcludeFilter($this->collection, $pattern);
	}

	function includeByPattern($pattern) {
		$this->collection = new FilePatternIncludeFilter($this->collection, $pattern);
	}

	function excludeByPattern($pattern) {
		$this->collection = new FilePatternExcludeFilter($this->collection, $pattern);
	}

	function getManifest() {
		$map = array();
		foreach(new RecursiveIteratorIterator($this->collection) as $file) {
			$map[] = array(
				"filename" => $file->getFilename(),
				"relative_path" => $this->base_dir . str_replace($this->base_path, '', $file->getPathname()),
				"absolute_path" => $file->getRealPath()
			);
		}
		return $map;
	}

}