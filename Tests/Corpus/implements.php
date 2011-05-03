<?php

interface TypeA {
	public function tahi();
}

interface TypeB {
	public function rua();
}

interface TypeC {
	public function toru();
}

interface TypeD extends TypeC {
	public function wha();
}

class KlassA implements TypeA {
	public function tahi()  { return true; }
}

class KlassB implements TypeA, TypeB {
	public function tahi()  { return true; }
	public function  rua()  { return true; }
}

class KlassD implements TypeA, TypeB, TypeD {
	public function tahi()  { return true; }
	public function  rua()  { return true; }
	public function toru()  { return true; }
	public function  wha()  { return true; }	
}

