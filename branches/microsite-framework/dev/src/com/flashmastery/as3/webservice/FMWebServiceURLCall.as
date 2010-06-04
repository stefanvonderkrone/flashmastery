package com.flashmastery.as3.webservice {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMWebServiceURLCall extends AbstractWebServiceCall {
		
		protected var _urlLoader : URLLoader;
		protected var _urlVars : URLVariables;
		protected var _url : String;
		protected var _requestMethod : String;

		public function FMWebServiceURLCall(type : String, url : String = "", requestMethod : String = URLRequestMethod.POST, urlVars : URLVariables = null ) {
			super( type );
			_url = url;
			_requestMethod = requestMethod;
			_urlVars = urlVars;
		}

		override public function sendCall() : void {
			if ( _urlLoader || _url == "" ) {
				errorHandler();
				return;
			}
			var request : URLRequest = new URLRequest( url );
			request.method = _requestMethod;
			if ( _urlVars ) request.data = _urlVars;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			_urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, errorHandler );
			_urlLoader.addEventListener( Event.COMPLETE, completeHandler );
			_urlLoader.load( request );
		}

		protected function completeHandler(evt : Event) : void {
			_result = _urlLoader.data;
			try {
				_resultXML = new XML( _urlLoader.data );
				_resultObject = parseResult( _result );
			} catch ( e : Error ) {}
			_urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			_urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, errorHandler );
			_urlLoader.removeEventListener( Event.COMPLETE, completeHandler );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}

		protected function errorHandler(evt : ErrorEvent = null) : void {
			var ioee : IOErrorEvent = evt as IOErrorEvent;
			var see : SecurityErrorEvent = evt as SecurityErrorEvent;
			var text : String = "";
			if ( ioee ) text = ioee.text;
			else if ( see ) text = see.text;
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, text ) );
		}

		public function get requestMethod() : String {
			return _requestMethod;
		}
		
		public function set requestMethod(method : String) : void {
			_requestMethod = method;
		}
		
		public function get url() : String {
			return _url;
		}
		
		public function set url(url : String) : void {
			_url = url;
		}
		
		public function get urlVars() : URLVariables {
			if ( _urlVars == null ) _urlVars = new URLVariables();
			return _urlVars;
		}
		
		public function set urlVars(urlVars : URLVariables) : void {
			_urlVars = urlVars;
		}
		
		protected function parseResult(result : String) : Object {
			var o : Object = {};
			var results : Array = result.split( "&" );
			var resultString : Array;
			for ( var i : uint = 0; i < results.length; i++ ) {
				resultString = results[ i ].split( "=" );
				o[ resultString[ 0 ] ] = decodeURI( resultString[ 1 ] );
			}
			return o;
		}
	}
}
