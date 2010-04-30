package com.flashmastery.as3.webservice.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;

	import flash.events.IEventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IWebService extends IEventDispatcher, IDisposable {
		
		function get gateWayURL() : String;
		
		function sendCall( call : IWebServiceCall ) : void;
		
	}
}
