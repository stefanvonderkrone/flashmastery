package com.flashmastery.as3.paper3d.patterns.facade {
	import com.flashmastery.as3.paper3d.patterns.controller.notifications.FMPaper3DNotificationList;
	import com.flashmastery.as3.paper3d.patterns.controller.startup.FMPaper3DStartupCommand;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import flash.display.DisplayObject;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPaper3DFacade extends Facade {
		
		public static function getInstance( key : String ) : FMPaper3DFacade {
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new FMPaper3DFacade( key );
			return instanceMap[ key ];
		}

		public function FMPaper3DFacade(key : String) {
			super( key );
		}

		override protected function initializeController() : void {
			super.initializeController( );
			registerCommand( FMPaper3DNotificationList.STARTUP , FMPaper3DStartupCommand);
		}

		public function startup( view : DisplayObject ) : void {
			sendNotification( FMPaper3DNotificationList.STARTUP, view );
		}
	}
}
