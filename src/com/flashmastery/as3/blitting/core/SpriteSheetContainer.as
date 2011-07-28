package com.flashmastery.as3.blitting.core {
	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetContainer extends SpriteSheet {
		
		protected var _children : Vector.<SpriteSheet>;
		protected var _mouseChildren : Boolean = true;

		public function SpriteSheetContainer() {
			super();
		}
		
		override protected function contruct() : void {
			super.contruct();
			_children = new Vector.<SpriteSheet>();
			_mouseEnabled = true;
		}

		protected function isInvalidChild( child : SpriteSheet, container : SpriteSheetContainer ) : Boolean {
			if ( container.parent == null ) return false;
			else if ( container.parent == stage ) return false;
			else if ( container.parent == child ) return true;
			return isInvalidChild( child, container.parent );
		}

		public function addChild( child : SpriteSheet ) : SpriteSheet {
			if ( isInvalidChild( child, this ) || child == this ) return null;
			if ( _children.indexOf( child ) > -1 )
				_children.splice( _children.indexOf( child ), 1 );
			_children.push( child );
			child.blitting::bSetParent( this );
			if ( root ) child.blitting::bSetRoot( root );
			if ( stage ) child.blitting::bSetStage( stage );
			return child;
		}

		public function addChildAt( child : SpriteSheet, index : int ) : SpriteSheet {
			if ( isInvalidChild( child, this ) || child == this ) return null;
			if ( _children.indexOf( child ) > -1 ) {
				_children.splice( _children.indexOf( child ), 1 );
				 index < _children.length ? _children.splice( index, 0, child ) : _children.push( child );
			} else _children.splice( index, 0, child );
			child.blitting::bSetParent( this );
			if ( root ) child.blitting::bSetRoot( root );
			if ( stage ) child.blitting::bSetStage( stage );
			return child;
		}

		public function contains( child : SpriteSheet ) : Boolean {
			var valid : Boolean = _children.indexOf( child ) > -1 || child == this;
			if ( !valid ) {
				var length : int = _children.length;
				var sprite : SpriteSheet;
				for ( var i : int = 0; i < length; i++ ) {
					sprite = _children[ int( i ) ];
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
			var numSprites : int = _children.length;
			for ( var i : int = 0; i < numSprites; i++ ) {
				if ( _children[ int( i ) ].name == name )
					return _children[ int( i ) ];
			}
			return null;
		}

		public function getChildIndex( child : SpriteSheet ) : int {
			return _children.indexOf( child );
		}

		public function get numChildren() : int {
			return _children.length;
		}

		public function removeChild( child : SpriteSheet ) : SpriteSheet {
			if ( _children.indexOf( child ) > -1 ) {
				_children.splice( _children.indexOf( child ), 1 );
				child.blitting::bSetParent( null );
				child.blitting::bSetRoot( child );
				child.blitting::bSetStage( null );
			}
			return child;
		}

		public function removeChildAt( index : int ) : SpriteSheet {
			var child : SpriteSheet = index < _children.length ? _children[ index ] : null;
			if ( child ) {
				_children.splice( index, 1 );
				child.blitting::bSetParent( null );
				child.blitting::bSetRoot( child );
				child.blitting::bSetStage( null );
			}
			return child;
		}

		public function setChildIndex( child : SpriteSheet, index : int ) : void {
			if ( _children.indexOf( child ) > -1 && index < _children.length )
				addChildAt( child, index );
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
			}
		}

		public function get children() : Vector.<SpriteSheet> {
			return _children;
		}
		
		override public function getRect() : Rectangle {
			var rect : Rectangle = super.getRect();
			var childRect : Rectangle;
			var child : SpriteSheet;
			var length : int = _children.length;
			for ( var i : int = 0; i < length; i++ ) {
				child = _children[ int( i ) ];
				if ( childRect == null ) childRect = child.getRect();
				childRect = childRect.union( child.getRect() );
			}
			childRect.x += _rect.x;
			childRect.y += _rect.y;
			rect = rect.union( childRect );
			return rect;
		}
		
		override public function getRectByCoords( targetCoordinateSpace : SpriteSheet ) : Rectangle {
			if ( contains( targetCoordinateSpace ) ) {
				var rect : Rectangle = new Rectangle();
//				trace(_name + ".getRectByCoords(targetCoordinateSpace)", rect);
				var i : int;
				if ( targetCoordinateSpace == this ) {
					var child : SpriteSheet;
					var childrenLength : int = _children.length;
					var childRect : Rectangle;
					for ( i = 0; i < childrenLength; i++ ) {
						child = _children[ int( i ) ];
						childRect = child.getRectByCoords( this );
						rect = rect.union( childRect );
					}
//					trace(_name + ".getRectByCoords(targetCoordinateSpace)", rect);
					return rect;
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

		public function get mouseChildren() : Boolean {
			return _mouseChildren;
		}

		public function set mouseChildren( mouseChildren : Boolean ) : void {
			_mouseChildren = mouseChildren;
		}
	}
}