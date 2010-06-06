<?php

class Writer {
	
	function dumpHtml($classes, $docblocks) {
		foreach($classes as $y=>$class) {
			$str = "<h1>$class</h1>";
			$str .= "<pre>{$class->getDoc()}</pre>";
		}
		return $str;
	}	
}