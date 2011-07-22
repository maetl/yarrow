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

require_once 'Twig/Autoloader.php';
Twig_Autoloader::register();

/**
 * Converter for Twig template engine (see http://www.twig-project.org/)
 */
class TwigConverter extends TemplateConverter {
	
	/**
	 * Renders a template, applying context variables.
	 * 
	 * @throws Exception
	 * @param string $template name of template file
	 * @param array $context list of variables provided to template
	 */
	public function render($template, $context) {		
		$loader = new Twig_Loader_Filesystem($this->getTemplatePath());
		$twig = new Twig_Environment($loader);
		$twig->addExtension(new Twig_Extensions_Extension_Text());
		$template = $twig->loadTemplate($template);
		
		return $template->render($context);
	}	
}

/**
 * This file is part of Twig.
 *
 * (c) 2009 Fabien Potencier
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Henrik Bjornskov <hb@peytz.dk>
 * @package Twig
 * @subpackage Twig-extensions
 */
class Twig_Extensions_Extension_Text extends Twig_Extension
{
    /**
     * Returns a list of filters.
     *
     * @return array
     */
    public function getFilters() {
        return array(
            'nl2br' => new Twig_Filter_Function('lineBreakFilter', array('pre_escape' => 'html', 'is_safe' => array('html'))),
        );
    }

    /**
     * Name of this extension
     *
     * @return string Text
     */
    public function getName()
    {
        return 'Text';
    }
}

function lineBreakFilter($value, $sep = '<br />') {
    return str_replace("\n", $sep."\n", $value);
}