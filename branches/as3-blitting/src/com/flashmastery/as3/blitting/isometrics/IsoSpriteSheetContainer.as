package com.flashmastery.as3.blitting.isometrics {
	import com.flashmastery.as3.blitting.core.SpriteSheet;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class IsoSpriteSheetContainer extends IsoSpriteSheet {
		

		public function IsoSpriteSheetContainer() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
		}
		
		override public function addChild( child : SpriteSheet ) : SpriteSheet {
			if ( child is IsoSpriteSheet ) {
				IsoSpriteSheet( child ).cellSizeX = _cellSizeX;
				IsoSpriteSheet( child ).cellSizeY = _cellSizeY;
				IsoSpriteSheet( child ).cellSizeZ = _cellSizeZ;
				return super.addChild( child );
			}
			return null;
		}
		
		override public function addChildAt( child : SpriteSheet, index : int ) : SpriteSheet {
			if ( child is IsoSpriteSheet ) {
				IsoSpriteSheet( child ).cellSizeX = _cellSizeX;
				IsoSpriteSheet( child ).cellSizeY = _cellSizeY;
				IsoSpriteSheet( child ).cellSizeZ = _cellSizeZ;
				return super.addChildAt( child, index );
			} 
			return null;
		}
		
		override public function set cellSizeX( cellSizeX : uint ) : void {
			super.cellSizeX = cellSizeX;
			var length : int = _children.length;
			var child : SpriteSheet;
			for ( var i : int = 0; i < length; i++ ) {
				child = _children[ int( i ) ];
				if ( child is IsoSpriteSheet )
					IsoSpriteSheet( child ).cellSizeX = _cellSizeX;
			}
		}
		
		override public function set cellSizeY( cellSizeY : uint ) : void {
			super.cellSizeY = cellSizeY;
			var length : int = _children.length;
			var child : SpriteSheet;
			for ( var i : int = 0; i < length; i++ ) {
				child = _children[ int( i ) ];
				if ( child is IsoSpriteSheet )
					IsoSpriteSheet( child ).cellSizeY = _cellSizeY;
			}
		}
		
		override public function set cellSizeZ( cellSizeZ : uint ) : void {
			super.cellSizeZ = cellSizeZ;
			var length : int = _children.length;
			var child : SpriteSheet;
			for ( var i : int = 0; i < length; i++ ) {
				child = _children[ int( i ) ];
				if ( child is IsoSpriteSheet )
					IsoSpriteSheet( child ).cellSizeZ = _cellSizeZ;
			}
		}
		
		override public function updateForRender() : void {
			if ( _children.length > 0 )
				sortChildren( _children );
		}

		protected function sortChildren( children : Vector.<SpriteSheet> ) : void {
			var sortList : Array = [];
			var unsortedList : Array = [];
			var i : int;
			var length : uint = children.length;
			var child : SpriteSheet;
			for ( i = 0; i < length; i++ ) {
				child = children[int( i )];
				if ( child is IsoSpriteSheet )
					sortList.push( child );
				else unsortedList.push( child );
			}
			sortList.sortOn( "flattenedPosY", Array.NUMERIC );
			sortList = unsortedList.concat( sortList );
			for ( i = 0; i < length; i++ )
				_children[ int( i ) ] = sortList[ int( i ) ];
		}
	}
}
