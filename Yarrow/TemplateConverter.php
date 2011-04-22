<?php

/**
 * Provides an interface for rendering output from provided documentation theme.
 */
abstract class TemplateConverter {
	
	/**
	 * Path to documentation theme.
	 */
	private $templatePath;
	
	/**
	 * @param $path path to documentation theme
	 */
	function __construct($path) {
		$this->templatePath = $path;
	}
	
	/**
	 * @return string path to documentation theme
	 */
	function getTemplatePath() {
		return $this->templatePath;
	}
	
	/**
	 * Renders a template, applying passed in variables.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $variables list of variables provided to template
	 */
	abstract public function render($template, $variables);
	
}