package com.flashmastery.as3.memory.testimplementation {
	import flash.display.BitmapData;
	import com.flashmastery.as3.memory.interfaces.IAllocatable;

	import flash.display.Sprite;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMMemoryTestItem extends Sprite implements IAllocatable {
		
		private var _bitmapData : BitmapData;

		public function FMMemoryTestItem() {
			trace("FMMemoryTestItem: New Instance created!");
		}
		
		public function dealloc() : void {
			_bitmapData.dispose( );
			_bitmapData = null;
			graphics.clear();
		}

		public function init(...params) : IAllocatable {
			_bitmapData = new BitmapData(1000, 1000 );
			_bitmapData.perlinNoise(1000, 1000, 5, Math.round( ( Math.random() * 1000000 ) % 1000 ), false, false);
			graphics.beginFill( Math.round( Math.random() * 0xFFFFFF ) );
			graphics.drawCircle(-10, -10, 20);
			graphics.endFill();
			return this;
		}
	}
}
