package com.flashmastery.as3 {
	import net.hires.debug.Stats;

	import com.flashmastery.as3.blitting.core.SpriteSheet;
	import com.flashmastery.as3.blitting.core.SpriteSheetStage;
	import com.flashmastery.as3.blitting.core.SpriteSheetView;
	import com.flashmastery.as3.blitting.events.SpriteSheetEvent;
	import com.flashmastery.as3.blitting.isometrics.IsoSpriteSheet;
	import com.flashmastery.as3.blitting.isometrics.IsoSpriteSheetContainer;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class IsoSpriteSheetTest extends Sprite {

		private var _view : SpriteSheetView;
		private var _stage : SpriteSheetStage;
		private var _container : IsoSpriteSheetContainer;

		public function IsoSpriteSheetTest() {
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
			_container = new IsoSpriteSheetContainer();
			_stage.addChild( _container );
			var tile:IsoSpriteSheet;
			var bitmapData : SnowTile = new SnowTile();
			var i : int;
			var j : int;
			var container : IsoSpriteSheetContainer = new IsoSpriteSheetContainer();
			_container.cellSizeX = bitmapData.width;
			_container.cellSizeY = bitmapData.height;
			_container.x = 640;
			_container.useHandCursor = true;
			for ( i = 0; i < 11; i++ ) {
				for ( j = 0; j < 11; j++ ) {
					tile = new IsoSpriteSheet();
					tile.bitmapData = bitmapData;
					tile.registrationOffsetX = -bitmapData.width / 2;
					tile.isoX = j;
					tile.isoY = i;
					tile.useHandCursor = true;
					_container.addChild( tile );
					tile.addEventListener( SpriteSheetEvent.CLICK, clickHandler );
				}
			}
			_container.addChild( container );
			for (i = 0; i < 5; i++) {
				for ( j = 0; j < 5; j++ ) {
					tile = new IsoSpriteSheet();
					tile.bitmapData = bitmapData;
					tile.registrationOffsetX = -bitmapData.width / 2;
					tile.isoX = j;
					tile.isoY = i;
					tile.useHandCursor = true;
					container.addChild( tile );
					tile.addEventListener( SpriteSheetEvent.CLICK, clickHandler );
				}
			}
			container.isoX = 6;
			container.isoY = -5;
			addChild( new Stats() );
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
			animateTiles();
			_view.render();
		}

		private function animateTiles() : void {
			var children : Vector.<SpriteSheet> = _container.children;
			var length : int = children.length;
			for ( var i : int = 0; i < length; i++ )
				TweenLite.to( children[ int( i ) ], 1, { isoZ: Math.random() * 2 - 1 } );
			TweenLite.delayedCall( 1.1, animateTiles );
		}

		private function clickHandler( evt : SpriteSheetEvent ) : void {
			var tile : IsoSpriteSheet = IsoSpriteSheet( evt.target );
			trace("IsoSpriteSheetTest.clickHandler(evt)", tile.isoX, tile.isoY);
		}

		private function enterframeHandler( evt : Event ) : void {
			_view.render();
		}
	}
}
