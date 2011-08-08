<?php

class AmpersandAsReferenceHack {
	
	function &hasReferenceSymbol() {
		return array('deprecated');
	}
	
	function	& annoyingWhitespace	($argument) { return false; }
}