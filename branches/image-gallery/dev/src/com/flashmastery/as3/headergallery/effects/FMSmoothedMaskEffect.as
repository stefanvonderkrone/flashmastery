package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.headergallery.effects.FMAbstractHeaderGalleryEffect;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMSmoothedMaskEffect extends FMAbstractHeaderGalleryEffect {

		public static const TYPE : String = "SmoothedMask";
		
		public var direction : String = "B";

		public function FMSmoothedMaskEffect(id : String, speed : Number) {
			super( id, speed, TYPE );
		}
	}
}
