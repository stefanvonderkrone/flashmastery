package com.flashmastery.as3.errors {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMError extends Error {
		
		protected var _additionalInfo : String;

		public function FMError(message : String = "", additionalInfo : String = "") {
			super( message );
			_additionalInfo = additionalInfo;
		}

		public function get additionalInfo() : String {
			return _additionalInfo;
		}
	}
}
