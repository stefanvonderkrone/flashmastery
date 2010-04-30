package com.flashmastery.as3.microsite.patterns.interfaces {
	import com.flashmastery.as3.microsite.interfaces.IDisposable;

	import org.puremvc.as3.multicore.interfaces.IMediator;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public interface IInteractiveMediator extends IMediator, IDisposable {
		
		function get tweenDuration() : Number;
		
		function set tweenDuration( tweenDuration : Number ) : void;
		
		function showView( delay : Number = 0, time : Number = 0.5 ) : Number;
				function hideView( delay : Number = 0, time : Number = 0.5 ) : Number;
		
		function enableView() : void;
		
		function disableView() : void;
	}
}
