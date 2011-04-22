<?php

/**
 * Handler for classic PHP style templating.
 */
class PHPTemplateEngine {
	
	private $templatePath;
	
	function __construct($path) {
		$this->templatePath = $path;
	}
	
	/**
	 * Renders a template to the response buffer.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $variables list of variables provided to template
	 */
	public function render($template, $variables) {
		ob_start();
		extract($variables);
		$templateFile = $this->templatePath . '/' . $template;
		if (file_exists($templateFile)) {
			include $templateFile;
		} else {
			throw new Exception("Template $template not found in {$this->templatePath}.");
		}
		$out = ob_get_contents();
		ob_clean();
		return $out;
	}	
}