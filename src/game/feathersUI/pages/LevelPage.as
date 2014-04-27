package game.feathersUI.pages {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import game.feathersUI.GameMenu;
	import game.feathersUI.PixelSphereTheme;
	import game.feathersUI.util.GameMenuGraphicsProvider;

	public class LevelPage extends AMenuPage
	{
		public function LevelPage(titleText:String) { super(titleText); }
		private var _iconAtlas:TextureAtlas;
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var _pageCount:int;
		private var leftButton:Button;
		private var rightButton:Button;
		private var levelListContainer:Sprite;
		private var buttonsPadding:int = 50;
		private var levelButton:Button;
		private var scrollAnimationDuration:Number = 0.6;

		override protected function drawPage():void {
			leftButton = new Button();
			rightButton = new Button();
			makeContainer();
			buildLevelSelector();
			makeNavButtons();
		}
		
		private function makeContainer():void {
			levelListContainer = new Sprite();
			contentContainer.addChild(levelListContainer);
			levelListContainer.y = 35;
		}
		
		private function makeNavButtons():void {
			leftButton.label = "<";
			leftButton.addEventListener(Event.TRIGGERED, handleLeftButton);
			leftButton.nameList.add(PixelSphereTheme.ALTERNATE_NAME_NAV_BUTTON);
			leftButton.x = 10;
			addChild(leftButton);
			
			rightButton.label = ">";
			rightButton.addEventListener(Event.TRIGGERED, handleRightButton);
			rightButton.nameList.add(PixelSphereTheme.ALTERNATE_NAME_NAV_BUTTON);
			addChild(rightButton);
			rightButton.x = 80;
			rightButton.height = leftButton.height = 32;
		}
		
		private function handleLeftButton(e:Event):void {
			var i:int = this._list.horizontalPageIndex;
			i--;
			if (i < 0) i = 0;
			this._list.scrollToPageIndex(i, 0, scrollAnimationDuration);
			settingChangedSignal.dispatch("GUIItemChanged", i, false);
		}
		
		private function handleRightButton(e:Event):void {
			var i:int = this._list.horizontalPageIndex;
			i++;
			if (i >= _pageCount) i = _pageCount -1;
			this._list.scrollToPageIndex(i, 0, scrollAnimationDuration);
			settingChangedSignal.dispatch("GUIItemChanged", i, false);
		}


		protected function layout():void { // called whenever doing a redraw
			this.w = contentWidth;
			this.h = contentHeight;
			this._pageIndicator.width = w;
			this._pageIndicator.validate();
			this._pageIndicator.y = contentHeight - 25//this.stage.stageHeight - this._pageIndicator.height - 300;
			const shorterSide:Number = h;// Math.min(this.stage.stageWidth, this.stage.stageHeight);
			const layout:TiledRowsLayout = TiledRowsLayout(this._list.layout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = shorterSide * 0.02;
			layout.gap = shorterSide * 0.02;
			this._list.itemRendererProperties.gap = shorterSide * 0.01;
			this._list.width = w;
			this._list.height = this._pageIndicator.y;
			this._list.validate();
			_pageCount = this._pageIndicator.pageCount = Math.ceil(this._list.maxHorizontalScrollPosition / this._list.width) + 1;
		}

		protected function buildLevelSelector():void {
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this._iconAtlas = GameMenuGraphicsProvider.instance.primaryTextureAtlas;
			const collection:ListCollection = new ListCollection( // this is the dataprovider for the list
			[
				{ label: "Intro", texture: this._iconAtlas.getTexture("level00") },
				{ label: "One", texture: this._iconAtlas.getTexture("level01") },
				{ label: "Two", texture: this._iconAtlas.getTexture("level02") },
				{ label: "Three", texture: this._iconAtlas.getTexture("level03") },
				{ label: "Four", texture: this._iconAtlas.getTexture("level04") },
				{ label: "Five", texture: this._iconAtlas.getTexture("level05") },
				{ label: "Six", texture: this._iconAtlas.getTexture("level06") },
				{ label: "Seven", texture: this._iconAtlas.getTexture("level07") },
				{ label: "Eight", texture: this._iconAtlas.getTexture("level08") },
				{ label: "Nine", texture: this._iconAtlas.getTexture("level09") },
				{ label: "Ten", texture: this._iconAtlas.getTexture("level10") },
				{ label: "Eleven", texture: this._iconAtlas.getTexture("level11") },
				{ label: "Twelve", texture: this._iconAtlas.getTexture("level12") },
				{ label: "Thirteen", texture: this._iconAtlas.getTexture("level13") },
				{ label: "Fourteen", texture: this._iconAtlas.getTexture("level14") },
				{ label: "Fifteen", texture: this._iconAtlas.getTexture("level15") },
				{ label: "Sixteen", texture: this._iconAtlas.getTexture("level16") },
				{ label: "Seventeen", texture: this._iconAtlas.getTexture("level17") },
				{ label: "Eighteen", texture: this._iconAtlas.getTexture("level18") },
				{ label: "Nineteen", texture: this._iconAtlas.getTexture("level19") },
				{ label: "Twenty", texture: this._iconAtlas.getTexture("level20") },
				{ label: "Twenty-one", texture: this._iconAtlas.getTexture("level21") },
				{ label: "Twenty-two", texture: this._iconAtlas.getTexture("level22") },
			]);

			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			this._list = new List();
			this._list.dataProvider = collection;
			this._list.layout = listLayout;
			this._list.scrollerProperties.snapToPages = true;
			this._list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this._list.scrollerProperties.interactionMode = Scroller.INTERACTION_MODE_TOUCH;
			this._list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			this._list.addEventListener(Event.CHANGE, list_changeHandler );
			this._list.addEventListener(Event.SELECT, list_triggeredHandler );
			this._list.isSelectable = true;
			levelListContainer.addChild(this._list);

			const normalSymbolTexture:Texture = this._iconAtlas.getTexture("normal-page-symbol");
			const selectedSymbolTexture:Texture = this._iconAtlas.getTexture("selected-page-symbol");
			
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.normalSymbolFactory = function():Image{return new Image(normalSymbolTexture);}
			this._pageIndicator.selectedSymbolFactory = function():Image{return new Image(selectedSymbolTexture);}
			this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			this._pageIndicator.pageCount = 1;
			this._pageIndicator.gap = 3;
			this._pageIndicator.paddingTop = this._pageIndicator.paddingRight = this._pageIndicator.paddingBottom =
			this._pageIndicator.paddingLeft = 6;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			levelListContainer.addChild(this._pageIndicator);
			this.layout();
		}
		
		private function list_triggeredHandler(e:Event):void { } // when an item is selected
		
		private function list_changeHandler( event:Event ):void {
			var list:List = List( event.currentTarget );
			var i:int = list.selectedIndex;
			list.selectedIndex = -1; // reset the selection, so you can click one next time...
			if (i >= 0) {
				settingChangedSignal.dispatch("Level", i, false);
				settingChangedSignal.dispatch("LevelChanged", i, true); // 3rd param true will close the GameMenu
			}
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer {
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.nameList.add( PixelSphereTheme.ALTERNATE_NAME_LEVEL_MENU );
			return renderer;
		}

		protected function list_scrollHandler(event:Event):void {
			var i:int = this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
			if (i == 0) leftButton.isEnabled = false;
			else if (i >= _pageCount -1) rightButton.isEnabled = false;
			else {
				leftButton.isEnabled = true;
				rightButton.isEnabled = true;
			}
		}

		protected function pageIndicator_changeHandler(event:Event):void {
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, 0.25);
		}

		protected function stage_resizeHandler(event:ResizeEvent):void { } // AS: no this messes it up good :) //this.layout(); // dont do this!
	}
}
