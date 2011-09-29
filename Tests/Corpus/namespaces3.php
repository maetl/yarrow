<?php

namespace MyNamespace {

	class MyClass {
	
		function getNamespace() {
			return __NAMESPACE__;
		}
	}
}

namespace {

	class GlobalClass {
	
		function getNamespace() {
			return __NAMESPACE__;
		}
	}

}