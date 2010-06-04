package com.flashmastery.as3.webservice {
	import com.flashmastery.as3.webservice.interfaces.IWebServiceCall;

	import flash.events.EventDispatcher;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class AbstractWebServiceCall extends EventDispatcher implements IWebServiceCall {
		
		protected var _type : String;
		protected var _result : String;
		protected var _resultXML : XML;
		protected var _resultObject : Object;

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
		
		public function get result() : String {
			return _result;
		}
		
		public function get resultXML() : XML {
			return _resultXML;
		}
		
		public function get resultObject() : Object {
			return _resultObject;
		}
	}
}
