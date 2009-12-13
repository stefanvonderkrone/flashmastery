package com.flashmastery.as3.headergallery.vo {
	import Object;
	import com.flashmastery.as3.headergallery.effects.FMAlphaScreenEffect;
	import com.flashmastery.as3.headergallery.effects.FMColorScreenEffect;
	import com.flashmastery.as3.headergallery.effects.FMSmoothedMaskEffect;
	import com.flashmastery.as3.headergallery.effects.FMStripedMaskEffect;
	import com.flashmastery.as3.headergallery.effects.FMTiledMaskEffect;
	import com.flashmastery.as3.headergallery.interfaces.IHeaderGalleryEffect;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class FMHeaderGalleryResourceVO extends Object {

		private static var _instance : FMHeaderGalleryResourceVO;

		public static function getInstance() : FMHeaderGalleryResourceVO {
			if ( _instance == null ) _instance = new FMHeaderGalleryResourceVO();
			return _instance;
		}
		
		private var _configVO : FMHeaderGalleryConfigVO;
		private var _effects : Dictionary;
		private var _images : Array;

		public function FMHeaderGalleryResourceVO() {
			_configVO = new FMHeaderGalleryConfigVO( );
			_effects = new Dictionary( );
			_images = [];
		}
		
		public function parseXML(xml : XML) : void {
			var child : XML;
			var effect : IHeaderGalleryEffect;
			for each ( child in xml.headergallery.config.children() ) {
				setValue( _configVO, child.@name.toString( ), child.@value.toString() );
				trace( "_config." + child.@name.toString( ) + " = " + _configVO[ child.@name.toString( ) ] );
			}
			for each ( child in xml.headergallery.effects.children() ) {
				effect = getEffect( child );
				_effects[ effect.id ] = effect;
			}
			for each ( child in xml.headergallery.images.children() ) {
				
			}
		}
		
		private function getEffect(child : XML) : IHeaderGalleryEffect {
			var id : String = child.@id.toString();
			var type : String = child.@type.toString();
			var speed : Number = Math.abs( parseFloat( child.@speed.toString() ) );
			var param : XML;
			var effect : IHeaderGalleryEffect;
			switch( type ) {
				case FMAlphaScreenEffect.TYPE:
						effect = new FMAlphaScreenEffect(id, speed);
					break;
				case FMColorScreenEffect.TYPE:
						effect = new FMColorScreenEffect(id, speed);
					break;
				case FMSmoothedMaskEffect.TYPE:
						effect = new FMSmoothedMaskEffect(id, speed);
					break;
				case FMStripedMaskEffect.TYPE:
						effect = new FMStripedMaskEffect(id, speed);
					break;
				case FMTiledMaskEffect.TYPE:
						effect = new FMTiledMaskEffect(id, speed);
					break;
			}
			for each ( param in child.children() ) {
				setValue( effect, param.@name.toString( ), param.@value.toString() );
			}
			return effect;
		}

		private function setValue(target : *, param : String, value : String ) : void {
			if ( target[ param ] == null ) trace( "Param \"" + param + "\" doesn't exist in \"" + getQualifiedClassName( target ) );
			else if ( target[ param ] is String ) param = value;
			else if ( target[ param ] is Number ) target[ param ]  = parseFloat( value );			else if ( target[ param ] is int ) target[ param ]  = parseInt( value );			else if ( target[ param ] is uint ) target[ param ]  = Math.abs( parseInt( value ) );			else if ( target[ param ] is Boolean )
				target[ param ]  = value.toLowerCase() == "true" ? true : false;
		}

		public function get images() : Array {
			return _images;
		}
		
		public function get effects() : Dictionary {
			return _effects;
		}
		
		public function get configVO() : FMHeaderGalleryConfigVO {
			return _configVO;
		}
	}
}
