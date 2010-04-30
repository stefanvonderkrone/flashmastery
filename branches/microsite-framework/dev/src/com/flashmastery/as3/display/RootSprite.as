package com.flashmastery.as3.display {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class RootSprite extends ExtendedSprite {

		public function RootSprite() {
			super( false );
			if ( stage && stage.stageWidth > 0 && stage.stageHeight > 0 ) init( );
			else addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		
		private function enterFrameHandler( evt : Event ) : void {
			if ( stage && stage.stageWidth > 0 && stage.stageHeight > 0 ) init( );
		}

		override protected function init( evt : Event = null ) : void {
			removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			onInit();
		}
		
		protected function lockStage() : void {
			if ( stage != null ) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
		}
	}
}
