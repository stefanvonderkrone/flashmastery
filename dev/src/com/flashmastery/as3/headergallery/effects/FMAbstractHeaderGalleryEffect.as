package com.flashmastery.as3.headergallery.effects {
	import com.flashmastery.as3.display.ExtendedSprite;
	import com.flashmastery.as3.headergallery.interfaces.IHeaderGalleryEffect;
	import com.flashmastery.as3.headergallery.vo.FMHeaderGalleryConfigVO;
	import com.flashmastery.as3.headergallery.vo.FMHeaderGalleryImageVO;
	import com.flashmastery.as3.headergallery.vo.FMHeaderGalleryResourceVO;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMAbstractHeaderGalleryEffect extends ExtendedSprite implements IHeaderGalleryEffect {

		protected var _id : String;		protected var _speed : Number;
		protected var _type : String;
		
		protected var _imageVO : FMHeaderGalleryImageVO;
		
		protected var _imageLoader : Loader;
		protected var _image : Bitmap;

		public function FMAbstractHeaderGalleryEffect( id : String, speed : Number, type : String = "FMAbstractHeaderGalleryEffect" ) {
			super( true );
			_id = id;
			_speed = speed;
			_type = type;
		}

		override public function toString() : String {
			return _type;
		}
		
		public function get id() : String {
			return _id;
		}
		
		public function get type() : String {
			return _type;
		}
		
		public function get speed() : Number {
			return _speed;
		}
		
		public function start() : void {
		}
		
		public function loadImage(imageVO : FMHeaderGalleryImageVO) : void {
			reset();
			_imageVO = imageVO;
			_imageLoader = new Loader( );
			_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderCompleteHandler );			_imageLoader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, loaderStatusHandler );			_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loaderErrorHandler );			_imageLoader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler );
			_imageLoader.load( new URLRequest( imageVO.src ) );
		}

		protected function loaderErrorHandler(evt : Event) : void {
			trace( _type + ": " + evt );
		}

		protected function loaderStatusHandler(evt : HTTPStatusEvent) : void {
			trace( _type + ": " + evt );
		}

		protected function loaderCompleteHandler(evt : Event) : void {
			var configVO : FMHeaderGalleryConfigVO = FMHeaderGalleryResourceVO.getInstance().configVO;
			var bitmapData : BitmapData = new BitmapData( configVO.width, configVO.height, false, 0 );
			var matrix : Matrix = new Matrix( );
			matrix.scale( configVO.width / _imageLoader.content.width, configVO.height / _imageLoader.content.height );
			bitmapData.draw( _imageLoader.content, matrix, null, null, null, true );
			_image = new Bitmap( bitmapData, PixelSnapping.AUTO, configVO.bitmapSmoothing );
		}

		public function reset() : void {
			if ( _imageLoader ) {
				_imageLoader.close();
				_imageLoader.unload();
				_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loaderCompleteHandler );
				_imageLoader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, loaderStatusHandler );
				_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, loaderErrorHandler );
				_imageLoader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, loaderErrorHandler );
				_imageLoader = null;
			}
			if ( _image ) {
				if ( _image.bitmapData ) _image.bitmapData.dispose();
				if ( _image.parent ) _image.parent.removeChild( _image );
				_image = null;
			}
		}
		
		public function clone() : IHeaderGalleryEffect {
			return new FMAbstractHeaderGalleryEffect(id, speed);
		}
	}
}