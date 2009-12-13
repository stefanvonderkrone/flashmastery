package com.flashmastery.as3.paper3d.core {
	import com.flashmastery.as3.display.RootSprite;
	import com.flashmastery.as3.interfaces.IApplication;
	import com.flashmastery.as3.paper3d.assets.Paper3DGradiantBG;
	import com.flashmastery.as3.paper3d.patterns.controller.notifications.FMPaper3DNotificationList;
	import com.flashmastery.as3.paper3d.patterns.facade.FMPaper3DFacade;

	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPaper3DApplication extends RootSprite implements IApplication {

		private var _bg : Paper3DGradiantBG;
		private var _facade : FMPaper3DFacade;

		public function FMPaper3DApplication() {
			super( );
		}

		override protected function init(evt : Event = null) : void {
			super.init( evt );
			lockStage();
			_bg = addChild( new Paper3DGradiantBG() ) as Paper3DGradiantBG;
			stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		private function resizeHandler( evt : Event = null ) : void {
			if ( _facade )
				_facade.sendNotification( FMPaper3DNotificationList.STAGE_RESIZE, stage );
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
		}

		public function start() : void {
			trace( "Application started" );
			_facade = FMPaper3DFacade.getInstance( "paper3D" );
			_facade.startup( this );
		}
	}
}
