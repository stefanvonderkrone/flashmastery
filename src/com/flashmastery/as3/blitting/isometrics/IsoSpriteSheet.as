package com.flashmastery.as3.blitting.isometrics {
	import com.flashmastery.as3.blitting.core.SpriteSheetContainer;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class IsoSpriteSheet extends SpriteSheetContainer {
		
		protected var _isoX : Number = 0;
		protected var _isoY : Number = 0;
		protected var _isoZ : Number = 0;
		protected var _cellSizeX : uint = 50;
		protected var _cellSizeY : uint = 25;
		protected var _cellSizeZ : uint = 25;
		protected var _flattenedPosY : Number;

		public function IsoSpriteSheet() {
			super();
		}

		public function get isoX() : Number {
			return _isoX;
		}

		public function set isoX( isoX : Number ) : void {
			_isoX = isoX;
			updateCoords();
		}

		public function get isoY() : Number {
			return _isoY;
		}

		public function set isoY( isoY : Number ) : void {
			_isoY = isoY;
			updateCoords();
		}

		public function get isoZ() : Number {
			return _isoZ;
		}

		public function set isoZ( isoZ : Number ) : void {
			_isoZ = isoZ;
			updateCoords();
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
			x = _isoX * _cellSizeX / 2 - _isoY * _cellSizeX / 2;
			y = _isoX * _cellSizeY / 2 + _isoY * _cellSizeY / 2;
			_flattenedPosY = _y;
			y = _isoX * _cellSizeY / 2 + _isoY * _cellSizeY / 2 - _isoZ * _cellSizeZ;
		}

		public function get flattenedPosY() : Number {
			return _flattenedPosY;
		}
	}
}
