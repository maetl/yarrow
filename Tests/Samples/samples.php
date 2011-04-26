<?php

/**
 * Public: Sample one
 */
class SampleOne {
	
	/**
	 * Plain function, no args
	 */
	function sampleFunctionZero() {
		return true;
	}
	
	/**
	 * Plain function, one arg
	 */
	function sampleFunctionOne($arg1) {
		return true;
	}
	
}

/**
 * Public: Sample two
 */
class SampleTwo {
	
	
	/**
	 * Plain function, three args, one optional
	 */
	function sampleFunctionThree($arg1, $arg2, $arg3="three") {
		return true;
	}
	
	/**
	 * Plain function, one arg with type hint
	 */
	function sampleFunctionHint(string $arghint) {
		return true;
	}
	
}

/**
 * Public: Sample two
 */
class SampleThree {
	
	
	/**
	 * Plain function, three args, one optional
	 */
	function sampleFunctionThree($arg1, $arg2, $arg3="three") {
		return true;
	}
	
	/**
	 * Plain function, one arg with type hint
	 */
	function sampleFunctionHint(string $arghint) {
		return true;
	}
	
}