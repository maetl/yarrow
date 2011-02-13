<?php

/**
 * Public: SampleClass
 */
class SampleObject {
	
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
	
	/**
	 * Plain function, two args
	 */
	function sampleFunctionTwo($arg1, $arg2) {
		return true;
	}
	
	
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