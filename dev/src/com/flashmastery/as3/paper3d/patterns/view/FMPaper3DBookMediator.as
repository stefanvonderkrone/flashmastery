package com.flashmastery.as3.paper3d.patterns.view {	import away3d.containers.View3D;	import away3d.core.math.Number3D;	import away3d.core.utils.Cast;	import away3d.materials.BitmapMaterial;	import com.flashmastery.as3.display.ExtendedSprite;	import com.flashmastery.as3.paper3d.components.Book3D;	import com.flashmastery.as3.paper3d.components.Page3D;	import com.flashmastery.as3.paper3d.patterns.controller.notifications.FMPaper3DNotificationList;	import com.flashmastery.as3.paper3d.patterns.model.FMPaper3DResourcesProxy;	import com.flashmastery.as3.paper3d.patterns.model.FMPaper3DSettingsProxy;	import org.puremvc.as3.multicore.interfaces.IMediator;	import org.puremvc.as3.multicore.interfaces.INotification;	import org.puremvc.as3.multicore.patterns.mediator.Mediator;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.Stage;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	/**	 * @author Stefan von der Krone (2009)	 */	public class FMPaper3DBookMediator extends Mediator implements IMediator {		public static const NAME : String = "FMPaper3DBookMediator";				private var _view : View3D;		private var _frontMaterial : BitmapMaterial;		private var _backMaterial : BitmapMaterial;		private var _book3D : Book3D;		public function FMPaper3DBookMediator(viewComponent : DisplayObject) {			super(NAME, viewComponent);		}				private function get view() : ExtendedSprite {			return viewComponent as ExtendedSprite;			}				private function get settingsProxy() : FMPaper3DSettingsProxy {			return facade.retrieveProxy( FMPaper3DSettingsProxy.NAME ) as FMPaper3DSettingsProxy;		}				private function get resourcesProxy() : FMPaper3DResourcesProxy {			return facade.retrieveProxy( FMPaper3DResourcesProxy.NAME ) as FMPaper3DResourcesProxy;		}		override public function listNotificationInterests() : Array {			return [ FMPaper3DNotificationList.STAGE_RESIZE ];		}				override public function handleNotification(note : INotification) : void {			switch(note.getName()) {				case FMPaper3DNotificationList.STAGE_RESIZE:						handleStageResize( note.getBody() as Stage ); 					break; 				}		}				private function handleStageResize( stage : Stage ) : void {			if ( stage ) {				_view.x = Math.ceil( stage.stageWidth / 2 );				_view.y = Math.ceil( stage.stageHeight / 2 );			}		}		override public function onRegister() : void {			//register new mediators here			_view = new View3D();			view.addChild( _view );			_view.camera.zoom = 6;			_view.camera.focus = 200;			_view.camera.z = -settingsProxy.settings.cameraDistance * 2;			_view.camera.y = settingsProxy.settings.cameraDistance / 2;//			_view.camera.y = 100;			_view.camera.lookAt( new Number3D() );			_view.x = Math.ceil( view.stage.stageWidth / 2 );			_view.y = Math.ceil( view.stage.stageHeight / 2 );			view.addEventListener( Event.RENDER, renderHandler );						var frontImage : Bitmap = resourcesProxy.resources.getResourceByID( "material_front" ).resource;			var backImage : Bitmap = resourcesProxy.resources.getResourceByID( "material_back" ).resource;			_frontMaterial = new BitmapMaterial( Cast.bitmap( frontImage ) );			_backMaterial = new BitmapMaterial( Cast.bitmap( backImage ) );			_book3D = new Book3D( 174 , 6 );			_book3D.addPage3D( new Page3D( _frontMaterial, _backMaterial, 210, 297, 10, 10 ) );			_book3D.addPage3D( new Page3D( _frontMaterial, _backMaterial, 210, 297, 10, 10 ) );			_book3D.addPage3D( new Page3D( _frontMaterial, _backMaterial, 210, 297, 10, 10 ) );			_book3D.addPage3D( new Page3D( _frontMaterial, _backMaterial, 210, 297, 10, 10 ) );			_view.scene.addChild( _book3D );			_book3D.rotationX = 45;			view.addEventListener( Event.ENTER_FRAME, renderHandler );			view.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyHandler );		}				private function keyHandler( evt : KeyboardEvent ) : void {			if ( evt.keyCode == Keyboard.LEFT ) _book3D.nextPage3D();			else if ( evt.keyCode == Keyboard.RIGHT ) _book3D.previousPage3D();		}		private function renderHandler( evt : Event = null ) : void {			_book3D.updateBook3D();			_view.render();		}	}}