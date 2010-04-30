package com.flashmastery.as3.microsite.patterns.interfaces {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IConfigProxy extends IMicrositeProxy {
		
		function get startPage() : String;
		
		function getDataProviderByMediatorName( mediatorName : String ) : Object;
		
		function setDataProviderByMediatorName( mediatorName : String, data : Object ) : void;
		
		function getFlashVarByID( id : String ) : String;
		
		function getStartPage( startPageID : String ) : String;
		
		function addStartPageConstant( constant : String, section : String ) : void;
		
		function removeStartPageConstant( constant : String ) : void;
		
		function getStartPageConstant() : String;
		
		function setDefaultStartPage( section : String ) : void;
		
	}
}
