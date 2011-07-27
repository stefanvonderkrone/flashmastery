package com.flashmastery.as3 {
	import flash.events.MouseEvent;
	import net.hires.debug.Stats;
	import com.flashmastery.as3.blitting.core.SpriteSheetView;
	import flash.geom.Rectangle;
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
//			trace( _stage.name );
			_view.spriteSheetStage = _stage;
			var container : SpriteSheetContainer = new SpriteSheetContainer();
			_stage.addChild( container );
//			trace( container.name );
			var rect:SpriteSheet = new SpriteSheet();
			var bitmapData : BitmapData = new BitmapData( 10, 10, true );
			bitmapData.fillRect( new Rectangle( 0, 0, 10, 10 ), 0xFFFF0000 );
			for ( var i : int = 0; i < 11; i++ ) {
				rect = new SpriteSheet();
				rect.bitmapData = bitmapData;
				rect.x = i * 20;
				rect.y = i * 20;
				rect.registrationPointX = 5;
				rect.registrationPointY = 5;
				rect.useHandCursor = true;
				container.addChild( rect );
//				trace( rect.name );
			}
			container.x = 100;
			container.y = 100;
			_stage.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			_stage.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			
//			trace(container.getRect()); // (x=0, y=0, w=100, h=100)
//			trace(container.getRectByCoords(container)); // (x=0, y=0, w=100, h=100)
//			trace(container.getRectByCoords(_stage)); // (x=95, y=95, w=100, h=100)
//			trace(container.getRect()); // (x=95, y=95, w=100, h=100)
//			trace(rect.getRectByCoords( _stage )); // (x=95, y=95, w=100, h=100)
//			trace(_stage.getRectByCoords(rect)); // (x=0, y=10, w=100, h=100)
//			trace( _stage.width ); // 100
//			trace( container.width ); // 100
//			trace( rect.width ); // 10
			
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
			addChild( new Stats() );
			_view.render();
		}

		private function mouseOutHandler( evt : MouseEvent ) : void {
//			trace("BlittingDisplayListText.mouseOutHandler(evt)", evt.currentTarget.name);
		}

		private function mouseOverHandler( evt : MouseEvent ) : void {
//			trace("BlittingDisplayListText.mouseOutHandler(evt)", evt.currentTarget.name);
		}

		private function enterframeHandler( evt : Event ) : void {
			_view.render();
		}
	}
}
