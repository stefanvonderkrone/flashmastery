package com.flashmastery.as3.microsite.patterns.model.vo {
	import flash.text.TextField;

	/**
	 * @author Stefan von der Krone (2010)
	 */
	public class FMInputFieldVO extends Object {

		private var _input : TextField;
		private var _defaultText : String;
		private var _text : String;
		private var _html : Boolean;
		private var _password : Boolean;

		public function FMInputFieldVO( input : TextField, defaultText : String, useHTML : Boolean = false, password : Boolean = false ) {
			_input = input;
			_defaultText = defaultText;
			_html = useHTML;
			_password = password;
		}

		public function get input() : TextField {
			return _input;
		}
		
		public function get defaultText() : String {
			return _defaultText;
		}
		
		public function set defaultText(defaultText : String) : void {
			_defaultText = defaultText;
		}
		
		public function get html() : Boolean {
			return _html;
		}
		
		public function set html(html : Boolean) : void {
			_html = html;
		}
		
		public function get password() : Boolean {
			return _password;
		}
		
		public function set password(password : Boolean) : void {
			_password = password;
		}
		
		public function get text() : String {
			return _text;
		}
		
		public function set text(text : String) : void {
			_text = text;
		}
	}
}
