package com.flashmastery.as3.memory.allocator {
	import com.flashmastery.as3.memory.interfaces.IAllocatable;
	import com.flashmastery.as3.memory.interfaces.IAllocator;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMAllocator implements IAllocator {
		
		private static var _instance : FMAllocator;
		
		public static function getInstance() : FMAllocator {
			if ( _instance == null ) _instance = new FMAllocator();
			return _instance;
		}
		
		private var _allocTable : Dictionary;
		private var _firstEntry : FMAllocTableEntry;

		public function FMAllocator() {
			_allocTable = new Dictionary( );
			_firstEntry = new FMAllocTableEntry( );
			_firstEntry.init();
		}

		public function alloc(allocableClass : Class) : * {
			var q : String = getQualifiedClassName( allocableClass );
			var entry : FMAllocTableEntry = _allocTable[ q ];
			var instance : *;
			if ( entry ) {
				instance = entry.released.length > 0 ? entry.released.pop() : new allocableClass( );
			} else {
				entry = FMAllocTableEntry( allocEntry().init() );
				_allocTable[ q ] = entry;
				instance = new allocableClass();
			}
			entry.allocated.push( instance );
			return instance;
		}

		private function allocEntry() : FMAllocTableEntry {
			var instance : FMAllocTableEntry; 
			instance = _firstEntry.released.length > 0 ? _firstEntry.released.pop() : new FMAllocTableEntry( );
			instance.init( );
			_firstEntry.allocated.push( instance );
			return instance;
		}

		public function release(instance : *) : void {
			var q : String = getQualifiedClassName( instance );
			var entry : FMAllocTableEntry = _allocTable[ q ];
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
		
		private function releaseEntry( instance : FMAllocTableEntry ) : void {
			for ( var i : uint = 0; i < _firstEntry.allocated.length; i++ ) {
				if ( _firstEntry.allocated[ i ] == instance ) {
					_firstEntry.allocated.splice( i, 1 );
					break;
				}
			}
			_firstEntry.released.push( instance );
			if ( instance is IAllocatable ) IAllocatable( instance ).dealloc();
		}

		public function clear( classes : Array = null ) : void {
			var entry : FMAllocTableEntry;
			var q : String;
			var deallocFirstEntry : Boolean = false;
			if ( classes ) {
				for ( var i : uint = 0; i < classes.length; i++ ) {
					if ( classes[ i ] != FMAllocTableEntry ) {
						q = getQualifiedClassName( classes[ i ] );
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
				_firstEntry.init();
			}
		}
	}
}
