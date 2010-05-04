package com.flashmastery.as3.microsite.patterns.view {
	import com.flashmastery.as3.microsite.patterns.controller.notifications.FMNotifications;
	import com.flashmastery.as3.microsite.patterns.interfaces.IContentMediator;
	import com.flashmastery.as3.microsite.patterns.interfaces.IHistoryProxy;
	import com.greensock.TweenLite;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMMainMediator extends FMContentMediator {
		
		protected var _currentContentMediator : IContentMediator;
		
		protected var _sectionsClassesList : Dictionary;

		public function FMMainMediator(viewComponent : Sprite, mediatorName : String = "", view : Sprite = null) {
			super( mediatorName, viewComponent, view );
			addNotification( FMNotifications.CHANGE_SECTION, changeSectionHandler );
			_sectionsClassesList = new Dictionary();
			hideView( 0, 0 );
		}

		protected function get view() : Sprite {
			return viewComponent as Sprite;	
		}
		
		protected function get currentSection() : String {
			return historyProxy.current;
		}

//		protected function get currentContentMediator() : IContentMediator {
//			return _currentContentMediator;
//		}
		
		protected function addSection( section : String, mediatorClass : Class ) : void {
			_sectionsClassesList[ section ] = mediatorClass;
		}

		protected function removeSection( section : String ) : void {
			delete _sectionsClassesList[ section ];
		}
		
		protected function getSectionClass( section : String ) : Class {
			return _sectionsClassesList[ section ] as Class;
		}

		protected function changeSectionHandler( note : INotification ) : void {
			changeSection( note.getBody() as String );
		}
		
		override protected function changeSection(section : String) : void {
			var newContentMediator : IContentMediator = getContentMediatorBySection( section );
			if ( newContentMediator && currentSection != section ) {
				if ( _currentContentMediator != null ) {
					var delay : Number = _currentContentMediator.hideView();
					TweenLite.delayedCall(delay, facade.removeMediator, [ _currentContentMediator.getMediatorName() ] );
				}
				_currentContentMediator = newContentMediator;
				if ( _currentContentMediator != null ) {
					historyProxy.setNext( section );
					_currentContentMediator.historyProxyName = historyProxyName;
					facade.registerMediator( _currentContentMediator );
				}
			}
		}
		
		protected function getContentMediatorBySection( section : String ) : IContentMediator {
			var mediatorClass : Class = getSectionClass( section );
			if ( mediatorClass ) return new mediatorClass( view );
			return null;
		}

		override public function onRegister() : void {
			super.onRegister();
			var historyProxyClass : Class = micrositeFacade.historyProxyClass;
			var historyProxyInstance : IHistoryProxy = new historyProxyClass( );
			historyProxyName = historyProxyInstance.getProxyName();
			facade.registerProxy( historyProxyInstance );
			setup();
			changeSection( configProxy.getStartPageConstant() );
		}

		override public function onRemove() : void {
			if ( _currentContentMediator ) {
				facade.removeMediator( _currentContentMediator.getMediatorName() );
				_currentContentMediator = null;
			}
			facade.removeProxy( historyProxyName );
			super.onRemove( );
		}

		protected function setup() : void {
			trace( "WARNING: FMMainMediator.setup() is not overridden!!!" );
		}
	}
}
