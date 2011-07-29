package com.flashmastery.as3.blitting.isometrics {
	import com.flashmastery.as3.blitting.core.SpriteSheet;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class IsoSpriteSheetContainer extends IsoSpriteSheet {
		

		public function IsoSpriteSheetContainer() {
			super();
		}
		
		override protected function contruct() : void {
			super.contruct();
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
	}
}
