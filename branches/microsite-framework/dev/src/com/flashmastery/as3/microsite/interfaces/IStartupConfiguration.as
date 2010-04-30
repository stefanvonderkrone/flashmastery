package com.flashmastery.as3.microsite.interfaces {
	import flash.display.Sprite;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IStartupConfiguration {
		
		function get flashVars() : Object;
		
		function get xml() : XML;
		
		function get view() : Sprite;
		
		function get additionalData() : *;
		
	}
}
