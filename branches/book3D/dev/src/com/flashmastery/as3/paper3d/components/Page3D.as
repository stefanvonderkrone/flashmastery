package com.flashmastery.as3.paper3d.components {
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;

	import com.as3dmod.ModifierStack;
	import com.as3dmod.modifiers.Bend;
	import com.as3dmod.plugins.away3d.LibraryAway3d;
	import com.as3dmod.util.ModConstant;

	/**
	 * @author Stefan von der Krone (2009)
	 */
	public class Page3D extends ObjectContainer3D {
		
		public static const FLIP_CONCAVE : Number = 1;		public static const FLIP_CONVEX : Number = -1;

		protected var _plane : Plane;
		protected var _modifierStack : ModifierStack;
		protected var _bendMod : Bend;		protected var _baseBendMod : Bend;
		protected var _baseBendForce : Number;		protected var _baseBendOffset : Number;		protected var _baseBendAngle : Number;
		protected var _closeAngle : Number;		protected var _openAngle : Number;
		protected var _openingRel : Number;
		protected var _flip : Number;
		protected var _changed : Boolean;
		public function Page3D( frontMaterial : BitmapMaterial, backMaterial : BitmapMaterial, width : Number = 210, height : Number = 297, segmentsW : uint = 15, segmentsH : uint = 15 ) {
			super();
			_plane = new Plane( { width: width, height: height, segmentsW: segmentsW, segmentsH: segmentsH, material: frontMaterial , back: backMaterial, bothsides: true } );
			_plane.x = _plane.width / 2;
			addChild( _plane );
			_modifierStack = new ModifierStack( new LibraryAway3d( ), _plane );
			_bendMod = new Bend( 0, 0.1, -Math.PI / 2 );
			_baseBendMod = new Bend( 0.1, 0.8, Math.PI / 2 );
			_baseBendAngle = _baseBendMod.angle;			_baseBendOffset = _baseBendMod.offset;			_baseBendForce = _baseBendMod.force;
			_bendMod.constraint = ModConstant.LEFT;
			_modifierStack.addModifier( _bendMod );			_modifierStack.addModifier( _baseBendMod );
			_changed = true;
			rotationZ = _closeAngle = 6;
			_openAngle = 174;
			_openingRel = 0;
			_flip = FLIP_CONCAVE;
		}

		public function get frontMaterial() : BitmapMaterial {
			return _plane.material as BitmapMaterial;
		}
		
		public function set frontMaterial(frontMaterial : BitmapMaterial) : void {
			_plane.material = frontMaterial;
			_changed = true;
		}
		
		public function get backMaterial() : BitmapMaterial {
			return _plane.back as BitmapMaterial;
		}
		
		public function set backMaterial(backMaterial : BitmapMaterial) : void {
			_plane.back = backMaterial;
			_changed = true;
		}
		
		public function get width() : Number {
			return _plane.width;
		}
		
		public function set width(width : Number) : void {
			_plane.width = width;
			_plane.x = _plane.width / 2;
			_changed = true;
		}
		
		public function get height() : Number {
			return _plane.height;
		}
		
		public function set height(height : Number) : void {
			_plane.height = height;
			_changed = true;
		}
		
		public function get bendAngle() : Number {
			return _bendMod.angle;
		}
		
		public function set bendAngle( bendAngle : Number ) : void {
			_bendMod.angle = bendAngle;
			_changed = true;
		}
		
		public function get bendForce() : Number {
			return _bendMod.force;
		}
		
		public function set bendForce(bendForce : Number) : void {
			_bendMod.force = Math.round( bendForce * 100 ) / 100;
			_changed = true;
		}
		
//		public function get bendOffset() : Number {
//			return _bendMod.offset;
//		}
//		
//		public function set bendOffset(bendOffset : Number) : void {
//			_bendMod.offset = bendOffset;
//			_changed = true;
//		}
		
		public function get baseBendAngle() : Number {
			return _baseBendAngle;
		}
		
		public function set baseBendAngle(baseBendAngle : Number) : void {
			_baseBendAngle = baseBendAngle;
			openingRel = _openingRel;
		}
		
		public function get baseBendForce() : Number {
			return _baseBendForce;
		}
		
		public function set baseBendForce(baseBendForce : Number) : void {
//			trace( baseBendForce );
			_baseBendForce = baseBendForce;
			openingRel = _openingRel;
		}
		
		public function get baseBendOffset() : Number {
			return _baseBendOffset;
		}
		
		public function set baseBendOffset(baseBendOffset : Number) : void {
			_baseBendOffset = baseBendOffset;
			openingRel = _openingRel;
		}
		
		public function get closeAngle() : Number {
			return _closeAngle;
		}
		
		public function set closeAngle(closeAngle : Number) : void {
			_closeAngle = closeAngle;
		}
		
		public function get openAngle() : Number {
			return _openAngle;
		}
		
		public function set openAngle(openAngle : Number) : void {
			_openAngle = openAngle;
		}

		public function get flip() : Number {
			return _flip;
		}
		
		public function set flip(flip : Number) : void {
			_flip = flip;
		}
		
		public function get openingRel() : Number {
			return _openingRel;
		}
		
		public function set openingRel( openingRel : Number ) : void {
			if ( openingRel < 0 ) _openingRel = 0;
			else if ( openingRel > 1 ) _openingRel = 1;
			else _openingRel = openingRel;
			_changed = true;
		}

		public function updatePage3D() : void {
			if ( _changed ) {
				rotationZ = _closeAngle + ( _openAngle - _closeAngle ) * _openingRel;
				_baseBendMod.force = _baseBendForce - _baseBendForce * 2 * _openingRel;				bendForce = Math.sin( Math.PI * _openingRel ) * _flip / 2;
				_modifierStack.apply( );
			}
			_changed = false; 
		}
	}
}
