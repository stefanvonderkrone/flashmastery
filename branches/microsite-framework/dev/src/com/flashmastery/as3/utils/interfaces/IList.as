package com.flashmastery.as3.utils.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IList extends IDisposable {

		function addAll(elements : Array) : void;
		
		function addAllAt(elements : Array, index : Number) : void;
		
		function addElementAt(element : *, index : Number) : void;
		
		function addFirst(element : *) : void;
		
		function addLast(element : *) : void;
		
		function clear() : void;
		
		function clone() : IList;
		
		function contains(element : *) : Boolean;
		
		function getElementByIndex(index : Number) : *;
		
		function get first() : *;
		
		function getIndexOf(element : *, startIndex : Number = 0) : Number;
		
		function get last() : *;
		
		function isEmpty() : Boolean;
		
		function removeElement(element : *) : Boolean;
		
		function removeElementAt(index : Number) : void;
		
		function removeRange(fromIndex : Number, toIndex : Number) : void;
		
		function setElementAt(element : *, index : Number) : void;
		
		function get length() : Number;
		
		function set length( length : uint ): void;
		
		function toArray() : Array;
		
		function toString() : String;
		
	}
}
