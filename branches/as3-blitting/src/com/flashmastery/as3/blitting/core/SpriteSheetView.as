package com.flashmastery.as3.blitting.core {
	import com.flashmastery.as3.blitting.events.SpriteSheetEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	[Event(name="sEnterframe", type="com.flashmastery.as3.blitting.events.SpriteSheetEvent")]

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public class SpriteSheetView extends Sprite {
		
		protected var _spriteSheetStage : SpriteSheetStage;
		protected var _canvas : BitmapData;
		protected var _canvasContainer : Bitmap;
		protected var _backgroundColor : Number = 0xFF000000;//xFFFFFF;
		protected var _renderPoint : Point;
		protected var _containerPosition : Point;
		protected var _renderRect : Rectangle;
		protected var _transparent : Boolean = false;
		protected var _smoothing : Boolean = false;
		protected var _width : Number;
		protected var _height : Number;
		protected var _currentMouseTarget : SpriteSheet;
		protected var _mousePosition : Point;
		protected var _oldMousePosition : Point;
		protected var _mouseMoveEventReceived : Boolean;
		protected var _hasRendered : Boolean;
		
		// mouseGrid
		protected var _mouseSegmentWidth : uint = 100;
		protected var _mouseSegmentHeight : uint = 100;
		protected var _mouseSegments : uint;
		protected var _mouseSegmentsY : uint;
		protected var _mouseSegmentsX : uint;
		protected var _mouseGrid : Vector.<Vector.<SpriteSheet>>;
		protected var _allChildren : Vector.<SpriteSheet>;
//		protected var _allChildrenRects : Vector.<Rectangle>;
		protected var _rectSprite : Sprite;
		protected var _renderStageIndex : uint;
		
		// Performance-Testing
		private var _time : Number = 0;
		private var _runs : Number = 0;

		public function SpriteSheetView() {
			init();
		}

		private function init() : void {
			_renderPoint = new Point();
			_containerPosition = new Point();
			_renderRect = new Rectangle();
			_mousePosition = new Point();
			_oldMousePosition = new Point();
		}

		public function initWithDimensions( width : Number, height : Number, transparent : Boolean = false ) : void {
			_canvas = new BitmapData( width, height, transparent );
			_canvasContainer = Bitmap( addChild( new Bitmap() ) );
			_canvasContainer.bitmapData = _canvas;
			_canvasContainer.smoothing = _smoothing;
			_rectSprite = Sprite( addChild( new Sprite() ) );
			_rectSprite.mouseEnabled = false;
			_rectSprite.visible = false;
			_width = width;
			_height = height;
			_transparent = transparent;
			_renderRect.width = _width;
			_renderRect.height = _height;
			updateMouseGrid();
			addEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
			addEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
			addEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		protected function rollOutHandler( evt : MouseEvent ) : void {
			Mouse.cursor = MouseCursor.AUTO;
			removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			removeEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
			removeEventListener( MouseEvent.CLICK, mouseClickHandler );
			if ( _currentMouseTarget )
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_OUT, _currentMouseTarget, _mousePosition, 0 );
			_currentMouseTarget = null;
		}

		protected function rollOverHandler( evt : MouseEvent ) : void {
			Mouse.cursor = MouseCursor.ARROW;
			addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
			addEventListener( MouseEvent.CLICK, mouseClickHandler );
		}

		protected function mouseMoveHandler( evt : MouseEvent = null ) : void {
//			trace("SpriteSheetView.mouseMoveHandler(evt)");
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _oldMousePosition.x != _mousePosition.x || _oldMousePosition.y != _mousePosition.y ) {
				_oldMousePosition.x = _mousePosition.x;
				_oldMousePosition.y = _mousePosition.y;
				_mouseMoveEventReceived = true;
			}
		}

		protected function mouseClickHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseClick
				dispatchBubblingEvent( SpriteSheetEvent.CLICK, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function mouseWheelHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseWheel
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_WHEEL, _currentMouseTarget, _mousePosition, evt.delta );
			}
		}

		protected function mouseUpHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseUp
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_UP, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function mouseDownHandler( evt : MouseEvent ) : void {
			_mousePosition.x = int( mouseX );
			_mousePosition.y = int( mouseY );
			if ( _currentMouseTarget ) {
				// MouseDown
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_DOWN, _currentMouseTarget, _mousePosition, 0 );
			}
		}

		protected function enterframeHandler( evt : Event ) : void {
			if ( ( _mouseMoveEventReceived || _hasRendered ) && hasEventListener( MouseEvent.MOUSE_MOVE ) ) {
				handleMouseMoveEvent();
				_mouseMoveEventReceived = false;
				_hasRendered = false;
			}
		}

		protected function dispatchBubblingEvent( type : String, target : SpriteSheet, stageCoords : Point, delta : int ) : void {
			var targetParent : SpriteSheetContainer = target.parent;
			var newTarget : SpriteSheet;
			if ( target.mouseEnabled && target.hasEventListener( type ) )
				target.dispatchEvent( new SpriteSheetEvent( type, target, target, target.globalToLocal( stageCoords ), stageCoords, delta ) );
			for ( ; targetParent != null; ) {
				newTarget = targetParent;
				targetParent = newTarget is SpriteSheetStage ? null : newTarget.parent;
				if ( newTarget.mouseEnabled && newTarget.hasEventListener( type ) )
					newTarget.dispatchEvent( new SpriteSheetEvent( type, target, newTarget, newTarget.globalToLocal( stageCoords ), stageCoords, delta ) );
			}
		}
		
		protected function handleMouseMoveEvent() : void {
//			listNumOfRectsAtPosition( _mousePosition ); 
//			var newCurrentTarget : SpriteSheet = newGetCurrentSpriteSheetUnderPoint( _mousePosition );
//			var startTime : int = getTimer();
			var currentTarget : SpriteSheet = getCurrentSpriteSheetUnderPoint( _mousePosition );
//			var currentTarget : SpriteSheet = getCurrentSpriteSheetUnderPoint( _spriteSheetStage, _mousePosition );
//			var endTime : int = getTimer();
//			checkPerformance( endTime - startTime );
//			trace("SpriteSheetView.handleMouseMoveEvent()", currentTarget, currentTarget ? currentTarget.name : null);
//			trace("SpriteSheetView.handleMouseMoveEvent()", newCurrentTarget == currentTarget, currentTarget, newCurrentTarget );
			if ( _currentMouseTarget != currentTarget ) {
				// MouseOver / MouseOut
				if ( _currentMouseTarget )
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_OUT, _currentMouseTarget, _mousePosition, 0 );
				Mouse.cursor = MouseCursor.ARROW;
				_currentMouseTarget = currentTarget;
				if ( _currentMouseTarget ) {
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_OVER, _currentMouseTarget, _mousePosition, 0 );
					dispatchBubblingEvent( SpriteSheetEvent.MOUSE_MOVE, _currentMouseTarget, _mousePosition, 0 );
					if ( _currentMouseTarget.useHandCursor && _currentMouseTarget.mouseEnabled ) {
						Mouse.cursor = MouseCursor.BUTTON;
//						trace("SpriteSheetView.mouseMoveHandler(evt)", Mouse.cursor);
					}
				}
			} else {
				// MouseMove
				dispatchBubblingEvent( SpriteSheetEvent.MOUSE_MOVE, _currentMouseTarget || _spriteSheetStage, _mousePosition, 0 );
			}
		}

//		private function listNumOfRectsAtPosition( coords : Point ) : void {
//			const wSegmentIndex : int = Math.floor( coords.x / _mouseSegmentWidth );
//			const hSegmentIndex : int = Math.floor( coords.y / _mouseSegmentHeight );
//			const segmentIndex : int = hSegmentIndex * _mouseSegmentsX + wSegmentIndex;
//			const segmentList : Vector.<SpriteSheet> = _mouseGrid.length > segmentIndex ? _mouseGrid[ segmentIndex ] : null;
//			trace("SpriteSheetView.listNumOfRectsAtPosition(coords)", coords, segmentList.length );
//		}
		
		protected function getCurrentSpriteSheetUnderPoint( stageCoords : Point ) : SpriteSheet {
			const wSegmentIndex : int = Math.floor( stageCoords.x / _mouseSegmentWidth );
			const hSegmentIndex : int = Math.floor( stageCoords.y / _mouseSegmentHeight );
			var segmentIndex : int = hSegmentIndex * ( _mouseSegmentsX - 1 ) + wSegmentIndex;
//			trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(stageCoords)", wSegmentIndex, hSegmentIndex, segmentIndex);
			const segmentList : Vector.<SpriteSheet> = _mouseGrid.length > segmentIndex ? _mouseGrid[ segmentIndex ] : null;
			if ( segmentList && segmentList.length > 0 ) {
//				trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(stageCoords)", segmentList);
				segmentIndex = segmentList.length;
				var sprite : SpriteSheet;
				const sortedRects : Array = [];
				while ( --segmentIndex > -1 )
					sortedRects.push( segmentList[ int( segmentIndex ) ] );
				sortedRects.sortOn( "bStageIndex", Array.NUMERIC );
				segmentIndex = segmentList.length;
				while ( --segmentIndex > -1 ) {
					sprite = sortedRects[ int( segmentIndex ) ];
					if ( sprite && sprite.bStageRect.containsPoint( stageCoords ) ) {
						sprite = getSpriteByRectAndStageCoords( sprite, stageCoords );
						if ( sprite ) return sprite;
					}
					sprite = null;
				}
			}
			return null;
		}

		private function getSpriteByRectAndStageCoords( sprite : SpriteSheet, stageCoords : Point ) : SpriteSheet {
			var parentSprite : SpriteSheetContainer;
			if ( sprite.hitsPointOfBitmap( sprite.globalToLocal( stageCoords ) ) ) {
//				trace("SpriteSheetView.getSpriteByRectAndStageCoords(sprite, stageCoords)", sprite.name, "hitsBitmap");
				if ( sprite.mouseEnabled )
					return sprite;
				else if ( sprite.parent ) {
					parentSprite = sprite.parent;
					while ( !parentSprite.mouseEnabled && !( parentSprite is SpriteSheetStage ) ) {
						parentSprite = parentSprite.parent;
					}
//					trace("SpriteSheetView.getSpriteByRectAndStageCoords(sprite, stageCoords)", parentSprite.name, "returns parent");
					return parentSprite;
				}
			}
			return null;
		}

//		protected function getCurrentSpriteSheetUnderPoint( container : SpriteSheet, point : Point ) : SpriteSheet {
////			trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)");
//			var sprite : SpriteSheet;
//			var children : Vector.<SpriteSheet>;
//			var childrenLength : int;
////			trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", Object( container ).constructor, container.mouseEnabled, container.getRectByCoords( _spriteSheetStage ), container.getRectByCoords( _spriteSheetStage ).containsPoint( point ), point);
//			if ( container.mouseEnabled && container.getRectByCoords( _spriteSheetStage ).containsPoint( point ) ) {
////				trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", container.name, " - mouseEnabled, containsPoint");
//				if ( container is SpriteSheetContainer && SpriteSheetContainer( container ).numChildren > 0 && SpriteSheetContainer( container ).mouseChildren ) {
////					trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", container.name, " - SpriteSheetContainer, mouseChildren");
//					children = SpriteSheetContainer( container ).children;
//					childrenLength = children.length;
//					while( --childrenLength > -1 ) {
//						sprite = children[ int( childrenLength ) ];
//						sprite = getCurrentSpriteSheetUnderPoint( sprite, point );
//						if ( sprite && sprite.hitsPointOfBitmap( sprite.globalToLocal( point ) ) ) {
////							trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", sprite.name, " - hitsPointOfBitmap");
//							return sprite;
//						}
//						else if ( sprite is SpriteSheetContainer && !SpriteSheetContainer( sprite ).mouseChildren && SpriteSheetContainer( container ).hitsPoint( container.globalToLocal( point ) ) ) {
////							trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", sprite.name, " - SpriteSheetContainer, mouseChildren, hitsPoint");
//							return sprite;
//						}
////						trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point) - sprite is", sprite);
//					}
//				} else if ( container is SpriteSheetContainer && SpriteSheetContainer( container ).hitsPoint( container.globalToLocal( point ) ) ) {
////					trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", container.name, " - SpriteSheetContainer, hitsPoint");
//					return container;
//				}
//				else if ( container.hitsPointOfBitmap( container.globalToLocal( point ) ) ) {
////					trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point)", container.name, " - hitsPointOfBitmap");
//					return container;
//				}
////				trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point) -->", container.name, " - SpriteSheetContainer,", container is SpriteSheetContainer, ", hitsPoint", SpriteSheetContainer( container ).hitsPoint( container.globalToLocal( point ) ));
////				trace("SpriteSheetView.getCurrentSpriteSheetUnderPoint(container, point) -->", container.name, " - hitsPointOfBitmap", container.hitsPointOfBitmap( container.globalToLocal( point ) ));
//			}
//			return null;
//		}

		/***********************************************************************
		 * Mouse detection
		 **********************************************************************/
		protected function resetRectangles() : void {
			initChildren();
			if ( _spriteSheetStage ) initStageRectangles();
		}

		protected function updateMouseGrid() : void {
			_mouseSegmentsX = Math.ceil( width / _mouseSegmentWidth );
			_mouseSegmentsY = Math.ceil( height / _mouseSegmentHeight );
			_mouseSegments = _mouseSegmentsX * _mouseSegmentsY;
			_mouseGrid = new Vector.<Vector.<SpriteSheet>>( _mouseSegments, true );
			var numSegments : int = _mouseSegments;
//			var segmentX : int;
//			var segmentY : int;
//			_rectSprite.graphics.lineStyle( 1, 0x3333FF );
			while ( --numSegments > -1 ) {
//				segmentX = numSegments % _mouseSegmentsX;
//				segmentY = ( numSegments - segmentX ) / _mouseSegmentsX;
//				_rectSprite.graphics.drawRect(_mouseSegmentWidth * segmentX, _mouseSegmentHeight * segmentY, _mouseSegmentWidth, _mouseSegmentHeight );
				_mouseGrid[ int( numSegments ) ] = new Vector.<SpriteSheet>();
			}
			updateRectangles();
		}
		
		protected function initStageRectangles() : void {
			if ( _spriteSheetStage )
				addSprites( _spriteSheetStage );
		}

		protected function updateRectangles() : void {
			if ( _allChildren && _allChildren.length > 0 ) {
				var indexOfChild : int = _allChildren.length;
				var child : SpriteSheet;
				while ( --indexOfChild > -1 ) {
					child = _allChildren[ int ( indexOfChild ) ];
					if ( child.bitmapData )
						addChildToMouseGrid( _allChildren[ int( indexOfChild ) ] );
				}
			}
		}
		
		protected function addChildToMouseGrid( child : SpriteSheet ) : void {
//			trace("SpriteSheetView.addChildToMouseGrid(child)", child.name);
			const rect : Rectangle = child.bStageRect;
//			_rectSprite.graphics.lineStyle( 1, 0xFF0000 );
//			_rectSprite.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
//			trace("SpriteSheetView.addRectToMouseGrid(rect)", rect);
			const rTop : int = rect.top > 0 ? ( rect.top < _height ? rect.top : _height ) : 0;
			const rBottom : int = rect.bottom > 0 ? ( rect.bottom < _height ? rect.bottom : _height ) : 0;
			const rRight : int = rect.right > 0 ? ( rect.right < _width ? rect.right : _width ) : 0;
			const rLeft : int = rect.left > 0 ? ( rect.left < _width ? rect.left : _width ) : 0;
			const rWidth : int = rRight - rLeft;
			const rHeight : int = rBottom - rTop;
//			trace("SpriteSheetView.addRectToMouseGrid(rect)", rWidth, rHeight);
			if ( rWidth > 0 && rHeight > 0 ) {
				const mTopIndex : int = Math.floor( rTop / _mouseSegmentHeight );
				var mBottomIndex : int = Math.floor( rBottom / _mouseSegmentHeight ) +1;
				var mRightIndex : int = Math.floor( rRight / _mouseSegmentWidth ) + 1;
				const mRightConst : int = mRightIndex;
				const mLeftIndex : int = Math.floor( rLeft / _mouseSegmentWidth );
				var segmentList : Vector.<SpriteSheet>;
				var segmentIndex : int;
//				trace("SpriteSheetView.addRectToMouseGrid(rect)", mLeftIndex, mTopIndex, mRightIndex, mBottomIndex);
				while ( --mBottomIndex >= mTopIndex ) {
					while ( --mRightIndex >= mLeftIndex ) {
//						trace("SpriteSheetView.addChildToMouseGrid(child)", mRightIndex, mBottomIndex);
						segmentIndex = mBottomIndex * ( _mouseSegmentsX - 1 ) + mRightIndex;
						if ( segmentIndex < _mouseSegments ) {
							segmentList = _mouseGrid[ int( segmentIndex ) ];
							if ( segmentList.indexOf( child ) < 0 )
								segmentList.push( child );
						}
					}
					mRightIndex = mRightConst;
				}
			}
		}

		protected function removeChildFromMouseGrid( child : SpriteSheet ) : void {
			var indexOfSegment : int = _mouseGrid.length;
			var segment : Vector.<SpriteSheet>;
			var index : int;
			while ( --indexOfSegment > -1 ) {
				segment = _mouseGrid[ int( indexOfSegment ) ];
				index = segment.indexOf( child );
				while ( index > -1 ) {
					segment.splice( index, 1 );
					index = segment.indexOf( child );
				}
			}
		}

		protected function initChildren() : void {
			_allChildren = new Vector.<SpriteSheet>();
		}
		
		protected function addSprites( container : SpriteSheetContainer ) : void {
			var indexOfChild : int = container.numChildren;
			var child : SpriteSheet;
			var index : int;
			while ( --indexOfChild > -1 ) {
				child = container.getChildAt( indexOfChild );
				index = _allChildren.indexOf( child );
				if ( index == -1 ) {
					_allChildren.push( child );
					child.bStageRect = child.getRectByCoords( _spriteSheetStage );
					if ( child.bitmapData )
						addChildToMouseGrid( child );
				} else {
					removeChildFromMouseGrid( child );
					child.bStageRect = child.getRectByCoords( _spriteSheetStage );
					if ( child.bitmapData )
						addChildToMouseGrid( child );
				}
				if ( child is SpriteSheetContainer )
					addSprites( SpriteSheetContainer( child ) );
			}
		}
		
		protected function removeSprites( container : SpriteSheetContainer ) : void {
			var indexOfChild : int = container.numChildren;
			var child : SpriteSheet;
			var index : int;
			while ( --indexOfChild > -1 ) {
				child = container.getChildAt( indexOfChild );
				index = _allChildren.indexOf( child );
				if ( index > -1 ) {
					removeChildFromMouseGrid( child );
					_allChildren.splice( index, 1 );
				}
				if ( child is SpriteSheetContainer )
					removeSprites( SpriteSheetContainer( child ) );
			}
		}
		
		/***********************************************************************
		 * Rendering
		 **********************************************************************/
		public function render() : void {
//			_rectSprite.graphics.clear();
			if ( hasEventListener( SpriteSheetEvent.ENTER_FRAME ) )
				dispatchEvent( new SpriteSheetEvent(SpriteSheetEvent.ENTER_FRAME ) );
			_spriteSheetStage.updateBeforRender();
			_renderStageIndex = 0;
//			trace("SpriteSheetView.render()", _spriteSheetStage.updated);
			if ( _spriteSheetStage.updated ) {
//				trace("SpriteSheetView.render()");
				_canvas.lock();
				_canvas.fillRect( _canvas.rect, _backgroundColor );
				_containerPosition.x = _containerPosition.y = 0;
				if ( _spriteSheetStage )
					renderSpriteSheet( _canvas, _spriteSheetStage, _containerPosition );
				_canvas.unlock();
				_hasRendered = true;
			}
			_spriteSheetStage.updateAfterRender();
		}

		protected function renderSpriteSheet( canvas : BitmapData, spriteSheet : SpriteSheet, containerPosition : Point ) : void {
			_renderPoint.x = containerPosition.x + spriteSheet.x + spriteSheet.registrationOffsetX;
			_renderPoint.y = containerPosition.y + spriteSheet.y + spriteSheet.registrationOffsetY;
			spriteSheet.bStageIndex = _renderStageIndex++;
			if ( !spriteSheet.visible ) return;
//			spriteSheet.updateForRender();
			if ( spriteSheet.bitmapData ) {
				_renderRect.width = spriteSheet.bitmapData.width;
				_renderRect.height = spriteSheet.bitmapData.height;
				canvas.copyPixels( spriteSheet.bitmapData, _renderRect, _renderPoint, null, null, _canvas.transparent );
			}
			if ( spriteSheet is SpriteSheetContainer ) {
				var children : Vector.<SpriteSheet> = SpriteSheetContainer( spriteSheet ).children;
				var numSprites : int = children.length;
				var spritePosition : Point = new Point();
				spritePosition.x = containerPosition.x + spriteSheet.x + spriteSheet.registrationOffsetX;
				spritePosition.y = containerPosition.y + spriteSheet.y + spriteSheet.registrationOffsetY;
				for ( var i : int = 0; i < numSprites; i++ ) {
					renderSpriteSheet( canvas, children[ int( i ) ], spritePosition );
				}
			}
		}

		public function get spriteSheetStage() : SpriteSheetStage {
			return _spriteSheetStage;
		}

		public function set spriteSheetStage( spriteSheetStage : SpriteSheetStage ) : void {
			if ( _spriteSheetStage != spriteSheetStage ) {
				if ( _spriteSheetStage ) _spriteSheetStage.view = null;
				_spriteSheetStage = spriteSheetStage;
				_spriteSheetStage.view = this;
				resetRectangles();
			}
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set width( width : Number ) : void {
			_width = width;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
			updateMouseGrid();
		}

		override public function get height() : Number {
			return _height;
		}

		override public function set height( height : Number ) : void {
			_height = height;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
			updateMouseGrid();
		}

		public function get transparent() : Boolean {
			return _transparent;
		}

		public function set transparent( transparent : Boolean ) : void {
			_transparent = transparent;
			if ( _canvas ) _canvas.dispose();
			_canvas = new BitmapData( _width, _height, _transparent );
			_canvasContainer.bitmapData = _canvas;
		}

		public function get backgroundColor() : Number {
			return _backgroundColor;
		}

		public function set backgroundColor( backgroundColor : Number ) : void {
			_backgroundColor = backgroundColor;
		}

		public function get smoothing() : Boolean {
			return _smoothing;
		}

		public function set smoothing( smoothing : Boolean ) : void {
			_smoothing = smoothing;
			_canvasContainer.smoothing = _smoothing;
		}
		
		override public function set mouseChildren( enable : Boolean ) : void {
			super.mouseChildren = enable;
		}
		
		override public function set mouseEnabled( enabled : Boolean ) : void {
			super.mouseEnabled = enabled;
		}

		public function get canvas() : BitmapData {
			return _canvas;
		}

//		private function checkPerformance( time : int ) : void {
//			_time += time;
//			_runs++;
//			trace( "SpriteSheetView.checkPerformance(time)\t", Math.round( _time / _runs ), "\t", time );
//		}

		public function get mouseSegmentWidth() : uint {
			return _mouseSegmentWidth;
		}

		public function get mouseSegmentHeight() : uint {
			return _mouseSegmentHeight;
		}
		
		public function setMouseSegmentSizes( width : uint, height : uint ) : void {
			if ( _mouseSegmentWidth != width || _mouseSegmentHeight != height ) {
				_mouseSegmentWidth = width;
				_mouseSegmentHeight = height;
				updateMouseGrid();
				if ( _spriteSheetStage ) updateRectangles();
			}
		}
		
		public function bAddChildToStage( child : SpriteSheet ) : void {
			const childIndex : int = _allChildren.indexOf( child );
			const container : SpriteSheetContainer = (child as SpriteSheetContainer);
			if ( childIndex < 0 ) {
				_allChildren.push( child );
				child.bStageRect = child.getRectByCoords( _spriteSheetStage );
				if ( child.bitmapData )
					addChildToMouseGrid( child );
				if ( container )
					addSprites( container );
			} else bUpdateChildOnStage( child );
		}

		protected function getStageIndex( child : SpriteSheet ) : int {
			var containerIndex : uint = 0;
			var indices : Vector.<int> = new Vector.<int>();
			var parentSprite : SpriteSheetContainer = child.parent;
			if ( parentSprite ) {
				const childIndex : uint = parentSprite.getChildIndex( child );
				var childDepth : int = 1;
				indices.push( childIndex );
				while ( parentSprite.parent ) {
					childDepth++;
					indices.push( parentSprite.parent.getChildIndex( parentSprite ) );
					parentSprite = parentSprite.parent;
				}
				while ( --childDepth > -1 ) {
					containerIndex += Math.pow( 2, 24 - childDepth );
				}
				return containerIndex + childIndex;
			}
			return 0;
		}
		
		public function bRemoveChildFromStage( child : SpriteSheet ) : void {
			const childIndex : int = _allChildren.indexOf( child );
			const container : SpriteSheetContainer = (child as SpriteSheetContainer);
			if ( childIndex >= 0 ) {
				removeChildFromMouseGrid( child );
				child.bStageRect = null;
				child.bStageIndex = -1;
				_allChildren.splice( childIndex, 1 );
				if ( container )
					removeSprites( container );
			}
		}
		
		public function bUpdateChildOnStage( child : SpriteSheet ) : void {
			// remove rect(s) from mouseGrid
			// update rect(s)
			// reset rect(s) tp mouseGrid
			const newStageRect : Rectangle = child.getRectByCoords( _spriteSheetStage );
			const stageRect : Rectangle = child.bStageRect;
			if ( stageRect == null || newStageRect.width != stageRect.width || newStageRect.height != stageRect.height || newStageRect.x != stageRect.x || newStageRect.y != stageRect.y ) {
				bRemoveChildFromStage( child );
				bAddChildToStage( child );
			}
		}
	}
}
