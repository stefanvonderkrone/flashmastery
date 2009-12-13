package com.flashmastery.as3.paper3d.patterns.model.vo {

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPaper3DSettingsVO extends Object {

		private var _cameraDistance : Number = 300;

		public function FMPaper3DSettingsVO() {
		}
		
		public function get cameraDistance() : Number {
			return _cameraDistance;
		}
	}
}
