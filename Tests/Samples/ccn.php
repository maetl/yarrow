<?php

class CyclomaticComplexityA {
	
	function hasCCNZero() {
		return true;
	}
	
	function hasCCNOne($in) {
		if ($in == true) return false;
	}
	
	function hasCCNTwo($in) {
		if ($in <= 1) {
			return false;
		} elseif ($in > 1) {
			return true;
		}
	}
	
}

class CyclomaticComplexityB {
	
	function hasCCNFive($in, $out) {
		if ($in == 0) {
			return $out;
		} elseif ($in == 1) {
			return $out * 2;
		} elseif ($in == 2) {
			return ($out * 2) * 2;
		} else {
			foreach($in as $i) {
				while($i < count($in)) { $out += $i; $i++; }
			}
			return $out;
		}
	}
	
	function hasCCNTen($in, $out) {
		if ($in == 0) {
			return ($out == 0) ? 0 : 1;
		} elseif ($in == 1) {
			foreach($in as $i) {
				while($i < count($in)) { $out += $i; $i++; }
			}
		} elseif ($in == 2) {
			foreach($in as $i) {
				while($i < count($in)) { $out += $i; $i++; }
			}
		} else {
			foreach($in as $i) {
				while($i < count($in)) { $out += $i; $i++; }
			}
		}
	}
	
}