<?php

class Writer {
	
	function dumpHtml($classes, $docblocks) {
		foreach($classes as $y=>$classname) {
			$str = "<h1>$classname</h1>";
			$str .= "<pre>{$docblocks[$y]}</pre>";
		}
		return $str;
	}	
}