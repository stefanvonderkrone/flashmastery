package com.flashmastery.as3.microsite.patterns.model.vo {
	import com.flashmastery.as3.microsite.interfaces.IStartupConfiguration;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMMicrositeConfigVO extends Object {
		
		protected var _mediatorDataProvider : Dictionary;
		protected var _startPageConstants : Dictionary;
		protected var _flashVars : Dictionary;
		protected var _defaultStartPage : String = "";
		protected var _xml : XML;
		protected var _additionalData : *;
		protected var _view : Sprite;

		public function FMMicrositeConfigVO( startupConfig : IStartupConfiguration ) {
			_mediatorDataProvider = new Dictionary( );
			_startPageConstants = new Dictionary( );
			_flashVars = getDictionary( startupConfig.flashVars );
			_xml = startupConfig.xml;
			_additionalData = startupConfig.additionalData;
			_view = startupConfig.view;
		}

		protected function getDictionary(object : Object) : Dictionary {
			var map : Dictionary = new Dictionary();
			for ( var param : String in object ) {
				map[ param ] = object[ param ];
			}
			return map;
		}
		
		public function get xml() : XML {
			return _xml;
		}
		
		public function get defaultStartPage() : String {
			return _defaultStartPage;
		}
		
		public function set defaultStartPage(defaultStartPage : String) : void {
			_defaultStartPage = defaultStartPage;
		}
		
		public function get startPageConstants() : Dictionary {
			return _startPageConstants;
		}
		
		public function get mediatorDataProvider() : Dictionary {
			return _mediatorDataProvider;
		}
		
		public function get flashVars() : Dictionary {
			return _flashVars;
		}
		
		public function get additionalData() : * {
			return _additionalData;
		}
	}
}
