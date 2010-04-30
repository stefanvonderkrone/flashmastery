package com.flashmastery.as3.microsite.core.preloading {

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPreloaderResourcesList extends Array {

		private static var _instance : FMPreloaderResourcesList;
		public static function getInstance() : FMPreloaderResourcesList {
			if ( _instance == null ) _instance = new FMPreloaderResourcesList();
			return _instance;
		}

		public function FMPreloaderResourcesList() {
			super();
		}
		
		public function getResourceByID( id : String ) : FMPreloaderResource {
			var resource : FMPreloaderResource;
			for each ( resource in this ) {
				if ( resource.id == id ) return resource;
			}
			return null;
		}
	}
}
