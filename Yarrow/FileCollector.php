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

abstract class FilePatternFilter extends RecursiveRegexIterator {
	protected $pattern;

	public function __construct(RecursiveIterator $it, $pattern) {
		$this->pattern = $pattern;
		parent::__construct($it, $pattern);
	}

}

class FilePatternIncludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isDir() || preg_match($this->pattern, $this->getFilename()));
	}
}

class FilePatternExcludeFilter extends FilePatternFilter {

	public function accept() {
		return ($this->isDir() || !preg_match($this->pattern, $this->getFilename()));
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
		$pattern = str_replace('.', '\.', $pattern);
		$pattern = str_replace('*', '.+', $pattern);
		$this->includeByPattern("/$pattern$/");
	}

	function excludeByMatch($pattern) {
		$pattern = str_replace('.', '\.', $pattern);
		$pattern = str_replace('*', '.+', $pattern);
		$this->excludeByPattern("/$pattern$/");
	}

	function includeByPattern($pattern) {
		$this->collection = new FilePatternIncludeFilter($this->collection, $pattern);
	}

	function excludeByPattern($pattern) {
		$this->collection = new FilePatternExcludeFilter($this->collection, $pattern);
	}

	function getIterator() {
		return new RecursiveIteratorIterator($this->collection);
	}

	function getManifest() {
		$map = array();
		$files = new RecursiveIteratorIterator($this->collection);
		foreach($files as $file) {
			if ($file->isDir()) continue;
			$map[] = array(
				"filename" 		=> $file->getFilename(),
				"base_path" 	=> $this->base_dir . str_replace($this->base_path, '', $file->getPathname()),
				"relative_path" => str_replace($this->base_path, '', $file->getPathname()),
				"absolute_path" => $file->getRealPath()
			);
		}
		return $map;
	}

}