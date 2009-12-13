package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.headergallery.effects.FMAbstractHeaderGalleryEffect;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMAlphaScreenEffect extends FMAbstractHeaderGalleryEffect {

		public static const TYPE : String = "AlphaSreen";

		public function FMAlphaScreenEffect(id : String, speed : Number) {
			super( id, speed, TYPE );
		}
	}
}
