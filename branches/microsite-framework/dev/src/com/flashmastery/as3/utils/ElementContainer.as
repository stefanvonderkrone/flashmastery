package com.flashmastery.as3.utils {
	import com.flashmastery.as3.utils.interfaces.IElementContainer;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class ElementContainer extends Object implements IElementContainer {

		protected var _elementList : Array;

		public function ElementContainer( elementList : Array = null ) {
			_elementList = elementList != null ? elementList : [];
		}

		public function addElement(element : *) : * {
			_elementList.push( element );
			return element;
		}

		public function addElementAt(element : *, index : uint) : * {
			if (index >= _elementList.length)
				_elementList.push( element );
			else
				_elementList.splice( index, 0, element );
			return element;
		}

		public function contains(element : *) : Boolean {
			var currentElement : *;
			for each (currentElement in _elementList) {
				if (currentElement == element)
					return true;
			}
			return false;
		}

		public function dispose() : void {
			_elementList.length = 0;
			_elementList = [];
		}

		public function getElementAt(index : uint) : * {
			if (index < _elementList.length)
				return _elementList[index];
			return null;
		}

		public function getElementIndex(element : *) : int {
			var index : uint = 0;
			while (index < _elementList.length) {
				if (_elementList[index] == element)
					return index;
				index++;
			}
			return -1;
		}

		public function get numElements() : uint {
			return _elementList.length;
		}

		public function removeElement(element : *) : * {
			var index : uint = 0;
			while (index < _elementList.length) {
				if (_elementList[index] == element)
					_elementList.splice( index, 1 );
				index = index + 1;
			}
			return element;
		}

		public function removeElementAt(index : uint) : * {
			if (index < _elementList.length)
				return _elementList.splice( index, 1 );
			return null;
		}

		public function setElementIndex(element : *, index : uint) : void {
			if (contains( element ) && index < element.length) {
				removeElement( element );
				addElementAt( element, index );
			}
			return;
		}

		public function swapElements(element1 : *, element2 : *) : void {
			if (contains( element1 ) && contains( element2 ))
				swapElementsAt( getElementIndex( element1 ), getElementIndex( element2 ) );
			return;
		}

		public function swapElementsAt(index1 : uint, index2 : uint) : void {
			var element1 : * = getElementAt( index1 );
			var element2 : * = getElementAt( index2 );
			if (element1 && element2) {
				if (index1 < index2) {
					setElementIndex( element1, index2 );
					setElementIndex( element2, index1 );
				} else {
					setElementIndex( element2, index1 );
					setElementIndex( element1, index2 );
				}
			}
			return;
		}
	}
}
