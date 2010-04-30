package com.flashmastery.as3.webservice {
	import com.flashmastery.as3.webservice.interfaces.IWebService;
	import com.flashmastery.as3.webservice.interfaces.IWebServiceCall;

	import flash.events.EventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class AbstractWebService extends EventDispatcher implements IWebService {
		
		protected var _gateWayURL : String;

		public function AbstractWebService( gateWayURL : String ) {
			super( null );
			_gateWayURL = gateWayURL;
		}

		public function dispose() : void {
		}
		
		public function sendCall(call : IWebServiceCall) : void {
		}
		
		public function get gateWayURL() : String {
			return _gateWayURL;
		}
	}
}
