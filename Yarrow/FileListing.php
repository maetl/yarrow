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
 * An individual file listing, relative to the base directory of a collection.
 */
class FileListing {
	private $file;
	private $basePath;
	
	public function __construct(SplFileInfo $file, $basePath=false) {
		if (!$basePath) {
			$basePath = basename($file->getFilename());
		}
		$this->file = $file;
		$this->basePath = $basePath;
	}

	/**
	 * @return string filename
	 */
	public function getFilename() {
		return $this->file->getFilename();
	}
	
	/**
	 * @return string relative path to file
	 */
	public function getRelativePath() {
		return str_replace($this->basePath, '', $this->file->getPathname());
	}
	
	/**
	 * @return string relative path to file, including base directory
	 */
	public function getBasePath() {
		return basename($this->basePath) . $this->getRelativePath();
	}
	
	/**
	 * @return string absolute path on the filesystem
	 */
	public function getAbsolutePath() {
		return $this->file->getRealPath();
	}
}