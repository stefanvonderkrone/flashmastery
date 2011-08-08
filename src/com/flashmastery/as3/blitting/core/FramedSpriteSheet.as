package com.flashmastery.as3.blitting.core {
	import com.flashmastery.as3.blitting.resources.ResourceManager;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class FramedSpriteSheet extends SpriteSheetContainer {
		
		protected var _spriteSheetList : Vector.<BitmapData>;
		protected var _trimmedList : Vector.<Boolean>;
		protected var _sourceSizeList : Vector.<Point>;
		protected var _sourceRectList : Vector.<Rectangle>;
		protected var _phases : Dictionary;
		protected var _isPlaying : Boolean;
		protected var _autoUpdate : Boolean;
		protected var _spriteSheet : SpriteSheet;
		protected var _resourceKey : String;
		protected var _defaultPhase : String;
		protected var _currentPhaseName : String;
		protected var _currentPhase : Vector.<int>;
		protected var _currentFrame : uint;
		protected var _updateIntervalFrames : uint;
		protected var _updateFrame : uint;

		public function FramedSpriteSheet() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
			_phases = new Dictionary();
			_spriteSheet = addChild( new SpriteSheet() );
			_currentFrame = 0;
			_updateFrame = 0;
			_updateIntervalFrames = 1;
			_isPlaying = true;
			_autoUpdate = true;
			_defaultPhase = "";
		}

		protected function updateSpriteSheet() : void {
			_spriteSheet.bitmapData = _spriteSheetList[ _currentPhase[ _currentFrame - 1 ] ];
			const rect : Rectangle = _sourceRectList[ _currentPhase[ _currentFrame - 1 ] ];
			_spriteSheet.x = rect.x;
			_spriteSheet.y = rect.y;
		}
		
		public function useResouceByKey( key : String ) : void {
			if ( key != _resourceKey && ResourceManager.hasResourceByKey( key ) ) {
				_spriteSheetList = ResourceManager.getSpriteSheetByKey( key );
				_trimmedList = ResourceManager.getTrimmedByKey( key );
				_sourceSizeList = ResourceManager.getSourceSizesByKey( key );
				_sourceRectList = ResourceManager.getSourceRectsByKey( key );
				if ( _spriteSheet ) {
					_spriteSheet.bitmapData = null;
					_spriteSheet.x = 0;
					_spriteSheet.y = 0;
				}
				_currentPhase = new Vector.<int>( _spriteSheetList.length, true );
				const length : int = _spriteSheetList.length;
				for ( var i : int = 0; i < length; i++ )
					_currentPhase[ int( i ) ] = i;
				_currentPhaseName = "";
				_currentFrame = 1;
				_phases[ "" ] = _currentPhase;
				_autoUpdate = false;
				updateSpriteSheet();
			}
		}
		
		public function addPhase( name : String, indicesAsArrayOrVector : Object ) : void {
			_phases[ name ] = Vector.<int>( indicesAsArrayOrVector );
		}

		public function usePhase( phaseName : String ) : void {
			_currentPhaseName = phaseName;
			_currentPhase = _phases[ _currentPhaseName ];
			if ( _currentPhase == null && _defaultPhase )
				_currentPhase = _phases[ _defaultPhase ];
			_currentFrame = 1;
		}
		
		override public function updateForRender() : void {
			_updateFrame++;
			if ( _autoUpdate && _isPlaying && _updateFrame >= _updateIntervalFrames ) {
				_currentFrame == _currentPhase.length ? _currentFrame = 1 : _currentFrame++;
				_updateFrame = 0;
				updateSpriteSheet();
			}
			_autoUpdate = true;
		}
		
		public function nextFrame() : void {
			_autoUpdate = false;
			_currentFrame == _currentPhase.length ? _currentFrame == 1 : _currentFrame++;
		}
		
		public function prevFrame() : void {
			_autoUpdate = false;
			_currentFrame == 1 ? _currentFrame == _currentPhase.length : _currentFrame--;
		}
		
		public function gotoAndPlay( frame : int ) : void {
			_autoUpdate = false;
			_isPlaying = true;
			_currentFrame = ( frame <= _currentPhase.length && frame > 0 ) ? frame : 1;
		}
		
		public function gotoAndStop( frame : int ) : void {
			_autoUpdate = false;
			_isPlaying = false;
			_currentFrame = ( frame <= _currentPhase.length && frame > 0 ) ? frame : 1;
		}
		
		public function play() : void {
			_isPlaying = true;
		}
		
		public function stop() : void {
			_isPlaying = false;
		}
		
		public function get totalFrames() : int {
			if ( _currentPhase )
				return _currentPhase.length;
			return 0;
		}

		public function get currentFrame() : uint {
			return _currentPhase ? _currentFrame : 0;
		}

		public function get resourceKey() : String {
			return _resourceKey;
		}

		public function get currentPhaseName() : String {
			return _currentPhaseName;
		}

		public function get defaultPhase() : String {
			return _defaultPhase;
		}

		public function set defaultPhase( defaultPhase : String ) : void {
			_defaultPhase = defaultPhase;
		}

		public function get updateIntervalFrames() : uint {
			return _updateIntervalFrames;
		}

		public function set updateIntervalFrames( updateIntervalFrames : uint ) : void {
			_updateIntervalFrames = Math.max( 1, updateIntervalFrames );
		}
	}
}
