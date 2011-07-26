package com.flashmastery.as3 {
	import net.hires.debug.Stats;

	import com.flashmastery.as3.blitting.core.SpriteSheet;
	import com.flashmastery.as3.blitting.core.SpriteSheetStage;
	import com.flashmastery.as3.blitting.core.SpriteSheetView;
	import com.greensock.TweenLite;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class BlittingTest extends Sprite {
		
		private var _view : SpriteSheetView;
		private var _stage : SpriteSheetStage;

		public function BlittingTest() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_view = SpriteSheetView( addChild( new SpriteSheetView() ) );
			_view.initWithDimensions( stage.stageWidth, stage.stageHeight );
			_view.smoothing = true;
			_stage = new SpriteSheetStage();
			_view.spriteSheetStage = _stage;
			var sprite : SpriteSheet;
//			var rect : Rectangle = new Rectangle(0, 0, 100, 100);
			for ( var i : int = 0; i < 2500; i++ ) {
				sprite = new SpriteSheet();
				sprite.bitmapData = new BitmapData(100, 100, true);
				sprite.bitmapData.perlinNoise(Math.random() * 2500, Math.random() * 2500, 4, Math.random() * 2500, true, true);
//				sprite.bitmapData.fillRect(rect, 0xFF000000 + Math.random() * 0xFFFFFF);
				sprite.x = Math.random() * stage.stageWidth;
				sprite.y = Math.random() * stage.stageHeight;
				_stage.addChild( sprite );
			}
			animateSpriteSheets();
			addChild( new Stats() );
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		private function animateSpriteSheets() : void {
			var children : Vector.<SpriteSheet> = _stage.children;
			for ( var i : int = 0; i < children.length; i++ )
				TweenLite.to( children[ int( i ) ], 1, { x: Math.random() * stage.stageWidth, y: Math.random() * stage.stageHeight } );
			TweenLite.delayedCall( 1.1, animateSpriteSheets );
		}

		private function enterframeHandler( evt : Event ) : void {
			_view.render();
		}
	}
}
