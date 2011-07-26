package com.flashmastery.as3 {
	import com.flashmastery.as3.blitting.core.SpriteSheet;
	import com.flashmastery.as3.blitting.core.SpriteSheetContainer;
	import com.flashmastery.as3.blitting.core.SpriteSheetStage;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class BlittingDisplayListText extends Sprite {

		public function BlittingDisplayListText() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			var _stage : SpriteSheetStage = new SpriteSheetStage();
			var container : SpriteSheetContainer = new SpriteSheetContainer();
			_stage.addChild( container );
			var rect:SpriteSheet = new SpriteSheet();
			var bitmapData : BitmapData = new BitmapData( 10, 10 );
			for ( var i : int = 0; i < 10; i++ ) {
				rect = new SpriteSheet();
				rect.bitmapData = bitmapData;
				rect.x = i * 10;
				rect.y = i * 10;
				container.addChild( rect );
//				trace( rect.getRect() );
			}
			container.y = 10;
			
			trace(container.getRectByCoords(container)); // (x=0, y=0, w=100, h=100)
			trace(container.getRectByCoords(_stage)); // (x=0, y=10, w=100, h=100)
			trace(_stage.getRectByCoords(rect)); // (x=0, y=10, w=100, h=100)
		}
	}
}
