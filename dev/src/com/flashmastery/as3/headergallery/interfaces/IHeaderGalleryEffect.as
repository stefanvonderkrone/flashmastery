package com.flashmastery.as3.headergallery.interfaces {
	import com.flashmastery.as3.headergallery.vo.FMHeaderGalleryImageVO;

	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public interface IHeaderGalleryEffect extends IEventDispatcher, IBitmapDrawable {
		
		function get id() : String;		
		function get type() : String;
		
		function get speed() : Number;
		
		function toString() : String;
		
		function loadImage( imageVO : FMHeaderGalleryImageVO ) : void;
		
		function start() : void;
		
		function reset() : void;
		
		function clone() : IHeaderGalleryEffect;
		
	}
}
