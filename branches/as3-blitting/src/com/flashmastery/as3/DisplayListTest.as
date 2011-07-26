package com.flashmastery.as3 {
	import flash.display.DisplayObject;
	import net.hires.debug.Stats;

	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class DisplayListTest extends Sprite {
		
		private var _children : Vector.<DisplayObject>;

		public function DisplayListTest() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_children = new Vector.<DisplayObject>();
			graphics.beginFill( 0 );
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			var sprite : Bitmap;
			var bitmapData : BitmapData;
			for ( var i : int = 0; i < 2500; i++ ) {
				sprite = new Bitmap();
				bitmapData = new BitmapData( 100, 100, true );
				bitmapData.perlinNoise(Math.random() * 2500, Math.random() * 2500, 4, Math.random() * 2500, true, true);
//				sprite.graphics.beginFill( Math.random() * 0xFFFFFF );
//				sprite.graphics.beginBitmapFill( bitmapData, null, true, true );
//				sprite.graphics.drawRect(0, 0, 100, 100);
//				sprite.graphics.endFill();
				sprite.bitmapData = bitmapData;
				sprite.smoothing = true;
				sprite.x = Math.random() * stage.stageWidth;
				sprite.y = Math.random() * stage.stageHeight;
				addChild( sprite );
				_children.push( sprite );
			}
			animateSpriteSheets();
			addChild( new Stats() );
		}

		private function animateSpriteSheets() : void {
			for ( var i : int = 0; i < _children.length; i++ )
				TweenLite.to( _children[ int( i ) ], 1, { x: Math.random() * stage.stageWidth, y: Math.random() * stage.stageHeight } );
			TweenLite.delayedCall( 1.1, animateSpriteSheets );
		}
	}
}
