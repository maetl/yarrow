#!/usr/bin/env php
<?php
/**
 * Yarrow
 *
 * (c) 2010-2011, Mark Rickerby <http://maetl.net>
 *
 */

for ($i = 1; $i < $_SERVER["argc"]; $i++) {

    switch($_SERVER["argv"][$i]) {

        case "-v":
        case "--version":
            echo  "Yarrow 0.0.1\n";
            exit;
        break;

        case "-h":
        case "--help":
            echo file_get_contents('README');
        break;

    }

}
