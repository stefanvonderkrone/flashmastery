package com.flashmastery.as3.memory.interfaces {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IAllocatable {
		
		function dealloc() : void;
		function init( ... params ) : IAllocatable;
		
	}
}
