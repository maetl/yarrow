<?php

// Dynamic class definition based on conditional logic
// where supplied constant determines the runtime type.
//
// This is arguably bad practice but it needs to be
// supported.

define('DECLARE_FIRST_TYPE', true);
define('TYPE_TO_DECLARE', 'First');

class FirstType {
	function executeTemplateMethod() {}
}

class SecondType {
	function executeTemplateMethod() {}
}

if (DECLARE_FIRST_TYPE) {
	
	class TypeClassOne extends FirstType {}
	
} else {
	
	class TypeClassOne extends SecondType {}
	
}

switch(TYPE_TO_DECLARE) {

	case 'First':
		class TypeClassA extends FirstType {}
		break;
		
	case 'Second':
		class TypeClassA extends SecondType {}
		break;

}
