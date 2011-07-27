package com.flashmastery.as3.blitting.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetView extends Sprite {
		
		protected var _spriteSheetStage : SpriteSheetStage;
		protected var _canvas : BitmapData;
		protected var _canvasContainer : Bitmap;
		protected var _backgroundColor : Number = 0xFF000000;//xFFFFFF;
		protected var _renderPoint : Point;
		protected var _containerPosition : Point;
		protected var _renderRect : Rectangle;
		protected var _transparent : Boolean = false;
		protected var _smoothing : Boolean = false;
		protected var _width : Number;
		protected var _height : Number;
		protected var _currentMouseTarget : SpriteSheet;

		public function SpriteSheetView() {
			_renderPoint = new Point();
			_containerPosition = new Point();
			_renderRect = new Rectangle();
		}

		public function initWithDimensions( width : Number, height : Number, transparent : Boolean = false ) : void {
			_canvas = new BitmapData( width, height, transparent );
			_canvasContainer = Bitmap( addChild( new Bitmap() ) );
			_canvasContainer.bitmapData = _canvas;
			_canvasContainer.smoothing = _smoothing;
			_width = width;
			_height = height;
			_transparent = transparent;
			_renderRect.width = _width;
			_renderRect.height = _height;
			addEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
			addEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
		}

		protected function rollOutHandler( evt : MouseEvent ) : void {
			Mouse.cursor = MouseCursor.AUTO;
			removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		}

		protected function rollOverHandler( evt : MouseEvent ) : void {
			Mouse.cursor = MouseCursor.ARROW;
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		}

		protected function mouseMoveHandler( evt : MouseEvent ) : void {
			var mousePosition : Point = new Point( int( mouseX ), int( mouseY ) );
			var currentTarget : SpriteSheet = getCurrentSpriteSheet( _spriteSheetStage, mousePosition );
			if ( _currentMouseTarget != currentTarget ) {
				if ( _currentMouseTarget ) dispatchBubblingEvent( _currentMouseTarget, new MouseEvent( MouseEvent.MOUSE_OUT ) );
				Mouse.cursor = MouseCursor.ARROW;
				_currentMouseTarget = currentTarget;
				if ( _currentMouseTarget ) {
					dispatchBubblingEvent( _currentMouseTarget, new MouseEvent( MouseEvent.MOUSE_OVER ) );
					if ( _currentMouseTarget.useHandCursor ) Mouse.cursor = MouseCursor.BUTTON;
				}
//				if ( currentTarget ) trace("SpriteSheetView.mouseMoveHandler(evt)", currentTarget.name );
			}
		}

		protected function dispatchBubblingEvent( target : SpriteSheet, mouseEvent : MouseEvent ) : void {
			target.dispatchEvent( mouseEvent );
			var targetParent : SpriteSheetContainer = target.parent;
			for ( ; targetParent != null; ) {
				targetParent.dispatchEvent( mouseEvent );
				targetParent = target is SpriteSheetStage ? null : targetParent.parent;
			}
		}

		protected function getCurrentSpriteSheet( container : SpriteSheet, position : Point ) : SpriteSheet {
			var sprite : SpriteSheet;
			var children : Vector.<SpriteSheet>;
			var childrenLength : int;
//			var rect : Rectangle = container.getRectByCoords( _spriteSheetStage );
//			trace(position, rect, rect.bottom, rect.right, rect.containsPoint( position ));
			if ( container.getRectByCoords( _spriteSheetStage ).containsPoint( position ) ) {
				if ( container is SpriteSheetContainer && SpriteSheetContainer( container ).numChildren > 0 && SpriteSheetContainer( container ).mouseChildren ) {
					children = SpriteSheetContainer( container ).children;
					childrenLength = children.length;
					for ( var i : int = childrenLength - 1; i >= 0; i-- ) {
						sprite = children[ int( i ) ];
						sprite = getCurrentSpriteSheet( sprite, position );
//						if ( sprite ) trace("\t", position, sprite.getRectByCoords( _spriteSheetStage ));
						if ( sprite ) return sprite;
					}
				}
				return container;
			}
			return null;
		}
		
		public function render() : void {
			_canvas.lock();
			_canvas.fillRect( _canvas.rect, _backgroundColor );
			_containerPosition.x = _containerPosition.y = 0;
			if ( _spriteSheetStage )
				renderSpriteSheet( _canvas, _spriteSheetStage, _containerPosition );
			_canvas.unlock();
		}

		protected function renderSpriteSheet( canvas : BitmapData, spriteSheet : SpriteSheet, containerPosition : Point ) : void {
			_renderPoint.x = containerPosition.x + spriteSheet.x - spriteSheet.registrationPointX;
			_renderPoint.y = containerPosition.y + spriteSheet.y - spriteSheet.registrationPointY;
			_renderRect.width = spriteSheet.width;
			_renderRect.height = spriteSheet.height;
			if ( !spriteSheet.visible ) return;
			if ( spriteSheet.bitmapData )
				canvas.copyPixels( spriteSheet.bitmapData, _renderRect, _renderPoint );
			if ( spriteSheet is SpriteSheetContainer ) {
				var children : Vector.<SpriteSheet> = SpriteSheetContainer( spriteSheet ).children;
				var numSprites : int = children.length;
				for ( var i : int = 0; i < numSprites; i++ ) {
					containerPosition.x = spriteSheet.x + spriteSheet.registrationPointX;
					containerPosition.y = spriteSheet.y + spriteSheet.registrationPointY;
					renderSpriteSheet( canvas, children[ int( i ) ], containerPosition );
				}
			}
		}

		public function get spriteSheetStage() : SpriteSheetStage {
			return _spriteSheetStage;
		}

		public function set spriteSheetStage( spriteSheetStage : SpriteSheetStage ) : void {
			_spriteSheetStage = spriteSheetStage;
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set width( width : Number ) : void {
			_width = width;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
		}

		override public function get height() : Number {
			return _height;
		}

		override public function set height( height : Number ) : void {
			_height = height;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
		}

		public function get transparent() : Boolean {
			return _transparent;
		}

		public function set transparent( transparent : Boolean ) : void {
			_transparent = transparent;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
		}

		public function get backgroundColor() : Number {
			return _backgroundColor;
		}

		public function set backgroundColor( backgroundColor : Number ) : void {
			_backgroundColor = backgroundColor;
		}

		public function get smoothing() : Boolean {
			return _smoothing;
		}

		public function set smoothing( smoothing : Boolean ) : void {
			_smoothing = smoothing;
			_canvasContainer.smoothing = _smoothing;
		}
		
		override public function set mouseChildren( enable : Boolean ) : void {
			super.mouseChildren = enable;
		}
		
		override public function set mouseEnabled( enabled : Boolean ) : void {
			super.mouseEnabled = enabled;
		}
	}
}
