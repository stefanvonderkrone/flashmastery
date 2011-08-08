package com.flashmastery.as3 {
	import com.flashmastery.as3.blitting.events.SpriteSheetEvent;
	import net.hires.debug.Stats;

	import com.flashmastery.as3.blitting.core.SpriteSheet;
	import com.flashmastery.as3.blitting.core.SpriteSheetContainer;
	import com.flashmastery.as3.blitting.core.SpriteSheetStage;
	import com.flashmastery.as3.blitting.core.SpriteSheetView;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class BlittingDisplayListText extends Sprite {

		private var _stage : SpriteSheetStage;
		private var _view : SpriteSheetView;

		public function BlittingDisplayListText() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			_view = SpriteSheetView( addChild( new SpriteSheetView() ) );
			_view.initWithDimensions( stage.stageWidth, stage.stageHeight );
			_view.smoothing = true;
			_stage = new SpriteSheetStage();
			_view.spriteSheetStage = _stage;
			var container : SpriteSheetContainer = new SpriteSheetContainer();
			_stage.addChild( container );
			var rect:SpriteSheet = new SpriteSheet();
			var bitmapData : BitmapData = new BitmapData( 50, 50, true, 0x00000000 );
			bitmapData.fillRect( new Rectangle( 10, 10, 30, 30 ), 0xFFFF0000 );
			container.x = 150;
			container.y = 150;
			container.registrationOffsetX = -50;
			container.registrationOffsetY = -50;
			container.useHandCursor = true;
			for ( var i : int = 0; i < 11; i++ ) {
				rect = new SpriteSheet();
				rect.bitmapData = bitmapData;
				rect.x = i * 25;
				rect.y = i * 25;
				container.addChild( rect );
				trace( rect.globalToLocal( new Point( 98, 98 ) ) );
				trace( rect.localToGlobal( new Point( 0, 0 ) ) );
			}
			_stage.addEventListener( SpriteSheetEvent.MOUSE_OVER, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.MOUSE_OUT, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.MOUSE_DOWN, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.MOUSE_MOVE, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.MOUSE_UP, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.MOUSE_WHEEL, mouseHandler );
			_stage.addEventListener( SpriteSheetEvent.CLICK, mouseHandler );
			
//			trace(container.getRect()); // (x=0, y=0, w=100, h=100)
//			trace(container.getRectByCoords(container)); // (x=0, y=0, w=100, h=100)
//			trace(container.getRectByCoords(_stage)); // (x=95, y=95, w=100, h=100)
//			trace(container.getRect()); // (x=95, y=95, w=100, h=100)
//			trace(rect.getRectByCoords( _stage )); // (x=95, y=95, w=100, h=100)
			trace(rect.getRectByCoords( rect )); // (x=-25, y=-25, w=50, h=50)
//			trace(_stage.getRectByCoords(rect)); // (x=0, y=10, w=100, h=100)
//			trace( _stage.width ); // 100
//			trace( container.width ); // 100
//			trace( rect.width ); // 10
			
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
			addChild( new Stats() );
			_view.render();
		}

		private function clickHandler( evt : MouseEvent ) : void {
			trace( evt.target, evt.currentTarget );
		}

		private function mouseHandler( evt : SpriteSheetEvent ) : void {
			trace("BlittingDisplayListText.mouseHandler(evt)", evt.type, evt.target.name, evt.currentTarget.name);
		}

		private function enterframeHandler( evt : Event ) : void {
			_view.render();
		}
	}
}
