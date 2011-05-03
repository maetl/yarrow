<?php

abstract class AbstractBase {
	
	public function getName() {
		return __CLASS__;
	}
	
	abstract public function getType();
	
}


class ConcreteType extends AbstractBase {
	
	public function getType() {
		return get_class($this);
	}
	
}