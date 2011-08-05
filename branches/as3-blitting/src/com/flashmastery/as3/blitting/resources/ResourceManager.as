package com.flashmastery.as3.blitting.resources {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class ResourceManager extends Object {
		
		private static var _keyList : Vector.<String>;
//		private static var _bitmapList : Vector.<BitmapData>;
		private static var _spriteSheetList : Vector.<Vector.<BitmapData>>;
		private static var _trimmedList : Vector.<Vector.<Boolean>>;
		private static var _sourceSizeList : Vector.<Vector.<Point>>;
		private static var _sourceRectList : Vector.<Vector.<Rectangle>>;
		private static var _jsonList : Vector.<Object>;
		private static var _copyRect : Rectangle;
		private static var _copyPoint : Point;
		private static var _initialized : Boolean = false;
		
		public static function init() : void {
			_keyList = new Vector.<String>();
//			_bitmapList = new Vector.<BitmapData>();
			_spriteSheetList = new Vector.<Vector.<BitmapData>>();
			_jsonList = new Vector.<Object>();
			_trimmedList = new Vector.<Vector.<Boolean>>();
			_sourceRectList = new Vector.<Vector.<Rectangle>>();
			_sourceSizeList = new Vector.<Vector.<Point>>();
			_copyPoint = new Point();
			_copyRect = new Rectangle();
			_initialized = true;
		}
		
		public static function addSpriteSheet( key : String, spriteSheet : BitmapData, json : Object ) : void {
			if ( _initialized ) {
				const index : int = _keyList.indexOf( key );
				if ( index == -1 ) {
					_keyList.push( key );
//					_bitmapList.push( spriteSheet );
					_spriteSheetList.push( getSpriteSheets( json, spriteSheet ) );
					_trimmedList.push( getTrimmed( json ) );
					_sourceRectList.push( getSourceRects( json ) );
					_sourceSizeList.push( getSourceSizes( json ) );
					_jsonList.push( json );
				} else {
					_keyList[ index ] = key;
//					_bitmapList[ index ] = spriteSheet;
					_spriteSheetList[ index ] = getSpriteSheets( json, spriteSheet );
					_trimmedList[ index ] = getTrimmed( json );
					_sourceRectList[ index ] = getSourceRects( json );
					_sourceSizeList[ index ] = getSourceSizes( json );
					_jsonList[ index ] = json;
				}
			}
		}

		private static function getSourceSizes( json : Object ) : Vector.<Point> {
			if ( json ) {
				const length : int = json.frames ? json.frames.length : 0;
				var jsonItem : Object;
				var size : Point;
				var sourceSizeList : Vector.<Point> = new Vector.<Point>();
				sourceSizeList.length = length;
				sourceSizeList.fixed = true;
				for ( var i : int = 0; i < length; i++ ) {
					jsonItem = json.frames[ int( i ) ];
					size = new Point();
					size.x = jsonItem.sourceSize.w;
					size.y = jsonItem.sourceSize.h;
					sourceSizeList[ int( i ) ] = size;
				}
				return sourceSizeList;
			}
			return null;
		}

		private static function getSourceRects( json : Object ) : Vector.<Rectangle> {
			if ( json ) {
				const length : int = json.frames ? json.frames.length : 0;
				var jsonItem : Object;
				var rect : Rectangle;
				var sourceRectList : Vector.<Rectangle> = new Vector.<Rectangle>();
				sourceRectList.length = length;
				sourceRectList.fixed = true;
				for ( var i : int = 0; i < length; i++ ) {
					jsonItem = json.frames[ int( i ) ];
					rect = new Rectangle();
					rect.x = jsonItem.spriteSourceSize.x;
					rect.y = jsonItem.spriteSourceSize.y;
					rect.width = jsonItem.spriteSourceSize.w;
					rect.height = jsonItem.spriteSourceSize.h;
					sourceRectList[ int( i ) ] = rect;
				}
				return sourceRectList;
			}
			return null;
		}

		private static function getTrimmed( json : Object ) : Vector.<Boolean> {
			if ( json ) {
				const length : int = json.frames ? json.frames.length : 0;
				var jsonItem : Object;
				var trimmedList : Vector.<Boolean> = new Vector.<Boolean>();
				trimmedList.length = length;
				trimmedList.fixed = true;
				for ( var i : int = 0; i < length; i++ ) {
					jsonItem = json.frames[ int( i ) ];
					trimmedList[ int( i ) ] = jsonItem.trimmed;
				}
				return trimmedList;
			}
			return null;
		}

		private static function getSpriteSheets( json : Object, spriteSheet : BitmapData ) : Vector.<BitmapData> {
			if ( json && spriteSheet ) {
				const length : int = json.frames ? json.frames.length : 0;
				var bitmapData : BitmapData;
				var jsonItem : Object;
				var spriteSheets : Vector.<BitmapData> = new Vector.<BitmapData>();
				spriteSheets.length = length;
				spriteSheets.fixed = true;
				for ( var i : int = 0; i < length; i++ ) {
					jsonItem = json.frames[ int( i ) ];
					bitmapData = new BitmapData( jsonItem.frame.w, jsonItem.frame.h, spriteSheet.transparent, 0x00000000 );
					_copyRect.x = jsonItem.frame.x;
					_copyRect.y = jsonItem.frame.y;
					_copyRect.width = jsonItem.frame.w;
					_copyRect.height = jsonItem.frame.h;
					bitmapData.copyPixels( spriteSheet, _copyRect, _copyPoint );
					spriteSheets[ int( i ) ] = bitmapData;
				}
				return spriteSheets;
			}
			return null;
		}
		
		public static function getSpriteSheetByKey( key : String ) : Vector.<BitmapData> {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _spriteSheetList[ index ];
			return null;
		}
		
		public static function getTrimmedByKey( key : String ) : Vector.<Boolean> {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _trimmedList[ index ];
			return null;
		}
		
		public static function getSourceRectsByKey( key : String ) : Vector.<Rectangle> {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _sourceRectList[ index ];
			return null;
		}
		
		public static function getSourceSizesByKey( key : String ) : Vector.<Point> {
			const index : int = _keyList.indexOf( key );
			if ( index > -1 )
				return _sourceSizeList[ index ];
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
//			_bitmapList.length = 0;
//			_bitmapList = null;
			_jsonList.length = 0;
			_jsonList = null;
			_trimmedList.length = 0;
			_trimmedList = null;
			_spriteSheetList.length = 0;
			_spriteSheetList = null;
			_sourceRectList.length = 0;
			_sourceRectList = null;
			_sourceSizeList.length = 0;
			_sourceSizeList = null;
			_initialized = false;
		}
	}
}
