package com.flashmastery.as3.memory {
	import com.flashmastery.as3.memory.allocator.FMAllocator;
	/**
	 * @author Stefan von der Krone (2010)
	 */
	public function alloc( allocableClass : Class ) : * {
		if ( allocator == null )
			allocator = FMAllocator.getInstance();
		return allocator.alloc( allocableClass );
	}
}
