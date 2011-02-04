package com.flashmastery.as3.display {
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;

	import org.openvideoplayer.events.OvpEvent;
	import org.openvideoplayer.net.OvpNetStream;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.URLRequest;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class VideoPlayer extends ExtendedSprite {
		
		private var _blackPlane : Sprite;
		private var _videoMask : Sprite;
		private var _thumbMask : Sprite;
		private var _thumbPlane : ExtendedSprite;
		private var _video : Video;
		
		private var _bgColor : uint = 0;
		private var _bgAlpha : Number = 1;
		
		private var _scaleMode : String;
		private var _align : String;
		
		private var _netStream : OvpNetStream;
		
		private var _videoWidth : int;
		private var _videoHeight : int;
		private var _videoAspectRatio : Number;
		private var _videoDuration : Number;
		
		private var _thumbLoader : Loader;
		private var _thumb : BitmapData;

		public function VideoPlayer( width : int = 320, height : int = 240 ) {
			super( );
			TweenPlugin.activate( [ AutoAlphaPlugin, TintPlugin ] );
			_blackPlane = getBlackPlane( width, height );
			_videoMask = getBlackPlane( width, height );
			_thumbMask = getBlackPlane( width, height );
			_thumbPlane = new ExtendedSprite();
			_video = new Video( width, height );
			_video.smoothing = true;
			addChild( _blackPlane );
			addChild( _video );
			addChild( _thumbPlane );
			addChild( _videoMask );
			addChild( _thumbMask );
			_video.mask = _videoMask;
			_thumbPlane.mask = _thumbMask;
		}
		
		public function dispose() : void {
			_video.attachNetStream( null );
			clearDisplayList( );
			_scaleMode = "";
			_align = "";
			if ( _netStream )
				_netStream.addEventListener( OvpEvent.NETSTREAM_METADATA, metaDataHandler, false, 0, true );
			_netStream = null;
			if ( _thumb ) {
				try {
					_thumb.dispose();
				} catch ( e : Error ) {}
			}
			if ( _thumbLoader ) {
				_thumbLoader.unload();
				_thumbLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, thumbLoaderHandler );
				_thumbLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, thumbLoaderHandler );
				_thumbLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, thumbLoaderHandler );
			}
			if ( stage ) stage.removeEventListener( Event.RENDER, updateView );
		}

		override protected function init(evt : Event = null) : void {
			super.init( evt );
			updateView();
			stage.addEventListener( Event.RENDER, updateView, false, 0, true );
		}

		private function getBlackPlane( w : int , h : int ) : Sprite {
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill( 0, 1 );
			sprite.graphics.drawRect(0, 0, w, h);
			sprite.graphics.endFill();
			return sprite;
		}
		
		private function metaDataHandler(evt : OvpEvent) : void {
			for( var param : String in evt.data ) {
				switch( param ) {
					case "width":
							_videoWidth = int( evt.data[ param ] );
						break;
					case "height":
							_videoHeight = int( evt.data[ param ] );
						break;
					case "duration":
							_videoDuration = Number( evt.data[ param ] );
						break;
				}
			}
			if ( _videoWidth && _videoHeight ) _videoAspectRatio = _videoWidth / _videoHeight;
			_netStream.removeEventListener( OvpEvent.NETSTREAM_METADATA, metaDataHandler );
			invalidate();
		}
		
		public function setMetaData( videoWidth : int, videoHeight : int, videoDuration : Number ) : void {
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_videoDuration = videoDuration;
			_videoAspectRatio = _videoWidth / _videoHeight;
			if ( _netStream ) _netStream.removeEventListener( OvpEvent.NETSTREAM_METADATA, metaDataHandler );
			invalidate();
		}

		private function thumbLoaderHandler(evt : Event) : void {
			switch( evt.type ) {
				case Event.COMPLETE:
						var thumb : DisplayObject = _thumbLoader.content;
						if ( thumb ) {
							_thumb = new BitmapData(thumb.width, thumb.height, true, 0);
							_thumb.draw( thumb );
							_thumbLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, thumbLoaderHandler );
							_thumbLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, thumbLoaderHandler );
							_thumbLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, thumbLoaderHandler );
							_thumbLoader.unload();
							setThumbnail( _thumb );
						}
					break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
						trace( evt );
					break;
			}
		}
		
		public function forceUpdateView() : void {
			updateView();
		}

		protected function updateView( evt : Event = null ) : void {
//			trace( "VideoSprite ( \"" + name + "\" ) - updateVideo" );
			if ( _scaleMode == null ) _scaleMode = VideoPlayerScaleMode.EXACT_FIT;
			if ( _align == null ) _align = VideoPlayerAlign.CENTER;
			if ( isNaN( _videoAspectRatio ) ) _videoAspectRatio = _video.videoWidth / _video.videoHeight;
			var _bgAspectRatio : Number = _blackPlane.width / _blackPlane.height;
//			trace( _scaleMode );
			if ( _scaleMode == VideoPlayerScaleMode.CROPPED ) {
				if ( _bgAspectRatio >= _videoAspectRatio ) {
					_video.width = _thumbPlane.width = _blackPlane.width;
//					_video.scaleY = _video.scaleX;
					_video.height = _video.width / _videoAspectRatio;
					_thumbPlane.height = _video.height;
				}
				else {
					_video.height = _thumbPlane.height = _blackPlane.height;
//					_video.scaleX = _video.scaleY;
					_video.width = _video.height * _videoAspectRatio;
					_thumbPlane.width = _video.width;
				}
			}
			else if ( _scaleMode == VideoPlayerScaleMode.DISTORTED ) {
				_video.width = _thumbPlane.width = _blackPlane.width;
				_video.height = _thumbPlane.height = _blackPlane.height;
			}
			else if ( _scaleMode == VideoPlayerScaleMode.EXACT_FIT ) {
				if ( _bgAspectRatio <= _videoAspectRatio ) {
//					trace( "_bgAspectRatio <= _videoAspectRatio" );
					_video.width = _thumbPlane.width = _blackPlane.width;
//					_video.scaleY = _video.scaleX;
					_video.height = _video.width / _videoAspectRatio;
					_thumbPlane.height = _video.height;
				}
				else {
//					trace( "_bgAspectRatio > _videoAspectRatio" );
					_video.height = _thumbPlane.height = _blackPlane.height;
//					_video.scaleX = _video.scaleY;
					_video.width = _video.height * _videoAspectRatio;
//					trace( _videoAspectRatio + " - " + ( _video.height * _videoAspectRatio ) );
					_thumbPlane.width = _video.width;
				}
			}
			else if ( _scaleMode == VideoPlayerScaleMode.NO_SCALE ) {
				_video.width = _thumbPlane.width = _videoWidth;
				_video.height = _thumbPlane.height = _videoHeight;
			}
			switch( _align ) {
				case VideoPlayerAlign.BOTTOM:
						_video.x = Math.ceil( ( _blackPlane.width - _video.width ) / 2 );
						_video.y = Math.ceil( _blackPlane.height - _video.height );
						_thumbPlane.x = Math.ceil( ( _blackPlane.width - _thumbPlane.width ) / 2 );
						_thumbPlane.y = Math.ceil( _blackPlane.height - _thumbPlane.height );
					break;
				case VideoPlayerAlign.BOTTOM_LEFT:
						_video.x = 0;
						_video.y = Math.ceil( _blackPlane.height - _video.height );
						_thumbPlane.x = 0;
						_thumbPlane.y = Math.ceil( _blackPlane.height - _thumbPlane.height );
					break;
				case VideoPlayerAlign.BOTTOM_RIGHT:
						_video.x = Math.ceil( _blackPlane.width - _video.width );
						_video.y = Math.ceil( _blackPlane.height - _video.height );
						_thumbPlane.x = Math.ceil( _blackPlane.width - _thumbPlane.width );
						_thumbPlane.y = Math.ceil( _blackPlane.height - _thumbPlane.height );
					break;
				case VideoPlayerAlign.CENTER:
						_video.x = Math.round( ( _blackPlane.width - _video.width ) / 2 );
						_video.y = Math.round( ( _blackPlane.height - _video.height ) / 2 );
						_thumbPlane.x = Math.round( ( _blackPlane.width - _thumbPlane.width ) / 2 );
						_thumbPlane.y = Math.round( ( _blackPlane.height - _thumbPlane.height ) / 2 );
					break;
				case VideoPlayerAlign.LEFT:
						_video.x = 0;
						_video.y = Math.ceil( ( _blackPlane.height - _video.height ) / 2 );
						_thumbPlane.x = 0;
						_thumbPlane.y = Math.ceil( ( _blackPlane.height - _thumbPlane.height ) / 2 );
					break;
				case VideoPlayerAlign.RIGHT:
						_video.x = Math.ceil( _blackPlane.width - _video.width );
						_video.y = Math.ceil( ( _blackPlane.height - _video.height ) / 2 );
						_thumbPlane.x = Math.ceil( _blackPlane.width - _thumbPlane.width );
						_thumbPlane.y = Math.ceil( ( _blackPlane.height - _thumbPlane.height ) / 2 );
					break;
				case VideoPlayerAlign.TOP:
						_video.x = Math.ceil( ( _blackPlane.width - _video.width ) / 2 );
						_video.y = 0;
						_thumbPlane.x = Math.ceil( ( _blackPlane.width - _thumbPlane.width ) / 2 );
						_thumbPlane.y = 0;
					break;
				case VideoPlayerAlign.TOP_LEFT:
						_video.x = 0;
						_video.y = 0;
						_thumbPlane.x = 0;
						_thumbPlane.y = 0;
					break;
				case VideoPlayerAlign.TOP_RIGHT:
						_video.x = Math.ceil( _blackPlane.width - _video.width );
						_video.y = 0;
						_thumbPlane.x = Math.ceil( _blackPlane.width - _thumbPlane.width );
						_thumbPlane.y = 0;
					break;
			}
		}
		
		protected function invalidate() : void {
			if ( stage ) stage.invalidate();
		}
		
		public function hideThumbnail( delay : Number = 0, time : Number = 0.5 ) : Number {
			TweenLite.to( _thumbPlane, time, { autoAlpha: 0, delay: delay } );
			return time + delay;
		}
		
		public function showThumbnail( delay : Number = 0, time : Number = 0.5 ) : Number {
//			trace( "showThumbnail - " + _thumbPlane.numChildren );
			TweenLite.to( _thumbPlane, time, { autoAlpha: 1, delay: delay } );
			return time + delay;
		}

		public function loadThumbnail( url : String ) : void {
			_thumbLoader = new Loader();
			_thumbLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, thumbLoaderHandler, false, 0, true );
			_thumbLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, thumbLoaderHandler, false, 0, true );
			_thumbLoader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, thumbLoaderHandler, false, 0, true );
			_thumbLoader.load( new URLRequest( url ) );
		}

		public function setThumbnail( bitmapData : BitmapData ) : void {
//			trace( "setThumbnail" );
			_thumbPlane.clearDisplayList();
			_thumb = bitmapData;
			_thumbPlane.addChild( new Bitmap( bitmapData, PixelSnapping.AUTO, true ) );
			invalidate();
		}
		
		public function setCurrentFrameAsThumbnail() : void {
			var bitmapData : BitmapData = new BitmapData( _video.width, _video.height, true, 0 );
			bitmapData.draw( _video );
			setThumbnail(bitmapData);
		}

		public function resetThumbnail() : void {
			if ( _thumb != null ) setThumbnail( _thumb );
		}

		public function get scaleMode() : String {
			return _scaleMode;
		}
		
		public function set scaleMode(scaleMode : String) : void {
			_scaleMode = scaleMode;
			invalidate( );
		}

		public function get align() : String {
			return _align;
		}
		
		public function set align(align : String) : void {
			_align = align;
			invalidate();
		}
		
		public function get netStream() : OvpNetStream {
			return _netStream;
		}
		
		public function set netStream(netStream : OvpNetStream) : void {
			if ( _netStream != null ) _netStream.removeEventListener( OvpEvent.NETSTREAM_METADATA, metaDataHandler );
			_netStream = netStream;
			if ( _netStream ) {
				_netStream.addEventListener( OvpEvent.NETSTREAM_METADATA, metaDataHandler, false, 0, true );
				_video.attachNetStream( _netStream );
			}
		}

		override public function get width() : Number {
			return _blackPlane.width;
		}

		override public function set width(value : Number) : void {
			_blackPlane.width = _videoMask.width = _thumbMask.width = value;
			invalidate();
		}

		override public function get height() : Number {
			return _blackPlane.height;
		}

		override public function set height(value : Number) : void {
			_blackPlane.height = _videoMask.height = _thumbMask.height = value;
			invalidate();
		}

		override public function get scaleX() : Number {
			return _blackPlane.scaleX;
		}

		override public function set scaleX(value : Number) : void {
			_blackPlane.scaleX = _videoMask.scaleX = _thumbMask.scaleX = value;
			invalidate();
		}

		override public function get scaleY() : Number {
			return _blackPlane.scaleY;
		}

		override public function set scaleY(value : Number) : void {
			_blackPlane.scaleY = _videoMask.scaleY = _thumbMask.scaleY = value;
			invalidate();
		}
		
		public function get videoWidth() : int {
			return _videoWidth;
		}
		
		public function get videoHeight() : int {
			return _videoHeight;
		}
		
		public function get videoDuration() : Number {
			return _videoDuration;
		}
		
		public function get videoAspectRatio() : int {
			return _videoAspectRatio;
		}
		
		public function get bgColor() : uint {
			return _bgColor;
		}
		
		public function set bgColor(bgColor : uint) : void {
			_bgColor = bgColor;
			TweenLite.to( _blackPlane, 0, { tint: bgColor } );
		}
		
		public function get bgAlpha() : Number {
			return _bgAlpha;
		}
		
		public function set bgAlpha(bgAlpha : Number) : void {
			_bgAlpha = bgAlpha;
			_blackPlane.alpha = bgAlpha;
		}
	}
}
