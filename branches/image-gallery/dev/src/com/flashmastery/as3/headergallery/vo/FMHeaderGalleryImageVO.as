package com.flashmastery.as3.headergallery.vo {

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMHeaderGalleryImageVO extends Object {

		private var _src : String;
		private var _alt : String;
		private var _effectID : String;

		public function FMHeaderGalleryImageVO( src : String, alt : String, effectID : String ) {
			_src = src;
			_alt = alt;
			_effectID = effectID;
		}
		
		public function get src() : String {
			return _src;
		}
		
		public function get alt() : String {
			return _alt;
		}
		
		public function get effectID() : String {
			return _effectID;
		}
	}
}
