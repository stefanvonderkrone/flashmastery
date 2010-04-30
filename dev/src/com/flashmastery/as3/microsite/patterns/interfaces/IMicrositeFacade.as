package com.flashmastery.as3.microsite.patterns.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;
	import com.flashmastery.as3.microsite.interfaces.IStartupConfiguration;

	import org.puremvc.as3.multicore.interfaces.IFacade;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IMicrositeFacade extends IFacade, IDisposable {
		
		function get shutDownCommand() : Class;
		
		function get startupCommand() : Class;
		
		function startup( startupConfig : IStartupConfiguration ) : void;
		
		function get configProxy() : IConfigProxy;
		
		function set configProxy( configProxy : IConfigProxy ) : void;
		
		function get mainMediatorClass() : Class;
		
		function get configProxyClass() : Class;
		
		function get historyProxyClass() : Class;
	}
}
