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
 * Converter for classic PHP style templating.
 */
class PhpConverter extends TemplateConverter {

	private $wrappingTemplate = false;
	
	/**
	 * Wraps a layout template around an inner template.
	 *
	 * The inner template is captured in the $content variable available
	 * in the wrapping template.
	 *
	 * @param string $template name of template file
	 */
	public function wrap($template) {
		$this->wrappingTemplate = $template;
	}
	
	/**
	 * Renders a template, applying context variables.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $context list of variables provided to template
	 */
	public function render($template, $context) {
		ob_start();
		extract($context);
		
		$templateFile = $this->getTemplatePath() . '/' . $template;
		if (file_exists($templateFile)) {
			include $templateFile;
		} else {
			throw new Exception("Template $template not found in {$this->getTemplatePath()}.");
		}
		
		if ($this->wrappingTemplate) {
			$templateFile = $this->getTemplatePath() . '/' . $this->wrappingTemplate . '.tpl.php';
			if (file_exists($templateFile)) {
				$content = ob_get_contents();
				ob_clean();
				include $templateFile;
			} else {
				throw new Exception("Template {$this->wrappingTemplate} not found in {$this->getTemplatePath()}.");
			}			
		}
		
		$out = ob_get_contents();
		ob_clean();
		return $out;
	}
}