package com.flashmastery.as3.paper3d.components {
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.utils.SimpleShadow;

	import com.greensock.TweenLite;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class Book3D extends ObjectContainer3D {

		protected var _pages3D : Array;
		protected var _openAngle : Number;
		protected var _closeAngle : Number;
		protected var _baseBendForce : Number;
		protected var _baseBendOffset : Number;
		protected var _bendForce : Number;
		protected var _currentPage3DIndex : int;
		protected var _flip : Number;
		protected var _flipDuration : Number;
//		protected var _shadowLis
		protected var _changed : Boolean;

		public function Book3D( openAngle : Number, closeAngle : Number ) {
			super( );
			_openAngle = openAngle;
			_closeAngle = closeAngle;
			_baseBendForce = 0.1;
			_baseBendOffset = 0.8;
			_bendForce = 0;
			_changed = false;
			_pages3D = [];
			_flipDuration = 1;
			_currentPage3DIndex = 0;
			_flip = Page3D.FLIP_CONCAVE;
		}

		public function addPage3D( page3D : Page3D ) : Page3D {
			_pages3D.push( page3D );
			addChild( page3D );
			_changed = true;
			return page3D;
		}
		
		public function addPage3DAt( page3D : Page3D, index : int ) : Page3D {
			_pages3D.splice( index, 0, page3D );
			addChild( page3D );
			_changed = true;
			return page3D;
		}
		
		public function removePage3D( page3D : Page3D ) : Page3D {
			for ( var i : uint = 0; i < _pages3D.length; i++ ) {
				if ( _pages3D[ i ] == page3D ) {
					_pages3D.splice( i, 1 );
					removeChild( page3D );
					_changed = true;
					return page3D;
				}
			}
			return null;
		}
		
		public function removePage3DAt( index : int ) : Page3D {
			if ( _pages3D.length > index ) {
				removeChild( _pages3D[ index ] );
				_changed = true;
				return _pages3D.splice( index, 1 )[ 0 ];
			}
			return null;
		}
		
		public function contains( page3D : Page3D ) : Boolean {
			var _page3D : Page3D;
			for each ( _page3D in _pages3D ) {
				if ( _page3D == page3D ) return true;
			}
			return false;
		}
		
		public function getPage3DAt( index : int ) : Page3D {
			return _pages3D[ index ];
		}
		
		public function getPage3DByName( name : String ) : Page3D {
			var page3D : Page3D;
			for each ( page3D in _pages3D ) {
				if ( page3D.name == name ) return page3D;
			}
			return null;
		}
		
		public function getPage3DIndex( page3D : Page3D ) : int {
			for ( var i : uint = 0; i < _pages3D.length; i++ ) {
				if ( _pages3D[ i ] == page3D ) return i;
			}
			return -1;
		}
		
		public function nextPage3D() : void {
			trace( "nextPage3D() " + _currentPage3DIndex );
			var page3D : Page3D;
			if ( numPages3D > _currentPage3DIndex ) {
				page3D = getPage3DAt( _currentPage3DIndex++ );
				page3D.flip = _flip;
				TweenLite.killTweensOf( page3D );
				TweenLite.to( page3D, _flipDuration, { openingRel: 1, onUpdate: handleUpdate } );
			}
		}
		
		public function previousPage3D() : void {
			trace( "previousPage3D() " + _currentPage3DIndex );
			var page3D : Page3D;
			if ( _currentPage3DIndex > 0 ) {
				page3D = getPage3DAt( --_currentPage3DIndex );
				page3D.flip = -_flip;
				TweenLite.killTweensOf( page3D );
				TweenLite.to( page3D, _flipDuration, { openingRel: 0, onUpdate: handleUpdate } );
			}
		}
		
		protected function applyShadow() : void {
			var shadow : SimpleShadow = new SimpleShadow( this );
			shadow.apply( scene );
//			var page3D : Page3D;
//			for each ( page3D in _pages3D ) {
//				shadow = new SimpleShadow( page3D );
//				shadow.apply( scene );
//			}
		}
		
		protected function managePages3D() : void {
			trace( "managePages3D()");
			var page3D : Page3D;
			var i : uint = 0;
			if ( numPages3D > 1 ) {
				for ( i; i < _pages3D.length; i++ ) {
					page3D = _pages3D[ i ];
					page3D.baseBendForce = _baseBendForce - _baseBendForce * 2 * i / ( numPages3D - 1 );					page3D.baseBendForce = page3D.baseBendForce - page3D.baseBendForce * 2 * page3D.openingRel;
					page3D.closeAngle = _closeAngle - _closeAngle * 2 * i / ( numPages3D - 1 );					page3D.openAngle = _openAngle + _closeAngle * 2 - _closeAngle * 2 * i / ( numPages3D - 1 );
//					trace( page3D.baseBendForce + " / " + page3D.closeAngle + " / " + page3D.openAngle );
				}
			}
		}
		
		protected function handleUpdate() : void {
			_changed = true;
		}

		public function get currentPage3DIndex() : int {
			return _currentPage3DIndex;
		}
		
		public function get currentPage3D() : Page3D {
			return getPage3DAt( _currentPage3DIndex );
		}
		
		public function get numPages3D() : uint {
			return _pages3D.length;
		}
		
		public function get openAngle() : Number {
			return _openAngle;
		}
		
		public function set openAngle(openAngle : Number) : void {
			_openAngle = openAngle;
			_changed = true;
		}
		
		public function get closeAngle() : Number {
			return _closeAngle;
		}
		
		public function set closeAngle(closeAngle : Number) : void {
			_closeAngle = closeAngle;
			_changed = true;
		}
		
		public function get baseBendForce() : Number {
			return _baseBendForce;
		}
		
		public function set baseBendForce(baseBendForce : Number) : void {
			_baseBendForce = baseBendForce;
			_changed = true;
		}
		
		public function get baseBendOffset() : Number {
			return _baseBendOffset;
		}
		
		public function set baseBendOffset(baseBendOffset : Number) : void {
			_baseBendOffset = baseBendOffset;
			_changed = true;
		}
		
		public function get bendForce() : Number {
			return _bendForce;
		}
		
		public function set bendForce(bendForce : Number) : void {
			_bendForce = bendForce;
			_changed = true;
		}
		
		public function get flipDuration() : Number {
			return _flipDuration;
		}
		
		public function set flipDuration(flipDuration : Number) : void {
			_flipDuration = flipDuration;
		}
		
		public function get flip() : Number {
			return _flip;
		}
		
		public function set flip(flip : Number) : void {
			_flip = flip;
		}

		public function updateBook3D() : void {
			var page3D : Page3D;
			if ( _changed ) {
				managePages3D();
				for each ( page3D in _pages3D )
					page3D.updatePage3D();
			}
			_changed = false; 
		}
	}
}
