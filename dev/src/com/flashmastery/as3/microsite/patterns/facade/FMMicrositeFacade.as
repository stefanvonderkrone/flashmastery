package com.flashmastery.as3.microsite.patterns.facade {
	import com.flashmastery.as3.microsite.FMMicrositeFramework;
	import com.flashmastery.as3.microsite.interfaces.IStartupConfiguration;
	import com.flashmastery.as3.microsite.patterns.controller.notifications.FMNotifications;
	import com.flashmastery.as3.microsite.patterns.controller.startup.FMInitializeModelCommand;
	import com.flashmastery.as3.microsite.patterns.controller.startup.FMInitializeViewCommand;
	import com.flashmastery.as3.microsite.patterns.interfaces.IConfigProxy;
	import com.flashmastery.as3.microsite.patterns.interfaces.IMicrositeFacade;
	import com.flashmastery.as3.microsite.patterns.model.FMConfigProxy;
	import com.flashmastery.as3.microsite.patterns.model.FMHistoryProxy;
	import com.flashmastery.as3.microsite.patterns.view.FMMainMediator;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMMicrositeFacade extends Facade implements IMicrositeFacade {

		protected static var _initializeModelCommand : Class = FMInitializeModelCommand;
		protected static var _initializeViewCommand : Class = FMInitializeViewCommand;
		
		protected var _mainMediatorClass : Class;// = FMMainMediator;
		protected var _configProxyClass : Class;// = FMConfigProxy;
		protected var _historyProxyClass : Class;// = FMHistoryProxy;
		protected var _shutDownCommand : Class;
		protected var _startupCommand : Class;
		
		protected var _configProxy : IConfigProxy;

		public static function getInstance(
				key : String,
				startupCommand : Class,
				shutDownCommand : Class,
				mainMediatorClass : Class = null,
				configProxyClass : Class = null,
				historyProxyClass : Class = null ) : IMicrositeFacade {
			if ( instanceMap[ key ] == null )
				instanceMap[ key ] = new FMMicrositeFacade( key, startupCommand, shutDownCommand, mainMediatorClass, configProxyClass, historyProxyClass );
			return instanceMap[ key ];
		}

		public function FMMicrositeFacade(
				key : String,
				startupCommand : Class,
				shutDownCommand : Class,
				mainMediatorClass : Class = null,
				configProxyClass : Class = null,
				historyProxyClass : Class = null ) {
			_startupCommand = startupCommand;
			_shutDownCommand = shutDownCommand;
			_mainMediatorClass = mainMediatorClass == null ? FMMainMediator : mainMediatorClass;
			_configProxyClass = configProxyClass == null ? FMConfigProxy : configProxyClass;
			_historyProxyClass = historyProxyClass == null ? FMHistoryProxy : historyProxyClass;
			super( key );
			trace( "<<<---------->>>" );
			trace( FMMicrositeFramework.getVersion() );
			trace( "Based on PureMVC Multicore (http://puremvc.org/)" );
			trace( "<<<---------->>>" );
		}

		override protected function initializeController() : void {
			super.initializeController( );
			registerCommand( FMNotifications.START_UP , startupCommand );			registerCommand( FMNotifications.SHUT_DOWN , shutDownCommand );
		}

		public function startup(startupConfig : IStartupConfiguration) : void {
			sendNotification( FMNotifications.START_UP, startupConfig );
		}
		
		public function get shutDownCommand() : Class {
			return _shutDownCommand;
		}
		
		public function get startupCommand() : Class {
			return _startupCommand;
		}
		
		public function get configProxy() : IConfigProxy {
			return _configProxy;
		}
		
		public function get mainMediatorClass() : Class {
			return _mainMediatorClass;
		}
		
		public function get configProxyClass() : Class {
			return _configProxyClass;
		}
		
		public function get historyProxyClass() : Class {
			return _historyProxyClass;
		}
		
		public function set configProxy(newConfigProxy : IConfigProxy) : void {
			if ( _configProxy && _configProxy != newConfigProxy ) {
				removeProxy( _configProxy.getProxyName() );
				registerProxy( newConfigProxy );
				_configProxy = newConfigProxy;
			} else if ( !_configProxy ) {
				registerProxy( newConfigProxy );
				_configProxy = newConfigProxy;
			}
		}
		
//		public function set historyProxy(newHistoryProxy : IHistoryProxy) : void {
//			if ( _historyProxy && _historyProxy != newHistoryProxy ) {
//				removeProxy( _historyProxy.getProxyName() );
//				registerProxy( newHistoryProxy );
//				_historyProxy = newHistoryProxy;
//			} else if ( !_historyProxy ) {
//				registerProxy( newHistoryProxy );
//				_historyProxy = newHistoryProxy;
//			}
//		}
		
		public function dispose() : void {
			// XXX: Testing
			removeProxy( _configProxy.getProxyName() );
			_configProxy = null;
			_mainMediatorClass = null;
			_configProxyClass = null;
			_historyProxyClass = null;
			removeCore( multitonKey );
		}

		public static function get initializeModelCommand() : Class {
			return _initializeModelCommand;
		}
		
		public static function set initializeModelCommand(initializeModelCommand : Class) : void {
			_initializeModelCommand = initializeModelCommand;
		}
		
		public static function get initializeViewCommand() : Class {
			return _initializeViewCommand;
		}
		
		public static function set initializeViewCommand(initializeViewCommand : Class) : void {
			_initializeViewCommand = initializeViewCommand;
		}
	}
}
