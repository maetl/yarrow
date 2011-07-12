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
 * Base class for implementing string scanners.
 */
abstract class Scanner {

	/**
	 * @param string content to parse
	 */
	protected function __construct($content) {
		$this->content = $content;
		$this->length = strlen($this->content);
		$this->cursor = 0;
	}

	/**
	 * Scans forward along the content sequence until cursor reaches the given string.
	 */
	protected function scanUntil($string) {
		$anchor = $this->cursor;
		while ($this->cursor < $this->length && strpos($string, $this->content{$this->cursor}) === false) {
			$this->cursor++;
		}
		return substr($this->content, $anchor, $this->cursor - $anchor);
	}

	/**
	 * Scan cursor forward a single character.
	 */
	protected function scanForward() {
		if ($this->cursor < $this->length) {
			return $this->content{$this->cursor++};
		}
	}

	/**
	 * Skip forward a single character without returning.
	 */
	protected function skipForward() {
		if ($this->cursor < $this->length) $this->cursor++;
	}

	/**
	 * Skips the cursor backwards by one character.
	 */
	protected function skipBack() {
		if ($this->cursor < $this->length) $this->cursor--;
	}

}