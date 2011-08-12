package com.flashmastery.as3.blitting.isometrics {
	import com.flashmastery.as3.blitting.core.SpriteSheetContainer;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class IsoSpriteSheet extends SpriteSheetContainer {
		
		protected var _isoX : Number;
		protected var _isoY : Number;
		protected var _isoZ : Number;
		protected var _cellSizeX : uint;
		protected var _cellSizeY : uint;
		protected var _cellSizeZ : uint;
		protected var _flattenedPosY : Number;
		protected var _autoEvenIsoCoords : Boolean;

		public function IsoSpriteSheet() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
			_isoX = 0;
			_isoY = 0;
			_isoZ = 0;
			_cellSizeX = 50;
			_cellSizeY = 25;
			_cellSizeZ = 25;
			_autoEvenIsoCoords = false;
		}

		public function get isoX() : Number {
			return _isoX;
		}

		public function set isoX( isoX : Number ) : void {
			_isoX = _autoEvenIsoCoords ? Math.round( isoX ) : isoX;
			updateCoords();
		}

		public function get isoY() : Number {
			return _isoY;
		}

		public function set isoY( isoY : Number ) : void {
			_isoY = _autoEvenIsoCoords ? Math.round( isoY ) : isoY;
			updateCoords();
		}

		public function get isoZ() : Number {
			return _isoZ;
		}

		public function set isoZ( isoZ : Number ) : void {
			_isoZ = isoZ;
			updateCoords();
		}
		
		override public function set x( x : int ) : void {
			super.x = x;
			updateIsoCoords();
		}
		
		override public function set y( y : int ) : void {
			super.y = y;
			updateIsoCoords();
		}
		
		public function get cellSizeX() : uint {
			return _cellSizeX;
		}

		public function set cellSizeX( cellSizeX : uint ) : void {
			_cellSizeX = cellSizeX;
			updateCoords();
		}

		public function get cellSizeY() : uint {
			return _cellSizeY;
		}

		public function set cellSizeY( cellSizeY : uint ) : void {
			_cellSizeY = cellSizeY;
			updateCoords();
		}

		public function get cellSizeZ() : uint {
			return _cellSizeZ;
		}

		public function set cellSizeZ( cellSizeZ : uint ) : void {
			_cellSizeZ = cellSizeZ;
			updateCoords();
		}

		protected function updateCoords() : void {
			super.x = ( _isoX - _isoY ) * _cellSizeX / 2;
			_flattenedPosY = ( _isoX + _isoY ) * _cellSizeY / 2;
			super.y = _flattenedPosY - _isoZ * _cellSizeZ;
		}

		protected function updateIsoCoords() : void {
			_isoX = _x / _cellSizeX + _y / _cellSizeY;
			_isoY = ( _y + _isoZ * _cellSizeZ ) / _cellSizeY - _x / _cellSizeX;
			if ( _autoEvenIsoCoords ) {
				_isoX = Math.round( _isoX );
				_isoY = Math.round( _isoY );
				updateCoords();
			} else _flattenedPosY = _y + _isoZ * _cellSizeZ;
		}

		public function get flattenedPosY() : Number {
			return _flattenedPosY;
		}

		public function get autoEvenIsoCoords() : Boolean {
			return _autoEvenIsoCoords;
		}

		public function set autoEvenIsoCoords( autoEvenIsoCoords : Boolean ) : void {
			_autoEvenIsoCoords = autoEvenIsoCoords;
		}
	}
}
