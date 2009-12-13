package com.flashmastery.as3.core.preloading {
	import de.marcelklammer.as3.loading.interfaces.ILoader;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPreloaderResource extends Object {

		protected var _url : String;
		protected var _id : String;
		protected var _type : String;
		protected var _loader : ILoader;

		public function FMPreloaderResource( src : String, id : String, type : String ) {
			_url = src;
			_id = id;
			_type = type;
		}

		public function get url() : String {
			return _url;
		}
		
		public function get id() : String {
			return _id;
		}
		
		public function get type() : String {
			return _type;
		}
		
		public function get loader() : ILoader {
			return _loader;
		}
		
		public function set loader(loader : ILoader) : void {
			_loader = loader;
		}
		
		public function get resource() : * {
			if ( _loader ) return _loader.loadedData;
			return null;
		}

		public function toString() : String {
			return "[ FMPreloaderResource | id=\"" + _id + "\" - url=\"" + _url + "\" - type=\"" + _type + "\" - loader=\"" + _loader + "\" ]";
		}
	}
}
