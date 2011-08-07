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
 * Listing of a relative file path in a directory.
 */
class FileListing {
	private $filename;
	private $basePath;
	private $relativePath;
	private $absolutePath;
	
	public function __construct($file, $basePath=false) {
		if (!$basePath) $basePath = basename($file);
		$this->filename = $file->getFilename();
		$this->relativePath = str_replace($basePath, '', $file->getPathname());
		$this->basePath = basename($basePath) . $this->relativePath;
		$this->absolutePath = $file->getRealPath();
	}

	public function getFilename() {
		return $this->filename;
	}
	
	public function getRelativePath() {
		return $this->relativePath;
	}
	
	public function getBasePath() {
		return $this->basePath;
	}
	
	public function getAbsolutePath() {
		return $this->absolutePath;
	}
}