<?php
/**
 * Yarrow
 *
 * (c) 2010-2011, Mark Rickerby, <http://maetl.net>
 *
 */

class ConsoleRunner {
	const APPNAME = "Yarrow";
	const VERSION = "@@package_version@@";
	
	public static function main($arguments) {
		
		self::printVersionHeader();
		
		$targets = array();
		$options = array();
		$length = count($arguments);
		
		for ($i = 1; $i < $length; $i++) {
			
		    switch($arguments[$i]) {
				
		        case "-v": case "--version":
					return;
		        	break;
				
		        case "-h": case "--help":
					return self::printHelpMessage();
		        	break;
		
				default:
					if (self::isOption($arguments[$i])) {
						// parseOption;
					} else {
						$targets[] = $arguments[$i];
					}
					break;
				
			}
		}
		
		if (count($targets) < 2) {
			return self::printUsageMessage();
		}
	}
	
	public static function isOption($argument) {
		return (substr($argument, 0, 1) == '-');
	}
	
	private static function printUsageMessage() {
		echo PHP_EOL . PHP_EOL . "No documentation targets." . PHP_EOL;
	}
	
	private static function printVersionHeader() {
		echo implode(" ", array(self::APPNAME, self::VERSION));
	}
	
	private static function printHelpMessage() {
		echo <<<HELP


Usage:

 $ yarrow <input> <output> [options]

 <input>  - Path to PHP code files or an individual PHP file.
 <output> - Path to the generated documentation. If the directory does 
            not exist, it is created. If it does exist, it is overwritten.

 Options

  Use -o or --option for boolean switches and --option=value or --option:value
  for options that require an explicit value to be set.

  -h    --help     [switch]   Display this help message and exit.
  -v    --version  [switch]   Display version header and exit.


HELP;
	}
}