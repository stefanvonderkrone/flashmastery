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
		
		protected var _bitmapData : BitmapData;
		protected var _name : String;
		protected var _parent : SpriteSheetContainer;
		protected var _root : SpriteSheet;
		protected var _stage : SpriteSheetStage;
		protected var _visible : Boolean = true;
		protected var _x : int = 0;
		protected var _y : int = 0;
		protected var _registrationPointX : int = 0;
		protected var _registrationPointY : int = 0;
		protected var _mouseEnabled : Boolean = false;
		protected var _shapeColor : uint;
		protected var _rect : Rectangle;

		public function SpriteSheet() {
			super();
			contruct();
		}

		protected function contruct() : void {
			_name = "spriteSheet" + spriteIndex.toString();
			_shapeColor = shapeColorMultiplier * spriteIndex;
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
			return _rect;
		}
		
		public function getRectByCoords( targetCoordinateSpace : SpriteSheet ) : Rectangle {
			// TODO targetCoordinateSpace is not in the iteration between stage/root and this
			// TODO this contains targetCoordinateSpace 
			if ( targetCoordinateSpace == _parent ) return getRect().clone();
			else if ( targetCoordinateSpace && _parent ) {
				var container : SpriteSheetContainer = _parent;
				var rect : Rectangle = _rect.clone();
				for ( ; container != null; ) {
					if ( container == _stage ) return rect;
					rect.x += container.x - container.registrationPointX;
					rect.y += container.y - container.registrationPointY;
					container = container.parent;
				}
			}
			return getRect().clone();
		}
		
		public function globalToLocal( point : Point ) : Point {
			var sprite : SpriteSheet = _stage || _root;
			var localPoint : Point = point.clone();
			var i : int;
			var children : Vector.<SpriteSheet>;
			var childrenLength : int;
			var child : SpriteSheet;
			for ( ; sprite != null; ) {
				localPoint.x -= sprite.x - sprite.registrationPointX;
				localPoint.y += sprite.y - sprite.registrationPointY;
				if ( sprite == this ) return localPoint;
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
			return localPoint;
		}
		
		public function localToGlobal( point : Point ) : Point {
			var container : SpriteSheetContainer = _parent;
			var globalPoint : Point = point.clone();
			for ( ; container != null; ) {
				if ( container == _stage ) return globalPoint;
				globalPoint.x += container.x - container.registrationPointX;
				globalPoint.y += container.y - container.registrationPointY;
				container = container.parent;
			}
			return globalPoint;
		}

		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}

		public function set bitmapData( bitmapData : BitmapData ) : void {
			_bitmapData = bitmapData;
			_rect.width = _bitmapData.width;
			_rect.height = _bitmapData.height;
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
			_rect.x = _x - _registrationPointX;
		}

		public function get y() : int {
			return _y;
		}

		public function set y( y : int ) : void {
			_y = y;
			_rect.y = _y - _registrationPointY;
		}

		public function get registrationPointX() : int {
			return _registrationPointX;
		}

		public function set registrationPointX( registrationPointX : int ) : void {
			_registrationPointX = registrationPointX;
			_rect.x = _x - _registrationPointX;
		}

		public function get registrationPointY() : int {
			return _registrationPointY;
		}

		public function set registrationPointY( registrationPointY : int ) : void {
			_registrationPointY = registrationPointY;
			_rect.y = _y - _registrationPointY;
		}

		public function get mouseEnabled() : Boolean {
			return _mouseEnabled;
		}

		public function set mouseEnabled( mouseEnabled : Boolean ) : void {
			_mouseEnabled = mouseEnabled;
		}
	}
}
