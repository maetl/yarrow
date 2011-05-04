<?php

final class FinalStatic {
	
	public static function hello($a='world')
	{
		return strtoupper($a);
	}
	
	protected static function goodbye($a='world')
	{
		return strtoupper($a);
	}
	
}

abstract class AbstractInstance {
	
	final public function hello()
	{
		$this->goodbye();
	}
	
	abstract protected function goodbye();
}