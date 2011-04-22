<?php
/**
 * Yarrow
 *
 * (c) 2010-2011, Mark Rickerby, <http://maetl.net>
 *
 */

class ConsoleRunner {
	
	public static function main() {
		
		for ($i = 1; $i < $_SERVER["argc"]; $i++) {
			
		    switch($_SERVER["argv"][$i]) {
				
		        case "-v":
		        case "--version":
		            self::printVersion();
		        break;
				
		        case "-h":
		        case "--help":
		            self::printHelp();
		        break;
				
				case "-d";
				case "--dry":
					self::printLine("add option, dry run...");
				break;
		    }
		
		}
	}
	
	const EOL = "\n";
	
	private static function printLine($line) {
		echo $line . self::EOL;
	}
	
	private static function printVersion() {
		echo "Yarrow " . file_get_contents('VERSION') . self::EOL . self::EOL;
	}
	
	private static function printHelp() {
		echo file_get_contents('README') . self::EOL;
	}
	
	public function __construct($args) {
		
	}
	
	public function isOption($argument) {
		return (substr($argument, 0, 1) == '-');
	}
}