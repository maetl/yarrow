<?php

/**
 * Deprecated reference operator hack from legacy PHP versions.
 */
class Ampersand {
	
	function &hasReferenceSymbol() {
		return array('deprecated');
	}
	
	function	& annoyingWhitespace	($argument) { return false; }
}