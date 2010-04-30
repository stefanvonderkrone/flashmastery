package com.flashmastery.as3.microsite.patterns.view {	import gs.TweenLite;	import de.marcelklammer.as3.collections.HashMap;	import com.adobe.utils.ArrayUtil;	import com.flashmastery.as3.microsite.patterns.interfaces.IInteractiveMediator;	import com.flashmastery.as3.microsite.patterns.model.vo.FMInputFieldVO;	import org.puremvc.as3.multicore.patterns.mediator.Mediator;	import flash.display.InteractiveObject;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.display.Sprite;	import flash.events.FocusEvent;	import flash.events.MouseEvent;	import flash.text.TextField;	/**	 * @author Stefan von der Krone (2010)	 */	public class FMInteractiveMediator extends Mediator implements IInteractiveMediator {				public static var TWEEN_DURATION : Number = 0.5;		private var _tweenDuration : Number;		private var _tabIndex : uint;				protected var _inputList : Array;		// TODO: Marcels HashMap ausgrenzen		protected var _inputMap : HashMap;		protected var _buttonList : Array;		protected var _contentView : Sprite;		protected var _contentContainer : Sprite;		public static const NAME : String = "FMInteractiveMediator";		public function FMInteractiveMediator( mediatorName : String = null, viewComponent : Sprite = null, view : Sprite = null ) {			super( mediatorName, viewComponent );			_tweenDuration = TWEEN_DURATION;			_inputList = [];			_buttonList = [];			_inputMap = new HashMap( );			_tabIndex = 0;			_contentContainer = this.viewComponent as Sprite;			if ( view ) this.viewComponent = _contentView = view;		}		public function showView(delay : Number = 0, time : Number = 0.5) : Number {			if ( viewComponent != null ) TweenLite.to( viewComponent, time, { autoAlpha: 1, delay: delay } );			return delay + time;		}				public function hideView(delay : Number = 0, time : Number = 0.5) : Number {			if ( viewComponent != null ) TweenLite.to( viewComponent, time, { autoAlpha: 0, delay: delay } );			return delay + time;		}				public function enableView() : void {			( viewComponent as Sprite ).tabEnabled = false;			( viewComponent as Sprite ).tabChildren = false;			( viewComponent as Sprite ).mouseChildren = false;			( viewComponent as Sprite ).mouseEnabled = false;		}				public function disableView() : void {			( viewComponent as Sprite ).tabEnabled = true;			( viewComponent as Sprite ).tabChildren = true;			( viewComponent as Sprite ).mouseChildren = true;			( viewComponent as Sprite ).mouseEnabled = true;		}				public function dispose() : void {			var input : TextField;			var interactiveObject : InteractiveObject;			for each ( interactiveObject in _buttonList )				destroyButton( interactiveObject );			for each ( input in _inputList )				destroyInput( input );			_inputMap.dispose( );			_inputMap = null;			_inputList = null;			_buttonList = null;			_contentContainer = null;			_contentView = null;		}		override public function onRegister() : void {			if ( _contentView != null ) 				_contentContainer.addChild( _contentView );			hideView( 0, 0 );			showView( 0.5 );		}		override public function onRemove() : void {			super.onRemove( );			enableView( );			if ( _contentView != null )				_contentContainer.removeChild( _contentView );			dispose( );		}		protected function initInput( input : TextField, defaultText : String, useHTML : Boolean = false, password : Boolean = false ) : void {			input.addEventListener( FocusEvent.FOCUS_IN, focusInHandler );			input.addEventListener( FocusEvent.FOCUS_OUT, focusOutHandler ); 			input.tabIndex = tabIndex++;			var inputVO : FMInputFieldVO = new FMInputFieldVO( input, defaultText, useHTML, password );			_inputMap.put( input, inputVO );			if ( useHTML ) input.htmlText = defaultText;			else input.text = defaultText;			inputVO.text = input.text;			_inputList.push( input );		}		protected function destroyInput( input : TextField, resetToDefaultText : Boolean = false ) : void {			input.removeEventListener( FocusEvent.FOCUS_IN, focusInHandler );			input.removeEventListener( FocusEvent.FOCUS_OUT, focusOutHandler ); 			input.tabIndex = -1;			var inputVO : FMInputFieldVO = _inputMap.get( input );			if ( resetToDefaultText ) {				if ( inputVO.html ) input.htmlText = inputVO.defaultText;				else input.text = inputVO.defaultText;				if ( inputVO.password ) input.displayAsPassword = false;			}			ArrayUtil.removeValueFromArray( _inputList, input );		}		protected function enabeleInput( input : TextField ) : void {			enableButton( input );		}		protected function disableInput( input : TextField ) : void {			disableButton( input );		}		protected function focusOutHandler(evt : FocusEvent) : void {			var input : TextField = evt.currentTarget as TextField;			var inputVO : FMInputFieldVO = _inputMap.get( input );			if ( input.text == "" ) {				if ( inputVO.html ) input.htmlText = inputVO.defaultText;				else input.text = inputVO.defaultText;				if ( inputVO.password ) input.displayAsPassword = false;			}		}		protected function focusInHandler(evt : FocusEvent) : void {			var input : TextField = evt.currentTarget as TextField;			var inputVO : FMInputFieldVO = _inputMap.get( input );			if ( input.text == inputVO.text ) {				input.text = "";				if ( inputVO.password ) input.displayAsPassword = true;			}		}		protected function initButton( button : InteractiveObject ) : void {			var mc : MovieClip = button as MovieClip;			var sp : Sprite = button as Sprite;			button.addEventListener( MouseEvent.CLICK, clickHandler );			button.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );			button.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );			button.tabIndex = _tabIndex++;			if ( sp != null ) {				sp.buttonMode = true;				sp.mouseChildren = false;				sp.useHandCursor = true;				sp.tabChildren = false;				if ( mc != null )					mc.gotoAndStop( 1 );			}			_buttonList.push( button );		}		protected function destroyButton( button : InteractiveObject ) : void {			var sp : Sprite = button as Sprite;			button.removeEventListener( MouseEvent.CLICK, clickHandler );			button.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );			button.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );			if ( sp != null ) {				sp.buttonMode = false;				sp.mouseChildren = true;				sp.useHandCursor = false;				sp.tabChildren = true;			}			button.tabIndex = -1;			ArrayUtil.removeValueFromArray( _buttonList, button );		}		protected function enableButton( button : InteractiveObject ) : void {			var sb : SimpleButton = button as SimpleButton;			button.mouseEnabled = true;			button.tabEnabled = true;			if ( sb != null ) sb.enabled = true;			button.addEventListener( MouseEvent.CLICK, clickHandler );			button.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );			button.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );		}		protected function disableButton( button : InteractiveObject ) : void {			var sb : SimpleButton = button as SimpleButton;			button.mouseEnabled = false;			button.tabEnabled = false;			if ( sb != null ) sb.enabled = false;			button.removeEventListener( MouseEvent.CLICK, clickHandler );			button.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );			button.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );		}		protected function mouseOutHandler(evt : MouseEvent) : void {		}		protected function mouseOverHandler(evt : MouseEvent) : void {		}		protected function clickHandler(evt : MouseEvent) : void {		}				public function get tweenDuration() : Number {			return _tweenDuration;		}				public function set tweenDuration(tweenDuration : Number) : void {			_tweenDuration = tweenDuration;		}				protected function get tabIndex() : uint {			return _tabIndex;		}				protected function set tabIndex(tabIndex : uint) : void {			_tabIndex = tabIndex;		}	}}