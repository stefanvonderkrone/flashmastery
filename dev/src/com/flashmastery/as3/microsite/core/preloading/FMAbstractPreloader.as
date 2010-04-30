package com.flashmastery.as3.microsite.core.preloading {
	import de.marcelklammer.as3.loading.events.CommonLoaderEvent;
	import de.marcelklammer.as3.loading.events.LoaderManagerEvent;
	import de.marcelklammer.as3.loading.interfaces.ILoader;
	import de.marcelklammer.as3.loading.loadermanager.LoaderManager;
	import de.marcelklammer.as3.loading.loaders.CommonLoader;
	import de.marcelklammer.as3.loading.loaders.CommonURLLoader;

	import com.flashmastery.as3.display.RootSprite;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMAbstractPreloader extends RootSprite {
		
//		private static var _instance : FMAbstractPreloader;
//		public static function getInstance() : FMAbstractPreloader {
//			return _instance;
//		}

		protected var _loaderManager : LoaderManager;
		protected var _xmlLoader : CommonURLLoader;
		protected var _loaderXML : XML;
		protected var _loaderResources : FMPreloaderResourcesList;
		
		protected var _progress : Number;

		public function FMAbstractPreloader( ) {
			super( );
//			if ( !_instance ) _instance = this;
//			else throw( new Error( "Only One Instance of FMAbstractPreloader is allowed!" ) );
		}
		
		protected function initPreloader( loaderXML : String ) : void {
			_xmlLoader = new CommonURLLoader( loaderXML );
			_xmlLoader.addEventListener( CommonLoaderEvent.COMPLETE, xmlCompleteHandler );			_xmlLoader.addEventListener( CommonLoaderEvent.ERROR, xmlErrorHandler );
			_xmlLoader.load();
		}

		protected function xmlErrorHandler(evt : CommonLoaderEvent) : void {
//			trace( evt.error );
		}

		protected function xmlCompleteHandler(evt : CommonLoaderEvent) : void {
			_loaderXML = new XML( _xmlLoader.loadedData );
//			trace( _loaderXML );
			parseXMLAndLoad();
		}
		
		protected function parseXMLAndLoad() : void {
			_loaderResources = FMPreloaderResourcesList.getInstance();
			_loaderManager = new LoaderManager( );
			_loaderManager.addEventListener( LoaderManagerEvent.COMPLETE, loaderManagerCompleteHandler );			_loaderManager.addEventListener( LoaderManagerEvent.ERROR, loaderManagerErrorHandler );			_loaderManager.addEventListener( LoaderManagerEvent.PROGRESS, loaderManagerProgressHandler );
//			use namespace preloaderXML;
			var resource : FMPreloaderResource;
			var resourceList : XMLList = _loaderXML..resource;
			var resourceXML : XML;
			var loader : ILoader;
			for each (resourceXML in resourceList) {
				resource = new FMPreloaderResource( resourceXML.@url.toString( ), resourceXML.@id.toString( ), resourceXML.@type.toString() );
				switch( resource.type ) {
					case FMPreloaderResourceType.SWF:					case FMPreloaderResourceType.BITMAP:
							loader = new CommonLoader( resource.url );
						break;
					case FMPreloaderResourceType.XML:
							loader = new CommonURLLoader( resource.url );
						break;
				}
				resource.loader = loader;
				_loaderResources.push( resource );
				_loaderManager.registerLoader( loader );
			}
			_loaderManager.load();
		}

		protected function loaderManagerProgressHandler(evt : LoaderManagerEvent) : void {
			_progress = 0;
			var resource : FMPreloaderResource;
			var loader : ILoader;
			for each (resource in _loaderResources) {
				loader = resource.loader;
				_progress += ( ( loader.bytesTotal > 0 ) ? loader.bytesLoaded / loader.bytesTotal : 0 ) / _loaderResources.length;
			}
		}

		protected function loaderManagerErrorHandler(evt : LoaderManagerEvent) : void {
//			trace( "ERROR while loading Resources!" );
//			trace( evt.resultVO.errorProxies );
		}

		protected function loaderManagerCompleteHandler(evt : LoaderManagerEvent) : void {
			_loaderManager.dispose();
		}

		public function get progress() : Number {
			return _progress;
		}
		
		public function get loaderResources() : FMPreloaderResourcesList {
			return _loaderResources;
		}
	}
}
