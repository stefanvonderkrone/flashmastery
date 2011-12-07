package com.flashmastery.as3.blitting.core {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="added", type="flash.events.Event")]
	[Event(name="removed", type="flash.events.Event")]
	[Event(name="addedToStage", type="flash.events.Event")]
	[Event(name="removedFromStage", type="flash.events.Event")]
	[Event(name="sMouseWheel", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sMouseMove", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sMouseOver", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sClick", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sMouseOut", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sMouseUp", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]
	[Event(name="sMouseDown", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheet extends EventDispatcher {
		
		protected static var spriteIndex : int = 0;
		protected static const shapeColorMultiplier : uint = 16;
		protected static const _hitTestZeroPoint : Point = new Point();
		
		// spriteSheet
		protected var _bitmapData : BitmapData;
		protected var _updated : Boolean = true;
		protected var _name : String;
		protected var _visible : Boolean = true;
		
		// bounds & position
		protected var _x : int = 0;
		protected var _y : int = 0;
		protected var _registrationOffsetX : int = 0;
		protected var _registrationOffsetY : int = 0;
		protected var _rect : Rectangle;
		protected var _bitmapDataHitTestRect : Rectangle;
		
		// display-list
		protected var _parent : SpriteSheetContainer;
		protected var _root : SpriteSheet;
		protected var _stage : SpriteSheetStage;
		protected var _stageRelation : String;
		
		// mouse detection
		protected var _mouseEnabled : Boolean = true;
		protected var _bMouseEnabled : Boolean = true;
		protected var _useHandCursor : Boolean = false;
		protected var _bUseHandCursor : Boolean = false;
		protected var _bStageIndex : int = -1;
		protected var _bStageRect : Rectangle;
		

		public function SpriteSheet() {
			super();
			construct();
		}

		protected function construct() : void {
			_name = "spriteSheet" + spriteIndex.toString();
			_rect = new Rectangle();
			_bitmapDataHitTestRect = new Rectangle();
			_root = this;
			spriteIndex++;
		}

		protected function setUpdated() : void {
			_updated = true;
			if ( _parent && !_parent.updated )
				_parent.bSetUpdated();
			if ( _stage ) {
				_stage.bUpdateChildOnStage( this );
				_stageRelation = getStageRelation();
			}
		}

		protected function getStageRelation() : String {
			var relation : String = _name;
			var parentSprite : SpriteSheet = _parent;
			while ( parentSprite ) {
				relation = parentSprite.name + "." + relation;
				parentSprite = parentSprite.parent;
			}
			return relation;
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
				return _bitmapDataHitTestRect.clone();//new Rectangle( _registrationOffsetX, _registrationOffsetY, _rect.width, _rect.height );
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
			var children : Vector.<SpriteSheet>;
			var childIndex : int;
			var child : SpriteSheet;
			if ( sprite == this || ( sprite is SpriteSheetContainer && SpriteSheetContainer( sprite ).contains( this ) ) ) {
				while ( sprite != null ) {
					localPoint.x -= sprite.x + sprite.registrationOffsetX;
					localPoint.y -= sprite.y + sprite.registrationOffsetY;
					if ( sprite == this ) {
						return localPoint;
					}
					if ( sprite is SpriteSheetContainer ) {
						children = SpriteSheetContainer( sprite ).children;
						childIndex = children.length;
						while ( --childIndex > -1 ) {
							child = children[ int( childIndex ) ];
							if ( ( child is SpriteSheetContainer && SpriteSheetContainer( child ).contains( this ) ) || child == this ) {
								sprite = child;
								break;
							}
						}
					}
				}
			}
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
			if ( _bitmapData != bitmapData ) {
	//			trace("SpriteSheet.bitmapData(bitmapData)");
				_bitmapData = bitmapData;
				_rect.width = _bitmapDataHitTestRect.width = _bitmapData ? _bitmapData.width : 0;
				_rect.height = _bitmapDataHitTestRect.height = _bitmapData ? _bitmapData.height : 0;
				setUpdated();
			}
		}
		
		public function hitsPointOfBitmap( point : Point ) : Boolean {
			if ( _bitmapData && _bitmapData.transparent ) {
				point = point.clone();
				point.x -= _registrationOffsetX;
				point.y -= _registrationOffsetY;
//				trace( _name, "hitsPointOfBitmap", point, _bitmapData.hitTest( _hitTestZeroPoint, 0, point ) );
				return _bitmapData.hitTest( _hitTestZeroPoint, 0, point );
			}
//			_bitmapDataHitTestRect = new Rectangle( _registrationOffsetX, _registrationOffsetY, _rect.width, _rect.height );//getRectByCoords( this );
//			trace(_name + ".hitsPoint(point)", point, _rect);
			return _bitmapDataHitTestRect.containsPoint( point );
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

		public function bSetParent( parent : SpriteSheetContainer ) : void {
//			trace(this + ".bSetParent(parent)");
			if ( parent != _parent ) {
				_parent = parent;
				if ( _parent ) {
					dispatchEvent( new Event( Event.ADDED ) );
					_updated = true;
					if ( _parent && !_parent.updated )
						_parent.bSetUpdated();
				} else dispatchEvent( new Event( Event.REMOVED ) );
			}
		}

		public function get root() : SpriteSheet {
			return _root;
		}

		public function bSetRoot( root : SpriteSheet ) : void {
			if ( root != _root ) _root = root;
		}

		public function get stage() : SpriteSheetStage {
			return _stage;
		}

		public function bSetStage( stage : SpriteSheetStage ) : void {
			if ( stage != _stage ) {
				if ( _stage ) _stage.bRemoveChildFromStage( this );
				_stage = stage;
				if ( _stage ) {
					_stage.bAddChildToStage( this );
					dispatchEvent( new Event( Event.ADDED_TO_STAGE ) );
				}
				else dispatchEvent( new Event( Event.REMOVED_FROM_STAGE ) );
			}
		}

		public function get visible() : Boolean {
			return _visible;
		}

		public function set visible( visible : Boolean ) : void {
			if ( visible != _visible ) {
				_visible = visible;
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get x() : int {
			return _x;
		}

		public function set x( x : int ) : void {
			if ( x != _x ) {
				_x = x;
				_rect.x = _x + _registrationOffsetX;
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get y() : int {
			return _y;
		}

		public function set y( y : int ) : void {
			if ( y != _y ) {
				_y = y;
				_rect.y = _y + _registrationOffsetY;
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get registrationOffsetX() : int {
			return _registrationOffsetX;
		}

		public function set registrationOffsetX( registrationOffsetX : int ) : void {
			if ( registrationOffsetX != _registrationOffsetX ) {
				_registrationOffsetX = registrationOffsetX;
				_rect.x = _x + _registrationOffsetX;
				_bitmapDataHitTestRect.x = _registrationOffsetX;
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get registrationOffsetY() : int {
			return _registrationOffsetY;
		}

		public function set registrationOffsetY( registrationOffsetY : int ) : void {
			if ( registrationOffsetY != _registrationOffsetY ) {
				_registrationOffsetY = registrationOffsetY;
				_rect.y = _y + _registrationOffsetY;
				_bitmapDataHitTestRect.y = _registrationOffsetY;
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get mouseEnabled() : Boolean {
			return _mouseEnabled && _bMouseEnabled;
		}

		public function set mouseEnabled( mouseEnabled : Boolean ) : void {
			_mouseEnabled = mouseEnabled;
		}

		public function bMouseEnabled( bMouseEnabled : Boolean ) : void {
			_bMouseEnabled = bMouseEnabled;
		}

		public function get useHandCursor() : Boolean {
			return _useHandCursor || _bUseHandCursor;
		}

		public function set useHandCursor( useHandCursor : Boolean ) : void {
			_useHandCursor = useHandCursor;
		}

		public function bUseHandCursor( bUseHandCursor : Boolean ) : void {
			_bUseHandCursor = bUseHandCursor;
		}
		
		public function updateBeforRender() : void {
		}
		
		public function updateAfterRender() : void {
			_updated = false;
		}

		public function get updated() : Boolean {
			return _updated;
		}

		public function get bStageIndex() : int {
			return _bStageIndex;
		}

		public function set bStageIndex( bStageIndex : int ) : void {
			_bStageIndex = bStageIndex;
		}

		public function get bStageRect() : Rectangle {
			return _bStageRect;
		}

		public function set bStageRect( bStageRect : Rectangle ) : void {
			_bStageRect = bStageRect;
		}

		public function get stageRelation() : String {
			return _stageRelation;
		}
	}
}
