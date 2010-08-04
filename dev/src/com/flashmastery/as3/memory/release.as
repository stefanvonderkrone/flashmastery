package com.flashmastery.as3.memory {
	/**
	 * @author Stefan von der Krone (2010)
	 */
	public function release( instance : * ) : void {
		if ( allocator ) allocator.release( instance );
	}
}
