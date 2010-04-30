package com.flashmastery.as3.microsite.interfaces {
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IMicrosite extends IEventDispatcher, IBitmapDrawable {
		
		function start( startupConfig : IStartupConfiguration ) : void;
		
	}
}
