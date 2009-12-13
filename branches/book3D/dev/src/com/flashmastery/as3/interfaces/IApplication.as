package com.flashmastery.as3.interfaces {
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public interface IApplication extends IEventDispatcher, IBitmapDrawable {
	
		function start() : void;
	
	}
}
