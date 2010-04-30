package com.flashmastery.as3.webservice {
	import com.flashmastery.as3.webservice.interfaces.IWebServiceCall;

	import flash.events.EventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class AbstractWebServiceCall extends EventDispatcher implements IWebServiceCall {
		
		protected var _type : String;

		public function AbstractWebServiceCall( type : String ) {
			super( null );
			_type = type;
		}

		public function sendCall() : void {
		}
		
		public function get type() : String {
			return _type;
		}
		
		public function dispose() : void {
		}
	}
}
