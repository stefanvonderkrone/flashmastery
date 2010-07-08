package com.flashmastery.as3.utils.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IElementContainer extends IDisposable {

		function addElement(element : *) : *;

		function addElementAt(element : *, index : uint) : *;

		function contains(element : *) : Boolean;

		function getElementAt(index : uint) : *;

		function getElementIndex(element : *) : int;

		function get numElements() : uint;

		function removeElement(element : *) : *;

		function removeElementAt(index : uint) : *;

		function setElementIndex(element : *, index : uint) : void;

		function swapElements(element1 : *, element2 : *) : void;

		function swapElementsAt(index1 : uint, index2 : uint) : void;
		
	}
}
