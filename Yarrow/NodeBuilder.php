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

class NodeBuilder {
	
	public static function string($value) {
		$node = new stdClass;
		$node->type = 'string';
		$node->value = $value;
		return $node;
	}
	
	public static function integer($value) {
		$node = new stdClass;
		$node->type = 'integer';
		$node->value = $value;
		return $node;
	}
	
	public static function decimal($value) {
		$node = new stdClass;
		$node->type = 'decimal';
		$node->value = $value;
		return $node;
	}
	
	public static function constant($value) {
		$node = new stdClass;
		$node->type = 'constant';
		$node->value = $value;
		return $node;
	}
	
	public static function arrayList($list) {
		$node = new stdClass;
		$node->type = 'array';
		$node->value = $list;
		return $node;
	}
	
	public static function arrayIndex($key, $value) {
		$node = new stdClass;
		$node->type = 'index';
		$node->key = $key;
		$node->value = $value;
		return $node;
	}
	
}