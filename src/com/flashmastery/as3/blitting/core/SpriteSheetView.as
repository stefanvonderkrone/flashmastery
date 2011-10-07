package com.flashmastery.as3.blitting.core {
	import com.flashmastery.as3.blitting.events.SpriteSheetEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	[Event(name="sEnterframe", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]

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
		private var _mousePosition : Point;

		public function SpriteSheetView() {
			_renderPoint = new Point();
			_containerPosition = new Point();
			_renderRect = new Rectangle();
			_mousePosition = new Point();
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
			removeEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
			removeEventListener( MouseEvent.CLICK, mouseClickHandler );
		}

		protected function rollOverHandler( evt : MouseEvent ) : void {
			Mouse.cursor = MouseCursor.ARROW;
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
			addEventListener( MouseEvent.CLICK, mouseClickHandler );
		}

		protected function mouseMoveHandler( evt : MouseEvent = null ) : void {
//			trace("SpriteSheetView.mouseMoveHandler(evt)");
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
//			var startTime : int = getTimer();
			var currentTarget : SpriteSheet = getCurrentSpriteSheetUnderPoint( _spriteSheetStage, _mousePosition );
//			var endTime : int = getTimer();
//			trace("SpriteSheetView.mouseMoveHandler(evt)", endTime - startTime);
			if ( _currentMouseTarget != currentTarget ) {
				// MouseOver / MouseOut
				if ( _currentMouseTarget )
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_OUT, _currentMouseTarget, _mousePosition, 0 );
				Mouse.cursor = MouseCursor.ARROW;
				_currentMouseTarget = currentTarget;
				if ( _currentMouseTarget ) {
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_OVER, _currentMouseTarget, _mousePosition, 0 );
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_MOVE, _currentMouseTarget, _mousePosition, 0 );
					if ( _currentMouseTarget.useHandCursor && _currentMouseTarget.mouseEnabled )
						Mouse.cursor = MouseCursor.BUTTON;
				}
			} else {
				// MouseMove
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_MOVE, _currentMouseTarget || _spriteSheetStage, _mousePosition, 0 );
			}
		}

		protected function mouseClickHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseClick
				dispatchBubblingEvent( SpriteSheetEvent.CLICK, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function mouseWheelHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseWheel
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_WHEEL, _currentMouseTarget, _mousePosition, evt.delta );
			}
		}

		protected function mouseUpHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseUp
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_UP, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function mouseDownHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseDown
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_DOWN, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function dispatchBubblingEvent( type : String, target : SpriteSheet, stageCoords : Point, delta : int ) : void {
			var targetParent : SpriteSheetContainer = target.parent;
			var newTarget : SpriteSheet;
			if ( target.mouseEnabled && target.hasEventListener( type ) )
				target.dispatchEvent( new SpriteSheetEvent( type, target, target, target.globalToLocal( stageCoords ), stageCoords, delta ) );
			for ( ; targetParent != null; ) {
				newTarget = targetParent;
				targetParent = newTarget is SpriteSheetStage ? null : newTarget.parent;
				if ( newTarget.mouseEnabled && newTarget.hasEventListener( type ) )
					newTarget.dispatchEvent( new SpriteSheetEvent( type, target, newTarget, newTarget.globalToLocal( stageCoords ), stageCoords, delta ) );
			}
		}

		protected function getCurrentSpriteSheetUnderPoint( container : SpriteSheet, point : Point ) : SpriteSheet {
			var sprite : SpriteSheet;
			var children : Vector.<SpriteSheet>;
			var childrenLength : int;
			if ( container.mouseEnabled && container.getRectByCoords( _spriteSheetStage ).containsPoint( point ) ) {
				if ( container is SpriteSheetContainer && SpriteSheetContainer( container ).numChildren > 0 && SpriteSheetContainer( container ).mouseChildren ) {
					children = SpriteSheetContainer( container ).children;
					childrenLength = children.length;
					while( --childrenLength > -1 ) {
						sprite = children[ int( childrenLength ) ];
						sprite = getCurrentSpriteSheetUnderPoint( sprite, point );
						if ( sprite && sprite.hitsPointOfBitmap( sprite.globalToLocal( point ) ) )
							return sprite;
						else if ( sprite is SpriteSheetContainer && !SpriteSheetContainer( sprite ).mouseChildren && SpriteSheetContainer( container ).hitsPoint( container.globalToLocal( point ) ) )
							return sprite;
					}
				} else if ( container is SpriteSheetContainer && SpriteSheetContainer( container ).hitsPoint( container.globalToLocal( point ) ) )
					return container;
				else if ( container.hitsPointOfBitmap( container.globalToLocal( point ) ) )
					return container;
			}
			return null;
		}
		
		public function render() : void {
			if ( hasEventListener( SpriteSheetEvent.ENTER_FRAME ) )
				dispatchEvent( new SpriteSheetEvent(SpriteSheetEvent.ENTER_FRAME ) );
			_canvas.lock();
			_canvas.fillRect( _canvas.rect, _backgroundColor );
			_containerPosition.x = _containerPosition.y = 0;
			if ( _spriteSheetStage )
				renderSpriteSheet( _canvas, _spriteSheetStage, _containerPosition );
			_canvas.unlock();
			if ( hasEventListener( MouseEvent.MOUSE_MOVE ) ) mouseMoveHandler();
		}

		protected function renderSpriteSheet( canvas : BitmapData, spriteSheet : SpriteSheet, containerPosition : Point ) : void {
			_renderPoint.x = containerPosition.x + spriteSheet.x + spriteSheet.registrationOffsetX;
			_renderPoint.y = containerPosition.y + spriteSheet.y + spriteSheet.registrationOffsetY;
			if ( !spriteSheet.visible ) return;
			spriteSheet.updateForRender();
			if ( spriteSheet.bitmapData ) {
				_renderRect.width = spriteSheet.bitmapData.width;
				_renderRect.height = spriteSheet.bitmapData.height;
				canvas.copyPixels( spriteSheet.bitmapData, _renderRect, _renderPoint, null, null, _canvas.transparent );
			}
			if ( spriteSheet is SpriteSheetContainer ) {
				var children : Vector.<SpriteSheet> = SpriteSheetContainer( spriteSheet ).children;
				var numSprites : int = children.length;
				var spritePosition : Point = new Point();
				spritePosition.x = containerPosition.x + spriteSheet.x + spriteSheet.registrationOffsetX;
				spritePosition.y = containerPosition.y + spriteSheet.y + spriteSheet.registrationOffsetY;
				for ( var i : int = 0; i < numSprites; i++ ) {
					renderSpriteSheet( canvas, children[ int( i ) ], spritePosition );
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

		public function get canvas() : BitmapData {
			return _canvas;
		}
	}
}
