package com.flashmastery.as3.microsite.patterns.interfaces {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IHistoryProxy extends IMicrositeProxy {
		
		function getFullHistory() : Array;
		
		function get current() : String;
		
		function setNext(next : String) : void;
		
		function get last() : String;
		
	}
}
