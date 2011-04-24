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
 * A basic parser for extended comment blocks with embedded documentation.
 *
 * The parser is unaware of the context of the docblock in the source file, and
 * simply strips whatever structure it can find out of the string, without enforcing 
 * a particular commenting syntax.
 *
 * Further work would involve supporting multiple syntax styles in the comments (such
 * as embedded HTML, TomDoc, and phpDocumentor).
 */
class DocblockParser {
	private $source;
	
	/**
	 * @param $docblock string
	 */
	function __construct($docblock) {
		$this->source = $this->preProcess($docblock);
		$this->paragraphs = array();
		$this->tags = array();
	}
	
	/**
	 * Normalizes line breaks and cleans comment syntax off the start and end of the string.
	 */
	function preProcess($docblock) {
		$docblock = str_replace("\r\n", "\n", $docblock);
		$docblock = str_replace("\r", "\n", $docblock);
		$docblock = str_replace("/*", "", $docblock);
		$docblock = str_replace("*/", "", $docblock);
		$docblock = preg_replace("/[\*=\-]+/", "", $docblock);
		return $docblock;
	}
	
	/**
	 * Returns the summary description, which is always the first
	 * paragraph or text line declared in the docblock.
	 */
	function getSummary() {
		return (isset($this->paragraphs[0])) ? $this->paragraphs[0] : '';
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
	
	function isTag($line) {
		return substr($line, 0, 1) == '@';
	}
	
	function parseTag($line) {
		
	}
	
	function parseLine($line) {
		$line = trim(str_replace("*", "", trim($line)));
		if ($line == "" && $this->buffer != "") {
			$this->addParagraph($this->buffer);
			$this->buffer = "";
		} else {
			if ($line != "") {
				if ($this->isTag($line)) {
					$this->parseTag($line);
				} else {
					$this->buffer .= " " . $line;
				}
			}
		}
	}
	
	/**
	 * Parse the docblock and extract text descriptions and tags.
	 */
	function parse() {
		if (strstr($this->source, "\n")) {
			$lines = explode("\n", $this->source);
			$this->buffer = "";
			foreach($lines as $line) {
				$this->parseLine($line);	
			}
		} else {
			$this->addParagraph($this->source);
		}
	}
}