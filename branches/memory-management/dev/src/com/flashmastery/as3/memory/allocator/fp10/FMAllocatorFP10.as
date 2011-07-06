package com.flashmastery.as3.memory.allocator.fp10 {
	import com.flashmastery.as3.memory.interfaces.IAllocatable;
	import com.flashmastery.as3.memory.interfaces.IAllocator;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMAllocatorFP10 implements IAllocator {
		
		private static var _instance : FMAllocatorFP10;
		
		public static function getInstance() : FMAllocatorFP10 {
			if ( _instance == null ) _instance = new FMAllocatorFP10();
			return _instance;
		}
		
		private var _allocTable : Dictionary;
		private var _firstEntry : FMAllocTableEntryFP10;

		public function FMAllocatorFP10() {
			init();
		}

		protected function init() : void {
			_allocTable = new Dictionary( );
			_firstEntry = new FMAllocTableEntryFP10( );
			_firstEntry.init( );
		}

		public function alloc(allocableClass : Class) : * {
			var q : String = getQualifiedClassName( allocableClass ).split( "::" ).join( "." );
			var entry : FMAllocTableEntryFP10 = _allocTable[ q ];
			var instance : *;
			if ( entry ) {
				instance = entry.released.length > 0 ? entry.released.pop() : new allocableClass( );
			} else {
				entry = FMAllocTableEntryFP10( allocEntry().init( ) );
				_allocTable[ q ] = entry;
				instance = new allocableClass();
			}
			entry.allocated.push( instance );
			return instance;
		}

		private function allocEntry() : FMAllocTableEntryFP10 {
			var instance : FMAllocTableEntryFP10; 
			instance = _firstEntry.released.length > 0 ? _firstEntry.released.pop() : new FMAllocTableEntryFP10( );
			instance.init( );
			_firstEntry.allocated.push( instance );
			return instance;
		}
		
		public function release(instance : *) : void {
			var q : String = getQualifiedClassName( instance ).split( "::" ).join( "." );
			var entry : FMAllocTableEntryFP10 = _allocTable[ q ];
			if ( entry ) {
				for ( var i : uint = 0; i < entry.allocated.length; i++ ) {
					if ( entry.allocated[ i ] == instance ) {
						entry.allocated.splice( i, 1 );
						break;
					}
				}
				entry.released.push( instance );
			}
			if ( instance is IAllocatable ) IAllocatable( instance ).dealloc();
		}
		
		private function releaseEntry( instance : FMAllocTableEntryFP10 ) : void {
			for ( var i : uint = 0; i < _firstEntry.allocated.length; i++ ) {
				if ( _firstEntry.allocated[ i ] == instance ) {
					_firstEntry.allocated.splice( i, 1 );
					break;
				}
			}
			_firstEntry.released.push( instance );
			if ( instance is IAllocatable ) IAllocatable( instance ).dealloc();
		}
		
		public function clear(classes : Array = null) : void {
			var entry : FMAllocTableEntryFP10;
			var q : String;
			var deallocFirstEntry : Boolean = false;
			if ( classes ) {
				for ( var i : uint = 0; i < classes.length; i++ ) {
					if ( classes[ i ] != FMAllocTableEntryFP10 ) {
						q = getQualifiedClassName( classes[ i ] ).split( "::" ).join( "." );
						entry = _allocTable[ q ];
						delete _allocTable[ q ];
						if ( entry ) releaseEntry( entry );
					} else deallocFirstEntry = true;
				}
			} else {
				for ( q in _allocTable ) {
					entry = _allocTable[ q ];
					delete _allocTable[ q ];
					if ( entry ) releaseEntry( entry );
				}
			}
			if ( deallocFirstEntry || classes == null ) {
				_firstEntry.dealloc( );
				_firstEntry.init( );
			}
		}
	}
}
