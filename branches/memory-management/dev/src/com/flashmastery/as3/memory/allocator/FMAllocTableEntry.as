package com.flashmastery.as3.memory.allocator {
	import com.flashmastery.as3.memory.interfaces.IAllocatable;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMAllocTableEntry implements IAllocatable {
		
		private var _released : Array;
		private var _allocated : Array;
		
		public function FMAllocTableEntry() {
		}
		
		public function dealloc() : void {
			_released.splice( 0, _released.length );
			_allocated.splice( 0, _allocated.length );
			_released = null;
			_allocated = null;
		}

		public function init() : IAllocatable {
			_released = [];
			_allocated = [];
			return this;
		}
		
		public function get released() : Array {
			return _released;
		}
		
		public function get allocated() : Array {
			return _allocated;
		}
	}
}
