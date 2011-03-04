package com.flashmastery.as3.memory.allocator.fp10 {
	import com.flashmastery.as3.memory.interfaces.IAllocatable;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMAllocTableEntryFP10 implements IAllocatable {
		
		private var _released : Vector.<*>;
		private var _allocated : Vector.<*>;
		
		public function FMAllocTableEntryFP10() {
		}

		public function dealloc() : void {
			_released.splice( 0, _released.length );
			_allocated.splice( 0, _allocated.length );
			_released = null;
			_allocated = null;
		}
		
		public function init(...params : *) : IAllocatable {
			_released = new Vector.<*>( );
			_allocated = new Vector.<*>( );
			return this;
		}
		
		public function get released() : Vector.<*> {
			return _released;
		}
		
		public function get allocated() : Vector.<*> {
			return _allocated;
		}
	}
}
