<?php
/**
 * Yarrow {{version}}
 * Simple Documentation Generator
 * <http://yarrowdoc.org>
 *
 * Copyright (c) 2010-2011, Mark Rickerby <http://maetl.net>
 * All rights reserved.
 * 
 * This library is free software; refer to the terms in the LICENSE file found
 * with this source code for details about modification and redistribution.
 */

/**
 * Provides a command line interface to the Yarrow application.
 */
class ConsoleRunner {
	const APPNAME = '{{appname}}';
	const VERSION = '{{version}}';

	/**
	 * Map of enabled configuration options.
	 */
	private static $enabledOptions = array(
		'h' => 'help',
		'v' => 'version',
		'c' => 'config'
	);
	
	/**
	 * Main method to run the application.
	 * @param array $arguments list of command line arguments
	 */
	public static function main($arguments) {
		$yarrow = new ConsoleRunner($arguments);
		$yarrow->runApplication();
	}

	/**
	 * @param array $arguments list of command line arguments
	 */
	private function __construct($arguments) {
		$this->inputTarget = false;
		$this->outputTarget = false;
		$this->options = array();
		$this->arguments = $arguments;
	}

	/**
	 * Runs the application and applies selected commands.
	 */
	private function runApplication() {
		self::printVersion();
		
		$this->processArguments();
		
		if ($this->hasOption('version')) {
			return;
		}
		
		if ($this->hasOption('help')) {
			return self::printHelp();
		}
		
		if ($this->hasOption('config')) {
			$config = $this->getOption('config');
		}
	}
	
	/**
	 * Returns true if the given argument is a configuration option.
	 * @return boolean
	 */
	public function isOption($argument) {
		return (substr($argument, 0, 1) == '-');
	}
	
	/**
	 * Registers an option passed in to the application.
	 */
	private function registerOption($option) {
		$option = str_replace('=', ':', $option);
		if (strstr(':', $option)) {
			$optionParts = explode(':', $option);
			$option = $optionParts[0];
			$optionValue = $optionParts[1];
		} else {
			$optionValue = true;
		}
		
		$optionName = str_replace('-', '', $option);
		
		if (substr($option, 0, 2) != '--') {
			if (isset(self::$enabledOptions[$optionName])) {
				$optionKey = self::$enabledOptions[$optionName];
				return $this->options[$optionKey] = $optionValue;
			}
		} else {
			if (in_array($optionName, self::$enabledOptions)) {
				return $this->options[$optionName] = $optionValue;
			}
		}
		throw new ConfigurationError("Unrecognized option: $option");
	}
	
	/**
	 * @param string $option key
	 * @return boolean
	 */
	private function hasOption($option) {
		return (isset($this->options[$option]));
	}
	
	/**
	 * @param string $option key
	 * @return mixed
	 */
	private function getOption($option) {
		return $this->options[$option];
	}
	
	/**
	 * Process the command line arguments.
	 */
	private function processArguments() {
		try {
			$length = count($this->arguments);
			for ($i = 1; $i < $length; $i++) {
				$argument = $this->arguments[$i];
				if ($this->isOption($argument)) {
					$this->registerOption($argument);
				} else {
					if (!$this->inputTarget) {
						$this->inputTarget = $argument;
					} elseif (!$this->outputTarget) {
						$this->outputTarget = $argument;
					} else {
						throw new ConfigurationError("Too many targets: $argument");
					}
				}
			}
		} catch(ConfigurationError $error) {
			echo $error->getMessage() . PHP_EOL;
			return;
		}		
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
See http://yarrowdoc.org for more information.

Usage:

 $ yarrow [options]
 $ yarrow [options] <input>
 $ yarrow [options] <input> <output>

 Arguments

 <input>  -  Path to PHP code files or an individual PHP file. If not supplied
             defaults to the current working directory.

 <output> -  Path to the generated documentation. If not supplied, defaults to
             /docs in the current working directory. If it does not exist, it
             is created. If it does exist it remains in place, but existing
             files are overwritten by new files with the same name.

 Options

 Use -o or --option for boolean switches and --option=value or --option:value
 for options that require an explicit value to be set.

  -h    --help      [switch]    Display this help message and exit.
  -v    --version   [switch]    Display version header and exit.
  -c    --config    [string]    Path to a config properties file.


HELP;
	}
}