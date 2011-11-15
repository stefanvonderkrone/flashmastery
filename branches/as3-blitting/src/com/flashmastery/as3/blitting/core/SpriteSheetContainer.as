package com.flashmastery.as3.blitting.core {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetContainer extends SpriteSheet {
		
		protected var _children : Vector.<SpriteSheet>;
		protected var _mouseChildren : Boolean = true;
		
		private var _innerCoordsRect : Rectangle;

		public function SpriteSheetContainer() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
			_children = new Vector.<SpriteSheet>();
			_innerCoordsRect = new Rectangle();
		}

		protected function isInvalidChild( child : SpriteSheet, container : SpriteSheetContainer ) : Boolean {
			if ( container.parent == null ) return false;
			else if ( container.parent == stage ) return false;
			else if ( container.parent == child ) return true;
			return isInvalidChild( child, container.parent );
		}

		public function addChild( child : SpriteSheet ) : SpriteSheet {
//			trace(this + ".addChild(child)", child, isInvalidChild( child, this ), child == this);
			if ( isInvalidChild( child, this ) || child == this ) return null;
			if ( _children.indexOf( child ) > -1 )
				_children.splice( _children.indexOf( child ), 1 );
			else if ( child.parent && child.parent != this )
				child.parent.removeChild( child );
			_children.push( child );
			child.bSetParent( this );
			child.bMouseEnabled( _mouseChildren && _mouseEnabled );
			child.bUseHandCursor( _useHandCursor );
			if ( root ) child.bSetRoot( root );
			if ( stage ) child.bSetStage( stage );
			_updated = true;
			if ( _parent && !_parent.updated )
				_parent.bSetUpdated();
			return child;
		}

		public function addChildAt( child : SpriteSheet, index : int ) : SpriteSheet {
			if ( isInvalidChild( child, this ) || child == this ) return null;
			if ( _children.indexOf( child ) > -1 ) {
				_children.splice( _children.indexOf( child ), 1 );
				 index < _children.length ? _children.splice( index, 0, child ) : _children.push( child );
			} else {
				if ( child.parent && child.parent != this )
					child.parent.removeChild( child );
				_children.splice( index, 0, child );
			}
			child.bSetParent( this );
			child.bMouseEnabled( _mouseChildren && _mouseEnabled );
			child.bUseHandCursor( _useHandCursor );
			if ( root ) child.bSetRoot( root );
			if ( stage ) child.bSetStage( stage );
			_updated = true;
			if ( _parent && !_parent.updated )
				_parent.bSetUpdated();
			return child;
		}

		public function contains( child : SpriteSheet ) : Boolean {
			var valid : Boolean = _children.indexOf( child ) > -1 || child == this;
			if ( !valid ) {
				var index : int = _children.length;
				var sprite : SpriteSheet;
				while ( --index > -1 ) {
					sprite = _children[ int( index ) ];
					if ( sprite is SpriteSheetContainer && SpriteSheetContainer( sprite ).contains( child ) )
						return true;
				}
			}
			return valid;
		}

		public function getChildAt( index : int ) : SpriteSheet {
			return index < _children.length ? _children[ index ] : null;
		}

		public function getChildByName( name : String ) : SpriteSheet {
			var index : int = _children.length;
			while ( --index > -1 ) {
				if ( _children[ int( index ) ].name == name )
					return _children[ int( index ) ];
			}
			return null;
		}

		public function getChildIndex( child : SpriteSheet ) : int {
			return _children.indexOf( child );
		}
		
		public function hitsPoint( point : Point ) : Boolean {
			var length : int = _children.length;
			var child : SpriteSheet;
			var localPoint : Point;
			while( --length > -1 ) {
				child = _children[ int( length ) ];
				localPoint = point.clone();
				localPoint.x -= child.x;// + child.registrationOffsetX;
				localPoint.y -= child.y;// + child.registrationOffsetY;
				if ( child is SpriteSheetContainer && SpriteSheetContainer( child ).hitsPoint( localPoint ) ) {
					return true;
				} else if ( child.hitsPointOfBitmap( localPoint ) ) {
					return true;
				}
			}
			return hitsPointOfBitmap( point );
		}

		public function get numChildren() : int {
			return _children.length;
		}

		public function removeChild( child : SpriteSheet ) : SpriteSheet {
			if ( _children.indexOf( child ) > -1 ) {
				_children.splice( _children.indexOf( child ), 1 );
				child.bSetParent( null );
				child.bSetRoot( child );
				child.bSetStage( null );
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
			return child;
		}

		public function removeChildAt( index : int ) : SpriteSheet {
			var child : SpriteSheet = index < _children.length ? _children[ index ] : null;
			if ( child ) {
				_children.splice( index, 1 );
				child.bSetParent( null );
				child.bSetRoot( child );
				child.bSetStage( null );
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
			return child;
		}

		public function setChildIndex( child : SpriteSheet, index : int ) : void {
			if ( _children.indexOf( child ) > -1 && index < _children.length ) {
				addChildAt( child, index );
				if ( _stage ) _stage.bUpdateChildOnStage( child );
			}
		}

		public function swapChildren( child1 : SpriteSheet, child2 : SpriteSheet ) : void {
			if ( _children.indexOf( child1 ) > -1 && _children.indexOf( child2 ) > -1 )
				swapChildrenAt( getChildIndex( child1 ), getChildIndex( child2 ) );
		}

		public function swapChildrenAt( index1 : int, index2 : int ) : void {
			var child1 : SpriteSheet = getChildAt( index1 );
			var child2 : SpriteSheet = getChildAt( index2 );
			if (child1 && child2) {
				if (index1 < index2) {
					setChildIndex( child1, index2 );
					setChildIndex( child2, index1 );
				} else {
					setChildIndex( child2, index1 );
					setChildIndex( child1, index2 );
				}
				if ( _stage ) {
					_stage.bUpdateChildOnStage( child1 );
					_stage.bUpdateChildOnStage( child2 );
				}
				_updated = true;
				if ( _parent && !_parent.updated )
					_parent.bSetUpdated();
			}
		}

		public function get children() : Vector.<SpriteSheet> {
			return _children;
		}
		
		override public function getRect() : Rectangle {
			var rect : Rectangle = super.getRect();
			var childRect : Rectangle;
			var child : SpriteSheet;
			var index : int = _children.length;
			while ( --index > -1 ) {
				child = _children[ int( index ) ];
				if ( childRect == null ) childRect = child.getRect();
				childRect = childRect.union( child.getRect() );
			}
			if ( childRect ) {
				childRect.x += _rect.x;
				childRect.y += _rect.y;
				rect = rect.union( childRect );
			}
			return rect;
		}
		
		override public function getRectByCoords( targetCoordinateSpace : SpriteSheet ) : Rectangle {
			if ( contains( targetCoordinateSpace ) ) {
				_innerCoordsRect.x = 0;
				_innerCoordsRect.y = 0;
				_innerCoordsRect.width = 0;
				_innerCoordsRect.height = 0;
//				trace(_name + ".getRectByCoords(targetCoordinateSpace)", rect);
				if ( targetCoordinateSpace == this ) {
					var child : SpriteSheet;
					var childIndex : int = _children.length;
					var childRect : Rectangle;
					while ( --childIndex > -1 ) {
						child = _children[ int( childIndex ) ];
						childRect = child.getRectByCoords( this );
						_innerCoordsRect = _innerCoordsRect.union( childRect );
					}
//					trace(_name + ".getRectByCoords(targetCoordinateSpace)", rect);
					return _innerCoordsRect;
				} else {
					// TODO this contains targetCoordinateSpace
				}
			}
			return super.getRectByCoords( targetCoordinateSpace );
		}
		
		override public function get width() : int {
			if ( _children.length > 0 )
				return getRectByCoords( this ).width;
			return _rect.width;
		}
		
		override public function get height() : int {
			if ( _children.length > 0 )
				return getRectByCoords( this ).height;
			return _rect.height;
		}
		
		override public function bSetRoot( root : SpriteSheet ) : void {
			if ( root != _root ) {
				super.bSetRoot( root );
				var index : int = _children.length;
				while ( --index > -1 )
					_children[ int( index ) ].bSetRoot( root );
			}
		}
		
		override public function bSetStage( stage : SpriteSheetStage ) : void {
			if ( stage != _stage ) {
				super.bSetStage( stage );
				var index : int = _children.length;
				while ( --index > -1 )
					_children[ int( index ) ].bSetStage( stage );
			}
		}

		public function get mouseChildren() : Boolean {
			return _mouseChildren;
		}

		public function set mouseChildren( mouseChildren : Boolean ) : void {
			_mouseChildren = mouseChildren;
			var index : int = _children.length;
			while ( --index > -1 )
				_children[ int( index ) ].bMouseEnabled( !( _mouseChildren || _mouseEnabled ) );
		}
		
		override public function set mouseEnabled( mouseEnabled : Boolean ) : void {
			_mouseEnabled = mouseEnabled;
			var index : int = _children.length;
			while ( --index > -1 )
				_children[ int( index ) ].bMouseEnabled( !( _mouseChildren || _mouseEnabled ) );
		}
		
		override public function set useHandCursor( useHandCursor : Boolean ) : void {
			_useHandCursor = useHandCursor;
			var index : int = _children.length;
			while ( --index > -1 )
				_children[ int( index ) ].bUseHandCursor( useHandCursor );
		}
		
		public function bSetUpdated() : void {
//			trace(this + ".bSetUpdated()");
			_updated = true;
			if ( _parent && !_parent.updated )
				_parent.bSetUpdated();
		}
		
		override public function updateBeforRender() : void {
			super.updateBeforRender();
			var index : int = _children.length;
			while ( --index > -1 )
				_children[ int( index ) ].updateBeforRender();
		}
		
		override public function updateAfterRender() : void {
			super.updateAfterRender();
			var index : int = _children.length;
			while ( --index > -1 )
				_children[ int( index ) ].updateAfterRender();
		}
	}
}
