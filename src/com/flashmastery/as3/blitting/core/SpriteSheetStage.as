package com.flashmastery.as3.blitting.core {
	
	use namespace blitting;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetStage extends SpriteSheetContainer {

		
		protected var _stageWidth : Number;
		protected var _stageHeight : Number;

		public function SpriteSheetStage() {
			super();
		}
		
		override protected function contruct() : void {
			super.contruct();
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
		
		final override protected function setRoot( root : SpriteSheet ) : void {
			root;
		}
		
		final override protected function setStage( stage : SpriteSheetStage ) : void {
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
		
		final override public function set registrationPointX( registrationPointX : int ) : void {
			registrationPointX;
		}
		
		final override public function set registrationPointY( registrationPointY : int ) : void {
			registrationPointY;
		}

		public function get stageWidth() : Number {
			return _stageWidth;
		}

		blitting function setStageWidth( stageWidth : Number ) : void {
			_stageWidth = stageWidth;
		}

		public function get stageHeight() : Number {
			return _stageHeight;
		}

		blitting function setStageHeight( stageHeight : Number ) : void {
			_stageHeight = stageHeight;
		}
	}
}
