package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.headergallery.effects.FMAbstractHeaderGalleryEffect;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMColorScreenEffect extends FMAbstractHeaderGalleryEffect {

		public static const TYPE : String = "ColorSreen";
		
		public var color : uint = 0xFFFFFF;

		public function FMColorScreenEffect(id : String, speed : Number) {
			super( id, speed, TYPE );
		}
	}
}
