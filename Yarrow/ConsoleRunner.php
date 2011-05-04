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
	
	/**
	 * Name of the application.
	 */
	const APPNAME = '{{appname}}';
	
	/**
	 * Version of the source code.
	 */
	const VERSION = '{{version}}';
	
	/**
	 * Exit value on success.
	 */
	const SUCCESS = 0;
	
	/**
	 * Exit value on failure.
	 */
	const FAILURE = 1;

	/**
	 * Map of enabled configuration options.
	 */
	private static $enabledOptions = array(
		'h' => 'help',
		'v' => 'version',
		'c' => 'config',
		't' => 'theme'
	);
	
	/**
	 * List of allowed configuration filenames.
	 */
	private $allowedConfigFiles = array(
		'.yarrowdoc',
		'Yarrowdoc'
	);
	
	/**
	 * Marker for timing the duration of the script.
	 */
	private static $startTime;
	
	/**
	 * Main method to run the application.
	 * @param array $arguments list of command line arguments
	 */
	public static function main($arguments) {
		$yarrow = new ConsoleRunner($arguments);
		$exitValue = $yarrow->runApplication();
		exit($exitValue);
	}

	/**
	 * @param array $arguments list of command line arguments
	 */
	public function __construct($arguments) {
		$this->arguments = $arguments;
		$this->options = array();
		$this->config = Configuration::instance();
	}

	/**
	 * Runs the application and applies selected commands.
	 * @return boolean exit value
	 */
	public function runApplication() {
		$this->printHeader();
		
		try {

			$this->processArguments();

			if ($this->hasOption('version')) {
				return self::SUCCESS;
			}

			if ($this->hasOption('help')) {
				self::printHelp();
				return self::SUCCESS;
			}

			$this->processConfiguration();
			
			$this->runInputProcess();
			
			$this->runOutputProcess();
			
			$this->printFooter();
			
			return self::SUCCESS;

		} catch(Yarrow_Exception $error) {
			self::printError($error);
			return self::FAILURE;
		}
	}
	
	protected function runInputProcess() {
		$analyzer = new Analyzer();
		$analyzer->analyzeProject();
		$this->model = $analyzer->getModel();
	}
	
	protected function runOutputProcess() {
		$generator = new DefaultGenerator($this->config->outputTarget, $this->model);
		$generator->makeDocs();
	}
	
	/**
	 * Process the command line arguments.
	 */
	private function processArguments() {
		$length = count($this->arguments);
		$targets = array();
		
		for ($i = 1; $i < $length; $i++) {
			$argument = $this->arguments[$i];
			if ($this->isOption($argument)) {
				$this->registerOption($argument);
			} else {
				$targets[] = $argument;
			}
		}
		
		$this->registerTargets($targets);
	}
	
	/**
	 * Loads configuration from targets.
	 * @todo document precedence rules
	 */
	private function processConfiguration() {
		$workingDirectory = $this->getWorkingDirectory();
		$this->config->merge($this->loadConfiguration($workingDirectory));
		
		foreach($this->config->inputTargets as $inputPath) {
			$this->config->merge($this->loadConfiguration($inputPath));
		}
		
		if ($this->hasOption('config')) {
			$path = $this->getOption('config');
			$this->config->merge(PropertiesFile::load($path));
		}
		
		$this->config->merge(array('options'=>$this->options));
		$this->normalizeThemePath();
		
		$theme = $this->config->options['theme'];
		$this->config->append($this->loadConfiguration($theme));
	}
	
	/**
	 * Load settings from a configuration file when it exists in the given path.
	 *
	 * @param string $path path to search for configuration files
	 * @return array nested array of settings or an empty array if none found
	 */
	private function loadConfiguration($path) {
		foreach($this->allowedConfigFiles as $filename) {
			$configPath = $path . '/' . $filename;
			if (file_exists($configPath)) {
				return PropertiesFile::load($configPath);
			}
		}
		return array();
	}
	
	/**
	 * Converts the theme path to an absolute directory reference if the
	 * existing configuration setting does not point to a directory.
	 */
	private function normalizeThemePath() {
		$theme = $this->config->options['theme'];
		if (!is_dir($theme)) {
			$themePath = dirname(__FILE__) . '/Themes/'. $theme;
			$this->config->merge(array('options' => array('theme' => $themePath)));
		}
	}
	
	/**
	 * Returns true if the given argument is a configuration option.
	 * @return boolean
	 */
	private function isOption($argument) {
		return (substr($argument, 0, 1) == '-');
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
	 * Registers an option passed in to the application.
	 */
	private function registerOption($option) {
		$option = str_replace('=', ':', $option);
		if (strstr($option, ':')) {
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
	 * Returns the directory where the current script is executing.
	 */
	private function getWorkingDirectory() {
		return (isset($_ENV['PWD'])) ? $_ENV['PWD'] : $_SERVER['PWD'];
	}
	
	/**
	 * Update configuration with target paths passed in as command line arguments.
	 */
	private function registerTargets($targets) {
		$workingDirectory = $this->getWorkingDirectory();
		if (empty($targets)) {
			$this->config->outputTarget = $workingDirectory.'/docs';
			$this->config->inputTargets[] = $workingDirectory;
		} else {
			$target = array_pop($targets);
			if (empty($targets)) {
				$this->config->outputTarget = $workingDirectory.'/docs';
				$this->config->inputTargets[] = $target;
			} else {
				foreach($targets as $input) {
					if (!file_exists($input)) throw new ConfigurationError("File not found: $input");
				}
				$this->config->outputTarget = $target;
				$this->config->inputTargets = $targets;				
			}
		}
 	}
	
	/**
	 * Show error message.
	 * @param $exception
	 */
	private static function printError($exception) {
		echo preg_replace("/([a-z])([A-Z])/", "$1 $2", get_class($exception)) . PHP_EOL;
		echo $exception->getMessage(). PHP_EOL;
	}
	
	/**
	 * Show the version header.
	 */
	private function printHeader() {
		self::$startTime = mktime();
		echo self::APPNAME . " " .self::VERSION . "\n\n";
	}
	
	/**
	 * Show the results footer.
	 */
	private function printFooter() {
		$time = (mktime() - self::$startTime);
		$mb = memory_get_peak_usage() / (1024 * 1024);
		echo "Time: $time seconds. Memory: " . round($mb, 1) . "MB.\n\n";
		echo "Documentation generated at {$this->config->outputTarget}/\n";
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
 $ yarrow [options] <input input> <output>

 Arguments

 <input>  -  Path to PHP code files or an individual PHP file. If not supplied
             defaults to the current working directory. Multiple directories
             can be specified by repeating arguments, separated by whitespace.

 <output> -  Path to the generated documentation. If not supplied, defaults to
             ./docs in the current working directory. If it does not exist, it
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