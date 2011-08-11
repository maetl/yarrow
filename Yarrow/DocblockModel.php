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

class DocblockModel {
	private $paragraphs;
	private $tags;
	
	function __construct() {
		$this->paragraphs = array();
		$this->tags = array();		
	}
	
	/**
	 * Returns the summary, which is always the first
	 * paragraph or text line declared in the docblock.
	 */
	function getSummary() {
		return (isset($this->paragraphs[0])) ? $this->paragraphs[0] : '';
	}
	
	/**
	 * Returns the description, which is all lines of text following the
	 * summary.
	 */
	function getDescription() {
		return implode("\n\n", array_slice($this->paragraphs, 1));
	}
	
	/**
	 * Returns a plaintext representation of the full comment text.
	 */
	function getText() {
		return implode("\n\n", $this->paragraphs);
	}
	
	function addParagraph($paragraph) {
		$this->paragraphs[] = trim($paragraph);
	}
	
	function addTag($tagline) {
		$this->tags[] = $tagline;
	}
	
	function __toString() {
		return $this->getSummary();
	}
}