<?php
/**
 * Yarrow
 *
 * (c) 2010-2011, Mark Rickerby, <http://maetl.net>
 *
 */

/**
 * Provides a command line interface to the Yarrow application.
 */
class ConsoleRunner {
	const APPNAME = "Yarrow";
	const VERSION = "@@package_version@@";
	
	/**
	 * Main method to run the application.
	 * @param array $arguments a list of command line arguments
	 */
	public static function main($arguments) {
		
		self::printVersion();
		
		$targets = array();
		$options = array();
		$length = count($arguments);
		
		try {
		
			for ($i = 1; $i < $length; $i++) {
				// todo: replace this switch with instance
				//       method of command object.
			    switch($arguments[$i]) {

			        case "-v":
					case "--version":
						return;
			        	break;

			        case "-h":
					case "--help":
						return self::printHelp();
			        	break;

					default:
						if (self::isOption($arguments[$i])) {
							$options[] = self::registerOption($arguments[$i]);
						} else {
							$targets[] = $arguments[$i];
						}
						break;

				}
			
			}		
			
		} catch(ConfigurationError $error) {
			echo $error->getMessage() . PHP_EOL;
			return;
		}
		
		if (count($targets) < 2) {
			return self::printMissing();
		}
	}
	
	/**
	 * Returns true if the given argument is a configuration option.
	 * @return boolean
	 */
	public static function isOption($argument) {
		return (substr($argument, 0, 1) == '-');
	}
	
	/**
	 * Map of enabled configuration options.
	 */
	private static $enabledOptions = array(
		'h' => 'help',
		'v' => 'version',
	);
	
	/**
	 * Registers an option passed in to the application.
	 */
	public static function registerOption($option) {
		$optionName = str_replace('-', '', $option);
		if (substr($option, 0, 2) != '--') {
			if (isset(self::$enabledOptions[$optionName])) {
				return self::$enabledOptions[$optionName];
			}
		} else {
			if (in_array($optionName, self::$enabledOptions)) {
				return $optionName;
			}
		}
		throw new ConfigurationError("Unrecognized option $option.");
	}
	
	/**
	 * Show an error message for missing documentation targets when
	 * input and output paths are incorrectly supplied.
	 */
	private static function printMissing() {
		echo "No documentation targets. You must specify <input> and <output> paths." . PHP_EOL;
	}
	
	/**
	 * Show the version header.
	 */
	private static function printVersion() {
		echo implode(" ", array(self::APPNAME, self::VERSION, PHP_EOL, PHP_EOL));
	}
	
	/**
	 * Show the help information.
	 */
	private static function printHelp() {
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