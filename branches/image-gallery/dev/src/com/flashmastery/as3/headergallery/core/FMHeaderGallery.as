package com.flashmastery.as3.headergallery.core {
	import com.flashmastery.as3.display.RootSprite;
	import com.flashmastery.as3.headergallery.vo.FMHeaderGalleryResourceVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMHeaderGallery extends RootSprite {

		private static var DEFAULT_XML_URL : String = "xml/HeaderGalleryConfig.xml";

		private var _application : FMHeaderGalleryApplication;
		
		private var _xmlLoader : URLLoader;

		public function FMHeaderGallery() {
			super( );
		}

		override protected function init(evt : Event = null) : void {
			super.init( evt );
			_xmlLoader = new URLLoader( );
			_xmlLoader.addEventListener( Event.COMPLETE, xmlCompleteHandler );			_xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, xmlErrorHandler );			_xmlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, xmlErrorHandler );			_xmlLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, xmlStatusHandler );
			if ( stage.loaderInfo.parameters.xmlURL ) _xmlLoader.load( new URLRequest( stage.loaderInfo.parameters.xmlURL ) );
			else _xmlLoader.load( new URLRequest( DEFAULT_XML_URL ) );
		}

		private function xmlStatusHandler(evt : HTTPStatusEvent) : void {
			trace( evt );
		}

		private function xmlErrorHandler(evt : Event) : void {
			trace( evt );
		}

		private function xmlCompleteHandler(evt : Event) : void {
			FMHeaderGalleryResourceVO.getInstance().parseXML( new XML( _xmlLoader.data ) );
		}
	}
}
