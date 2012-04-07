<?php

function multiplier($arg) {
	return function() {
		return $arg * $arg;
	}
}

class ClosureS {
	
	public function getMultiplier($arg) {
		return multiplier($arg);
	}
	
}