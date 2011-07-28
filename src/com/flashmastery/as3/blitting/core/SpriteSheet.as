package com.flashmastery.as3.blitting.core {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="added", type="flash.events.Event")]
	[Event(name="addedToStage", type="flash.events.Event")]

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheet extends EventDispatcher {
		
		protected static var spriteIndex : int = 0;
		protected static const shapeColorMultiplier : uint = 16;
		protected static const _hitTestZeroPoint : Point = new Point();
		
		protected var _bitmapData : BitmapData;
		protected var _name : String;
		protected var _parent : SpriteSheetContainer;
		protected var _root : SpriteSheet;
		protected var _stage : SpriteSheetStage;
		protected var _visible : Boolean = true;
		protected var _x : int = 0;
		protected var _y : int = 0;
		protected var _registrationOffsetX : int = 0;
		protected var _registrationOffsetY : int = 0;
		protected var _mouseEnabled : Boolean = true;
		protected var _useHandCursor : Boolean = false;
		protected var _shapeColor : uint;
		protected var _rect : Rectangle;

		public function SpriteSheet() {
			super();
			contruct();
		}

		protected function contruct() : void {
			_name = "spriteSheet" + spriteIndex.toString();
			_shapeColor = shapeColorMultiplier * ( spriteIndex + 1 );
			_rect = new Rectangle();
			_root = this;
			spriteIndex++;
		}
		
		public function get width() : int {
			return _rect.width;
		}
		
		public function get height() : int {
			return _rect.width;
		}
		
		public function getRect() : Rectangle {
			return _rect.clone();
		}
		
		public function getRectByCoords( targetCoordinateSpace : SpriteSheet ) : Rectangle {
			// TODO targetCoordinateSpace is not in the iteration between stage/root and this
			if ( targetCoordinateSpace == _parent ) return getRect();
			else if ( targetCoordinateSpace == this ) {
				return new Rectangle( _registrationOffsetX, _registrationOffsetY, _rect.width, _rect.height );
			} else if ( targetCoordinateSpace && _parent ) {
				var container : SpriteSheetContainer = _parent;
				var rect : Rectangle = getRect();
				for ( ; container != null; ) {
					if ( container == _stage ) return rect;
					rect.x += container.x + container.registrationOffsetX;
					rect.y += container.y + container.registrationOffsetY;
					container = container.parent;
				}
				return rect;
			}
			return getRect();
		}
		
		public function globalToLocal( point : Point ) : Point {
			var sprite : SpriteSheet = _stage || _root;
			var localPoint : Point = point.clone();
			localPoint.x += _registrationOffsetX;
			localPoint.y += _registrationOffsetY;
			var i : int;
			var children : Vector.<SpriteSheet>;
			var childrenLength : int;
			var child : SpriteSheet;
			for ( ; sprite != null; ) {
//				trace(_name + ".globalToLocal(point)", point, localPoint, sprite.name);
				localPoint.x -= sprite.x + sprite.registrationOffsetX;
				localPoint.y -= sprite.y + sprite.registrationOffsetY;
				if ( sprite == this ) {
					return localPoint;
				}
				if ( sprite is SpriteSheetContainer ) {
					children = SpriteSheetContainer( sprite ).children;
					childrenLength = children.length;
					for ( i = 0; i < childrenLength; i++ ) {
						child = children[ int( i ) ];
						if ( ( child is SpriteSheetContainer && SpriteSheetContainer( child ).contains( this ) ) || child == this ) {
							sprite = child;
							continue;
						}
					}
				}
			}
//			trace(_name + ".globalToLocal(point)", point, localPoint);
			return localPoint;
		}
		
		public function localToGlobal( point : Point ) : Point {
			var container : SpriteSheetContainer = _parent;
			var globalPoint : Point = point.clone();
			globalPoint.x += _x;
			globalPoint.y += _y;
			for ( ; container != null; ) {
				if ( container == _stage ) return globalPoint;
				globalPoint.x += container.x + container.registrationOffsetX;
				globalPoint.y += container.y + container.registrationOffsetY;
				container = container.parent;
			}
			return globalPoint;
		}

		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}

		public function set bitmapData( bitmapData : BitmapData ) : void {
			if ( _bitmapData == bitmapData ) return;
			_bitmapData = bitmapData;
			_rect.width = _bitmapData ? _bitmapData.width : 0;
			_rect.height = _bitmapData ? _bitmapData.height : 0;
		}
		
		public function hitsPointOfBitmap( point : Point ) : Boolean {
			if ( _bitmapData && _bitmapData.transparent ) {
				point = point.clone();
				point.x -= _registrationOffsetX;
				point.y -= _registrationOffsetY;
				return _bitmapData.hitTest( _hitTestZeroPoint, 0, point );
			}
			var rect : Rectangle = new Rectangle( _registrationOffsetX, _registrationOffsetY, _rect.width, _rect.height );//getRectByCoords( this );
//			trace(_name + ".hitsPoint(point)", point, _rect);
			return rect.containsPoint( point );
		}

		public function get name() : String {
			return _name;
		}

		public function set name( name : String ) : void {
			_name = name;
		}

		public function get parent() : SpriteSheetContainer {
			return _parent;
		}

		blitting function bSetParent( parent : SpriteSheetContainer ) : void {
			if ( parent != _parent ) {
				setParent( parent );
				if ( _parent ) dispatchEvent( new Event( Event.ADDED ) );
				else dispatchEvent( new Event( Event.REMOVED ) );
			}
		}
		
		protected function setParent( parent : SpriteSheetContainer ) : void {
			_parent = parent;
		}

		public function get root() : SpriteSheet {
			return _root;
		}

		blitting function bSetRoot( root : SpriteSheet ) : void {
			if ( root != _root ) setRoot( root );
		}
		
		protected function setRoot( root : SpriteSheet ) : void {
			_root = root;
		}

		public function get stage() : SpriteSheetStage {
			return _stage;
		}

		blitting function bSetStage( stage : SpriteSheetStage ) : void {
			if ( stage != _stage ) {
				setStage( stage );
				if ( _stage ) dispatchEvent( new Event( Event.ADDED_TO_STAGE ) );
				else dispatchEvent( new Event( Event.REMOVED_FROM_STAGE ) );
			}
		}
		
		protected function setStage( stage : SpriteSheetStage ) : void {
			_stage = stage;
		}

		public function get visible() : Boolean {
			return _visible;
		}

		public function set visible( visible : Boolean ) : void {
			_visible = visible;
		}

		public function get x() : int {
			return _x;
		}

		public function set x( x : int ) : void {
			_x = x;
			_rect.x = _x + _registrationOffsetX;
		}

		public function get y() : int {
			return _y;
		}

		public function set y( y : int ) : void {
			_y = y;
			_rect.y = _y + _registrationOffsetY;
		}

		public function get registrationOffsetX() : int {
			return _registrationOffsetX;
		}

		public function set registrationOffsetX( registrationOffsetX : int ) : void {
			_registrationOffsetX = registrationOffsetX;
			_rect.x = _x + _registrationOffsetX;
		}

		public function get registrationOffsetY() : int {
			return _registrationOffsetY;
		}

		public function set registrationOffsetY( registrationOffsetY : int ) : void {
			_registrationOffsetY = registrationOffsetY;
			_rect.y = _y + _registrationOffsetY;
		}

		public function get mouseEnabled() : Boolean {
			return _mouseEnabled;
		}

		public function set mouseEnabled( mouseEnabled : Boolean ) : void {
			_mouseEnabled = mouseEnabled;
		}

		public function get useHandCursor() : Boolean {
			return _useHandCursor;
		}

		public function set useHandCursor( useHandCursor : Boolean ) : void {
			_useHandCursor = useHandCursor;
		}
	}
}
