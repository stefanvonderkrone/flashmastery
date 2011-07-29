package com.flashmastery.as3.blitting.events {
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetEvent extends Event {

		public static const MOUSE_WHEEL : String = "sMouseWheel";
		public static const MOUSE_MOVE : String = "sMouseMove";
//		public static const ROLL_OUT : String = "rollOut";
		public static const MOUSE_OVER : String = "sMouseOver";
		public static const CLICK : String = "sClick";
		public static const MOUSE_OUT : String = "sMouseOut";
		public static const MOUSE_UP : String = "sMouseUp";
//		public static const DOUBLE_CLICK : String = "doubleClick";
		public static const MOUSE_DOWN : String = "sMouseDown";
//		public static const ROLL_OVER : String = "rollOver";

		protected var _target : Object;
		protected var _currentTarget : Object;
		protected var _localCoords : Point;
		protected var _stageCoords : Point;
		protected var _delta : int;

		public function SpriteSheetEvent( type : String, target : Object, currentTarget : Object, localCoords : Point, stageCoords : Point, delta : int ) {
			super( type, false, false );
			_target = target;
			_currentTarget = currentTarget;
			_localCoords = localCoords;
			_stageCoords = stageCoords;
			_delta = delta;
		}
		
		override public function get target() : Object {
			return _target;
		}
		
		override public function get currentTarget() : Object {
			return _currentTarget;
		}

		public function get localCoords() : Point {
			return _localCoords;
		}

		public function get stageCoords() : Point {
			return _stageCoords;
		}

		public function get delta() : int {
			return _delta;
		}
		
		override public function clone() : Event {
			return new SpriteSheetEvent(type, _target, _currentTarget, _localCoords, _stageCoords, _delta);
		}
		
		override public function toString() : String {
			return formatToString( "SpriteSheetEvent", "localCoords", "stageCoords", "delta" );
		}
	}
}
