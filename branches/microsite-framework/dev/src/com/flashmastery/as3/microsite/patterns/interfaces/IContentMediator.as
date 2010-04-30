package com.flashmastery.as3.microsite.patterns.interfaces {

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IContentMediator extends IInteractiveMediator {
		
		function get historyProxyName() : String;
		
		function set historyProxyName( historyProxyName : String ) : void;
		
	}
}
