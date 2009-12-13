package com.flashmastery.as3.display {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class ExtendedSprite extends Sprite {

		public function ExtendedSprite( autoInit : Boolean = true ) {
			if ( autoInit ) {
				if ( stage ) init();
				else addEventListener( Event.ADDED_TO_STAGE, init );
			}
		}
		
		protected function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			onInit();
		}
		
		protected function onInit() : void {}
		
		public function clearDisplayList() : void {
			for( ; numChildren > 0 ; )
				removeChildAt( 0 );
		}
	}
}
