package com.flashmastery.as3.microsite.patterns.view {
	import de.marcelklammer.as3.collections.HashMap;

	import com.adobe.utils.ArrayUtil;
	import com.flashmastery.as3.microsite.patterns.controller.notifications.FMNotifications;
	import com.flashmastery.as3.microsite.patterns.interfaces.IConfigProxy;
	import com.flashmastery.as3.microsite.patterns.interfaces.IContentMediator;
	import com.flashmastery.as3.microsite.patterns.interfaces.IHistoryProxy;
	import com.flashmastery.as3.microsite.patterns.interfaces.IMicrositeFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMContentMediator extends FMInteractiveMediator implements IContentMediator {
		
		// TODO: Marcels HashMap ausgrenzen
		protected var _buttonTrackingTags : HashMap;
		
		private var _historyProxyName : String;
		private var _notificationList : Array;
		private var _notificationHandler : Dictionary;

		public function FMContentMediator(mediatorName : String = null, viewComponent : Sprite = null, view : Sprite = null) {
			super( mediatorName, viewComponent, view );
			_notificationList = [];
			_notificationHandler = new Dictionary( );
		}

		override public function listNotificationInterests() : Array {
			return _notificationList;
		}

		override public function handleNotification(note : INotification) : void {
			if ( _notificationHandler[ note.getName( ) ] && _notificationHandler[ note.getName( ) ] is Function )
				( _notificationHandler[ note.getName( ) ] as Function )( note );
		}

		override public function dispose() : void {
			super.dispose();
			for ( ; _notificationList.length > 0 ; )
				_notificationList.pop();
			_notificationList = null;
			for ( var handlerName : String in _notificationHandler )
				delete _notificationHandler[ handlerName ];
			_notificationHandler = null;
		}

		protected function changeSection( newSection : String ) : void {
			sendNotification( FMNotifications.CHANGE_SECTION, newSection );
		}

		protected function addNotification( note : String, handler : Function ) : void {
			_notificationList.push( note );
			_notificationHandler[ note ] = handler;
		}

		protected function removeNotification( note : String ) : void {
			ArrayUtil.removeValueFromArray( _notificationList, note );
			delete _notificationHandler[ note ];
		}

		protected function get configProxy() : IConfigProxy {
			return micrositeFacade.configProxy;
		}

		protected function get historyProxy() : IHistoryProxy {
			return facade.retrieveProxy( _historyProxyName ) as IHistoryProxy;
		}
		
		protected function get dataProvider() : Object {
			return configProxy.getDataProviderByMediatorName( getMediatorName() );
		}
		
		protected function set dataProvider( data : Object ) : void {
			configProxy.setDataProviderByMediatorName( getMediatorName(), data );
		}

		protected function get micrositeFacade() : IMicrositeFacade {
			return facade as IMicrositeFacade;
		}

		protected function get notificationList() : Array {
			return _notificationList;
		}
		
		public function get historyProxyName() : String {
			return _historyProxyName;
		}
		
		public function set historyProxyName(historyProxyName : String) : void {
			_historyProxyName = historyProxyName;
		}
	}
}
