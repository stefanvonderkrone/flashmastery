package com.flashmastery.as3.paper3d.core {
	import de.marcelklammer.as3.loading.events.LoaderManagerEvent;

	import com.flashmastery.as3.core.preloading.FMAbstractPreloader;
	import com.flashmastery.as3.core.preloading.FMPreloaderResourcesList;
	import com.flashmastery.as3.interfaces.IApplication;
	import com.flashmastery.as3.paper3d.assets.PreloaderView;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMPaper3DLoader extends FMAbstractPreloader {
		
		private var _preloaderView : PreloaderView;
		private var _loaderBarMaxWidth : Number;
		private var _application : IApplication;

		public function FMPaper3DLoader() {
			super( );
		}

		override protected function init(evt : Event = null) : void {
			super.init( evt );
			TweenPlugin.activate( [ AutoAlphaPlugin ] );
			_preloaderView = new PreloaderView();
			addChild( _preloaderView );
			_loaderBarMaxWidth = _preloaderView._loaderBar.width;
			_preloaderView._loaderBar.width = 0;
			initPreloader( loaderInfo.parameters.loaderXML ? loaderInfo.parameters.loaderXML : "loader.xml" );
			lockStage();
			stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		private function resizeHandler(evt : Event = null) : void {
			_preloaderView._bg.width = stage.stageWidth;
			_preloaderView._bg.height = stage.stageHeight;
			_preloaderView._loaderBar.y = Math.floor( stage.stageHeight / 2 );
			_preloaderView._loaderBar.x = _preloaderView._txtStatus.x = Math.floor( ( stage.stageWidth - _loaderBarMaxWidth ) / 2 );
			_preloaderView._txtStatus.y = _preloaderView._txtProgress.y = _preloaderView._loaderBar.y + 10;
			_preloaderView._txtProgress.x = _preloaderView._txtStatus.x + _preloaderView._txtStatus.width;
		}

		override protected function loaderManagerErrorHandler(evt : LoaderManagerEvent) : void {
			super.loaderManagerErrorHandler( evt );
			_preloaderView._txtStatus.text = "ERROR!!!";
		}

		override protected function loaderManagerCompleteHandler(evt : LoaderManagerEvent) : void {
			super.loaderManagerCompleteHandler( evt );
			_preloaderView._txtStatus.text = "Loaded:";
			_application = FMPreloaderResourcesList.getInstance().getResourceByID( "APPLICATION" ).resource as IApplication;
			addChild( _application as DisplayObject );
			TweenLite.from( _application, 0.5, { autoAlpha: 0, onComplete: startApplication } );
		}

		override protected function loaderManagerProgressHandler(evt : LoaderManagerEvent) : void {
			super.loaderManagerProgressHandler( evt );
			_preloaderView._txtProgress.text = Math.round( progress * 100 ) + " %";
			_preloaderView._loaderBar.width = progress * _loaderBarMaxWidth;
			_preloaderView._loaderBar.alpha = progress;
		}

		private function startApplication() : void {
			stage.removeEventListener( Event.RESIZE, resizeHandler );
			removeChild( _preloaderView );
			_application.start();
		}
	}
}
