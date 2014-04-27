/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.controls.Scroller;

	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.utils.MatrixUtil;

	/**
	 * A text editor view port for the <code>TextArea</code> component that uses
	 * <code>flash.text.TextField</code>.
	 *
	 * @see feathers.controls.TextArea
	 */
	public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
	{
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function TextFieldTextEditorViewPort()
		{
			super();
			this.multiline = true;
			this.wordWrap = true;
		}

		/**
		 * @private
		 */
		private var _minVisibleWidth:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		/**
		 * @private
		 */
		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		/**
		 * @inheritDoc
		 */
		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		/**
		 * @private
		 */
		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _visibleWidth:Number = NaN;

		/**
		 * @inheritDoc
		 */
		public function get visibleWidth():Number
		{
			return this._visibleWidth;
		}

		/**
		 * @private
		 */
		public function set visibleWidth(value:Number):void
		{
			if(this._visibleWidth == value || (isNaN(value) && isNaN(this._visibleWidth)))
			{
				return;
			}
			this._visibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _minVisibleHeight:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		/**
		 * @private
		 */
		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		/**
		 * @inheritDoc
		 */
		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		/**
		 * @private
		 */
		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _visibleHeight:Number = NaN;

		/**
		 * @inheritDoc
		 */
		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		/**
		 * @private
		 */
		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value || (isNaN(value) && isNaN(this._visibleHeight)))
			{
				return;
			}
			this._visibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _scrollStep:int = 0;

		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollStep():Number
		{
			return this._scrollStep;
		}

		/**
		 * @inheritDoc
		 */
		public function get verticalScrollStep():Number
		{
			return this._scrollStep;
		}

		/**
		 * @private
		 */
		private var _horizontalScrollPosition:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		private var _verticalScrollPosition:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @inheritDoc
		 */
		override public function setFocus(position:Point = null):void
		{
			if(position)
			{
				position.x += this._horizontalScrollPosition;
				position.y += this._verticalScrollPosition;
			}
			super.setFocus(position);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();
			this.textField.mouseWheelEnabled = false;
		}

		/**
		 * @private
		 */
		override protected function refreshSnapshotParameters():void
		{
			var textFieldWidth:Number = this._visibleWidth;
			if(isNaN(textFieldWidth))
			{
				if(this._maxVisibleWidth < Number.POSITIVE_INFINITY)
				{
					textFieldWidth = this._maxVisibleWidth;
				}
				else
				{
					textFieldWidth = this._minVisibleWidth;
				}
			}
			var textFieldHeight:Number = this._visibleHeight;
			if(isNaN(textFieldHeight))
			{
				if(this._maxVisibleHeight < Number.POSITIVE_INFINITY)
				{
					textFieldHeight = this._maxVisibleHeight;
				}
				else
				{
					textFieldHeight = this._minVisibleHeight;
				}
			}

			const clipContent:Boolean = Scroller(this.parent).clipContent;

			this._textFieldOffsetX = 0;
			this._textFieldOffsetY = 0;
			this._textFieldClipRect.x = 0;
			this._textFieldClipRect.y = 0;
			this._textFieldClipRect.width = textFieldWidth;
			this._textFieldClipRect.height = clipContent ? textFieldHeight : this.actualHeight;

			if(clipContent)
			{
				var scrollRect:Rectangle = this.textField.scrollRect;
				if(!scrollRect)
				{
					scrollRect = new Rectangle();
				}
				scrollRect.x = this._horizontalScrollPosition;
				scrollRect.y = this._verticalScrollPosition;
				scrollRect.width = textFieldWidth;
				scrollRect.height = textFieldHeight;
				this.textField.scrollRect = scrollRect;
			}
			else
			{
				this.textField.scrollRect = null;
			}
		}

		/**
		 * @private
		 */
		override protected function commitStylesAndData():void
		{
			super.commitStylesAndData();
			this._scrollStep = this.textField.getLineMetrics(0).height;
		}

		/**
		 * @private
		 */
		override protected function positionTextField():void
		{
			HELPER_POINT.x = HELPER_POINT.y = 0;
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
			const clipContent:Boolean = Scroller(this.parent).clipContent;
			const offsetX:Number = clipContent ? Math.round(this._horizontalScrollPosition) : 0;
			const offsetY:Number = clipContent ? Math.round(this._verticalScrollPosition) : 0;
			if(HELPER_POINT.x != this._oldGlobalX || HELPER_POINT.y != this._oldGlobalY)
			{
				this._oldGlobalX = HELPER_POINT.x;
				this._oldGlobalY = HELPER_POINT.y;
				const starlingViewPort:Rectangle = Starling.current.viewPort;
				this.textField.x = offsetX + Math.round(starlingViewPort.x + (HELPER_POINT.x * Starling.contentScaleFactor));
				this.textField.y = offsetY + Math.round(starlingViewPort.y + (HELPER_POINT.y * Starling.contentScaleFactor));
			}

			if(this.textSnapshot)
			{
				this.textSnapshot.x = offsetX + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
				this.textSnapshot.y = offsetY + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
			}
		}

		/**
		 * @private
		 */
		override protected function checkIfNewSnapshotIsNeeded():void
		{
			super.checkIfNewSnapshotIsNeeded();
			this._needsNewBitmap ||= this.isInvalid(INVALIDATION_FLAG_SCROLL);
		}

	}
}
