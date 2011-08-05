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
		protected var _isPlaying : Boolean = false;
		protected var _autoUpdate : Boolean = true;
		protected var _spriteSheet : SpriteSheet;
		protected var _resourceKey : String;
		protected var _currentPhase : String;
		protected var _currentPhaseIndices : Vector.<int>;
		protected var _defaultPhase : String;
		protected var _currentFrame : uint;

		public function FramedSpriteSheet() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
			_phases = new Dictionary();
			_spriteSheet = addChild( new SpriteSheet() );
			_currentFrame = 0;
		}
		
		public function useResouceByKey( key : String ) : void {
			if ( key != _resourceKey ) {
				_spriteSheetList = ResourceManager.getSpriteSheetByKey( key );
				_trimmedList = ResourceManager.getTrimmedByKey( key );
				_sourceSizeList = ResourceManager.getSourceSizesByKey( key );
				_sourceRectList = ResourceManager.getSourceRectsByKey( key );
				_currentPhase = null;
				if ( _spriteSheet ) {
					_spriteSheet.bitmapData = null;
					_spriteSheet.x = 0;
					_spriteSheet.y = 0;
				}
			}
		}
		
		public function addPhase( name : String, indices : Vector.<int> ) : void {
			_phases[ name ] = indices;
			if ( _defaultPhase == null ) _defaultPhase = name;
		}

		public function usePhase( currentPhase : String ) : void {
			_currentPhase = currentPhase;
			_currentPhaseIndices = _phases[ _currentPhase ];
			if ( _currentPhaseIndices == null && _defaultPhase )
				_currentPhaseIndices = _phases[ _defaultPhase ];
			_currentFrame = 1;
		}
		
		override public function updateForRender() : void {
			
		}
		
		public function nextFrame() : void {
			
		}
		
		public function prevFrame() : void {
			
		}
		
		public function gotoAndPlay( frame : int ) : void {
			_isPlaying = true;
		}
		
		public function gotoAndStop( frame : int ) : void {
			_isPlaying = false;
		}
		
		public function play() : void {
			_isPlaying = true;
		}
		
		public function stop() : void {
			_isPlaying = false;
		}
		
		public function get totalFrames() : int {
			if ( _currentPhaseIndices )
				return _currentPhaseIndices.length;
			return 0;
		}

		public function get currentFrame() : uint {
			return _currentPhaseIndices ? _currentFrame : 0;
		}

		public function get resourceKey() : String {
			return _resourceKey;
		}

		public function get currentPhase() : String {
			return _currentPhase;
		}

		public function get defaultPhase() : String {
			return _defaultPhase;
		}

		public function set defaultPhase( defaultPhase : String ) : void {
			_defaultPhase = defaultPhase;
		}
	}
}
