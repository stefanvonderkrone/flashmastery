package com.flashmastery.as3.blitting.resources {
	import flash.display.BitmapData;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class ResourceManager extends Object {
		
		private static var _keyList : Vector.<String>;
		private static var _spriteSheetList : Vector.<BitmapData>;
		private static var _jsonList : Vector.<Object>;
		
		public static function init() : void {
			_keyList = new Vector.<String>();
			_spriteSheetList = new Vector.<BitmapData>();
			_jsonList = new Vector.<Object>();
		}
		
		public static function addSpriteSheet( key : String, spriteSheet : BitmapData, json : Object ) : void {
			if ( _keyList && _spriteSheetList && _jsonList ) {
				const index : int = _keyList.indexOf( key );
				if ( index == -1 ) {
					_keyList.push( key );
					_spriteSheetList.push( spriteSheet );
					_jsonList.push( json );
				} else {
					_keyList[ index ] = key;
					_spriteSheetList[ index ] = spriteSheet;
					_jsonList[ index ] = json;
				}
			}
		}
		
		public static function getSpriteSheetByKey( key : String ) : BitmapData {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _spriteSheetList[ index ];
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
			_spriteSheetList.length = 0;
			_spriteSheetList = null;
			_jsonList.length = 0;
			_jsonList = null;
		}
	}
}
