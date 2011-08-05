package com.flashmastery.as3.blitting.core {
	
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetStage extends SpriteSheetContainer {

		
		protected var _stageWidth : Number;
		protected var _stageHeight : Number;

		public function SpriteSheetStage() {
			super();
		}
		
		override protected function construct() : void {
			super.construct();
			_stage = this;
			_root = this;
		}
		
		override public function addChild( child : SpriteSheet ) : SpriteSheet {
			_root = child;
			super.addChild( child );
			_root = this;
			return child;
		}
		
		override public function addChildAt( child : SpriteSheet, index : int ) : SpriteSheet {
			_root = child;
			super.addChildAt( child, index );
			_root = this;
			return child;
		}
		
		final override public function bSetRoot( root : SpriteSheet ) : void {
			root;
		}
		
		final override public function bSetStage( stage : SpriteSheetStage ) : void {
			stage;
		}
		
		final override public function set visible( visible : Boolean ) : void {
			visible;
		}
		
		final override public function set x( x : int ) : void {
			x;
		}

		final override public function set y( y : int ) : void {
			y;
		}
		
		final override public function set registrationOffsetX( registrationOffsetX : int ) : void {
			registrationOffsetX;
		}
		
		final override public function set registrationOffsetY( registrationOffsetY : int ) : void {
			registrationOffsetY;
		}

		public function get stageWidth() : Number {
			return _stageWidth;
		}

		public final function bSetStageWidth( stageWidth : Number ) : void {
			_stageWidth = stageWidth;
		}

		public function get stageHeight() : Number {
			return _stageHeight;
		}

		public final function bSetStageHeight( stageHeight : Number ) : void {
			_stageHeight = stageHeight;
		}
	}
}
