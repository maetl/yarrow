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
	public function getTemplatePath() {
		return $this->templatePath;
	}
	
	/**
	 * Renders a template, applying context variables.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $context list of variables provided to template
	 */
	abstract public function render($template, $context);
	
}