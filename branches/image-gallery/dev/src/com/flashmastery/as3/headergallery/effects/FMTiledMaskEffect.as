package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.headergallery.effects.FMAbstractHeaderGalleryEffect;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMTiledMaskEffect extends FMAbstractHeaderGalleryEffect {

		public static const TYPE : String = "TiledMask";
		
		public var numX : uint = 10;		public var numY : uint = 10;		public var direction : String = "R";

		public function FMTiledMaskEffect(id : String, speed : Number) {
			super( id, speed, TYPE );
		}
	}
}
