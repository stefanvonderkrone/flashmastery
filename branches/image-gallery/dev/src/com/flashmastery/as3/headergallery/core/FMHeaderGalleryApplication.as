package com.flashmastery.as3.headergallery.core {
	import com.flashmastery.as3.display.RootSprite;
	import com.flashmastery.as3.interfaces.IApplication;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMHeaderGalleryApplication extends RootSprite implements IApplication {

		public function FMHeaderGalleryApplication() {
			super( );
		}
		
		public function start() : void {
			trace( "Application started" );
		}
	}
}
