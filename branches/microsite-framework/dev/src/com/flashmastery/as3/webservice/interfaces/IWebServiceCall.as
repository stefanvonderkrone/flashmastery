package com.flashmastery.as3.webservice.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;

	import flash.events.IEventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IWebServiceCall extends IEventDispatcher, IDisposable {
		
		function get type() : String;
		
		function sendCall() : void;
		
	}
}
