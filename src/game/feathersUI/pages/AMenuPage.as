package game.feathersUI.pages {
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	import starling.events.Event;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import org.osflash.signals.Signal;
	import game.feathersUI.PixelSphereTheme;
	import game.feathersUI.GameMenu;
	import game.feathersUI.util.StarlingGraphicsUtils;
	
	/**
	 * ...
	 * @author Alex
	 *
	 * Subclass AMenuPage and fill them with your content.
	 * Your subclass will draw content in the ContentContainer and dispatch settingChangedSignal when a UI
	 * control is updated, so that the GameSettingsManager may listen and propagate those messages.
	 */
	public class AMenuPage extends Screen
	{
		private var _externalSettingChangedSignal:Signal;	// this page will listen for this signal to update the GUI control for a particular setting.
		private var _header:Header;
		
		protected var w:int = 0; 				// the proposed width of a page from GameMenu
		protected var h:int = 0; 				// the proposed hight of a page from GameMenu
		protected var headerText:String; 		// Header text
		protected var contentContainer:Sprite; 	// Add DisplayObjects to here in your subclass
		protected var contentHeight:int; 		// exact size of the contentContainer
		protected var contentWidth:int; 		// exact size of the contentContainer
		
		/**
		 * @usage
		 * Your subclass will dispatch this event whenever a setting is changed.
		 * Note that if a Control's "changed" method is triggered by changing a setting externally, 
		 * it may appear to external observers to be a double-firing of the signal.
		 */
		public var settingChangedSignal:Signal = new Signal(String, Object, Boolean); // [name, data, close menu]
		
		public function AMenuPage(headerText:String) {
			this.headerText = headerText;
			this.w 			= GameMenu.menuItemWidth;
			this.h 			= GameMenu.menuItemHeight;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private function initializeHandler(e:Event):void {
			initPage(); // Build shared page attributes (header, content container, background)
			drawPage(); // Override this function in your subclass to draw content within the contentContainer
		}
		
		private function initPage():void {
			// [============[ Header ]============]
			var headerHeight:int = 35;
			_header = new Header();
			_header.width = w;
			_header.height = headerHeight;
			_header.title = headerText;
			_header.nameList.add(PixelSphereTheme.ALTERNATE_NAME_HEADER);
			
			// [============[ Close Button (X) ]============]
			var closeButton:Button = new Button();
			closeButton.height = headerHeight;
			closeButton.addEventListener(Event.TRIGGERED, handleCloseButton);
			closeButton.nameList.add(PixelSphereTheme.ALTERNATE_NAME_CLOSE_BUTTON);
			
			_header.rightItems = new <DisplayObject>[closeButton];
			_header.paddingRight = _header.paddingLeft = 0;
			_header.gap = 0;
			
			addChild(_header);
			_header.validate(); // so you can position the contentContainer
			
			// [============[ Create and position contentContainer ]============]
			contentContainer 	= new Sprite();
			contentContainer.y 	= _header.height;
			contentWidth 		= w;
			contentHeight 		= h - _header.height;
			addChild(contentContainer);
			
			// [============[ Make Quad / Background texture ]============]
			var bg:Quad = StarlingGraphicsUtils.getGradientQuad(contentWidth, contentHeight, 0x000000, 0x343434, 0.84);
			contentContainer.addChild(bg);
		}
		
		private function handleCloseButton(e:Event):void {
			GameMenu.instance.toggleMenuVisibility();
		}
		
		/**
		 * @usage 
		 * Override drawPage() in your subclass and add Feathers controls to the contentContainer
		 */
		protected function drawPage():void { }
		
		/**
		 * @usage 
		 * Override handleExternalSettingChange() in your subclass to update GUI controls when a setting is changed externally.
		 */
		protected function handleExternalSettingChange(name:String, data:Object):void { }
		
		/**
		 * @usage 
		 * GameMenu.as will set this Signal to provide updates on settings changes.
		 */
		public function set externalSettingChangedSignal(value:Signal):void {
			if (!_externalSettingChangedSignal) {
				_externalSettingChangedSignal = value;
				_externalSettingChangedSignal.add(handleExternalSettingChange);
			}
		}
	}
}