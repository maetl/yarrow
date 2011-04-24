<?php
/**
 * Yarrow
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
class PHPConverter extends TemplateConverter {
	
	/**
	 * Renders a template, applying passed in variables.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $variables list of variables provided to template
	 */
	public function render($template, $variables) {
		ob_start();
		extract($variables);
		$templateFile = $this->getTemplatePath() . '/' . $template;
		if (file_exists($templateFile)) {
			include $templateFile;
		} else {
			throw new Exception("Template $template not found in {$this->getTemplatePath()}.");
		}
		$out = ob_get_contents();
		ob_clean();
		return $out;
	}
}