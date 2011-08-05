package com.flashmastery.as3.blitting.resources {
	import flash.display.BitmapData;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class ResourceManager extends Object {
		
		private static var _keyList : Vector.<String>;
		private static var _bitmapList : Vector.<BitmapData>;
		private static var _spriteSheetList : Vector.<Vector.<BitmapData>>;
		private static var _jsonList : Vector.<Object>;
		
		public static function init() : void {
			_keyList = new Vector.<String>();
			_bitmapList = new Vector.<BitmapData>();
			_spriteSheetList = new Vector.<Vector.<BitmapData>>();
			_jsonList = new Vector.<Object>();
		}
		
		public static function addSpriteSheet( key : String, spriteSheet : BitmapData, json : Object ) : void {
			if ( _keyList && _bitmapList && _jsonList ) {
				const index : int = _keyList.indexOf( key );
				if ( index == -1 ) {
					_keyList.push( key );
					_bitmapList.push( spriteSheet );
					_spriteSheetList.push( getSpriteSheets( json, spriteSheet ) );
					_jsonList.push( json );
				} else {
					_keyList[ index ] = key;
					_bitmapList[ index ] = spriteSheet;
					_spriteSheetList[ index ] = getSpriteSheets( json, spriteSheet );
					_jsonList[ index ] = json;
				}
			}
		}

		private static function getSpriteSheets( json : Object, spriteSheet : BitmapData ) : Vector.<BitmapData> {
			if ( json && spriteSheet ) {
				
			}
			return null;
		}
		
		public static function getSpriteSheetByKey( key : String ) : BitmapData {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _bitmapList[ index ];
			return null;
		}
		
		public static function getJSONByKey( key : String ) : Object {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _jsonList[ index ];
			return null;
		}
		
		public static function clear() : void {
			_keyList.length = 0;
			_keyList = null;
			_bitmapList.length = 0;
			_bitmapList = null;
			_jsonList.length = 0;
			_jsonList = null;
		}
	}
}
