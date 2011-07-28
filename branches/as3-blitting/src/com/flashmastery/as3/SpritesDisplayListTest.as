package com.flashmastery.as3 {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

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
			graphics.beginFill( 0 );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
			var container : Sprite = Sprite( addChild( new Sprite() ) );
			var rect:Sprite;
			container.x = 150;
			container.y = 150;
			for ( var i : int = 0; i < 11; i++ ) {
				rect = new Sprite();
				rect.graphics.beginFill( 0xFFFFFF );
				rect.graphics.drawRect( -25, -25, 50, 50 );
				rect.graphics.endFill();
				rect.x = -50 + i * 70;
				rect.y = -50 + i * 70;
				container.addChild( rect );
//				trace( rect.name );
//				trace( rect.localToGlobal( new Point( -10, -10 ) ) );
//				trace( rect.globalToLocal( new Point( i * 70 - 10, i * 70 - 10 ) ) );
				trace( rect.globalToLocal( new Point( 98, 98 ) ) );
				trace( rect.localToGlobal( new Point( 0, 0 ) ) );
//				trace( rect.getRect( stage ) );
			}
			
			trace(getRect(this)); // (x=50, y=40, w=40, h=40)
			trace(getRect(stage)); // (x=50, y=50, w=40, h=40)
			trace(rect.getRect(stage)); // (x=50, y=50, w=40, h=40)
			trace(rect.getRect(rect)); // (x=-25, y=-25, w=50, h=50)
//			trace(stage.getRect(rect)); // (x=-90, y=-90, w=100, h=100)
//			trace( stage.width ); // 100
//			trace( width ); // 100
//			trace( rect.width ); // 10
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		}

		private function mouseMoveHandler( evt : MouseEvent ) : void {
			var rect : Sprite;
			var mousePosition : Point = new Point( mouseX, mouseY );
			for ( var i : int = 0; i < DisplayObjectContainer( getChildAt( 0 ) ).numChildren; i++ ) {
				rect = Sprite( DisplayObjectContainer( getChildAt( 0 ) ).getChildAt( i ) );
				trace( rect.name + ".globalToLocal: ", mousePosition, rect.globalToLocal( mousePosition ) );
			}
		}
	}
}
