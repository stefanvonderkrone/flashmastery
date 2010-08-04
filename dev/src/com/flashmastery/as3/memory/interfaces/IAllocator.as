package com.flashmastery.as3.memory.interfaces {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IAllocator {
		
		function alloc( allocableClass : Class ) : *;
		function release( instance : * ) : void;
		function clear( classes : Array = null ) : void;
		
	}
}
