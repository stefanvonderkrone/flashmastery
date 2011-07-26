package com.flashmastery.as3 {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpritesDisplayListTest extends Sprite {

		public function SpritesDisplayListTest() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			var rect:Sprite;
			for ( var i : int = 0; i < 10; i++ ) {
				rect = new Sprite();
				rect.graphics.beginFill( 0 );
				rect.graphics.drawRect( 0, 0, 10, 10 );
				rect.graphics.endFill();
				rect.x = i * 10;
				rect.y = i * 10;
				addChild( rect );
			}
			this.y = 10;
			
			trace(getRect(this)); // (x=50, y=40, w=40, h=40)
			trace(getRect(stage)); // (x=50, y=50, w=40, h=40)
			trace(stage.getRect(rect)); // (x=-90, y=-90, w=100, h=100)
		}
	}
}
