package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.headergallery.effects.FMAbstractHeaderGalleryEffect;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMStripedMaskEffect extends FMAbstractHeaderGalleryEffect {

		public static const TYPE : String = "StripedMask";
		
		public var numStripes : uint = 10;		public var direction : String = "B";

		public function FMStripedMaskEffect(id : String, speed : Number) {
			super( id, speed, TYPE );
		}
	}
}
