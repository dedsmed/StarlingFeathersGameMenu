package game.feathersUI {
	import game.feathersUI.pages.CreditsPage;
	import game.feathersUI.pages.SettingsPage;
	import game.feathersUI.pages.LevelPage;
	import game.feathersUI.pages.StatsPage;
	import game.feathersUI.pages.TitlePage;
	import game.feathersUI.pages.DebugPage;
	import game.feathersUI.menu.MenuItem;
	import game.feathersUI.menu.MenuButtons;
	import game.feathersUI.menu.MenuContents;
	import game.feathersUI.util.StarlingGraphicsUtils;
	import game.feathersUI.PixelSphereTheme;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import feathers.controls.Screen;
	import feathers.controls.Button;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author Alex
	 * 
	 * The GameMenu displays a navigation bar for various Pages you create extending /pages/AMenuPage.as
	 * When you subclass AMenuPage for your pages, you get a layout, header and close button as well
	 * as communication to and from your game via the GameSettingsManager.
	 * 
	 * To add more pages to your menu, add them to the menuItems array, and this class will add a
	 * navigation button and the page to the ScreenManager.
	 * 
	 * Note:
		 * GameMenu and GameSettingsManager are meant to be created once and never destroyed.
		 * This version uses FeathersUI 1.1 Beta for Starling
	 */
	public class GameMenu extends Sprite {
		public static var menuItemHeight:int 	= 0;
		public static var menuItemWidth:int 	= 0;
		
		private static var _instance:GameMenu; // Has public getter. Used by AMenuPage to easily access toggleVisibility, width and height etc...
		
		/**
		 * @usage 
		 * Connect to this signal externally for updates when any setting is changed within the GameMenu GUI
		 * 
		 */
		public var settingChanged:Signal = new Signal(String, Object); // [name, data]
		private var theme:PixelSphereTheme;
		private var menuButton:Button;
		private var mainMenu:MenuButtons;
		private var menuItems:Array = [];
		private var w:int;
		private var h:int;
		private var widthRatio:Number;
		private var menuPadding:int;
		private var menuHeight:int;
		private var menuWidth:int;
		private var slave:MenuContents;
		private var overlay:Quad;
		private var externalSettingChangedSignal:Signal = new Signal(String, Object); // AMenuPage objects listen for this signal to update the GUI
		private var overlay1:Quad;
		private var menuContainer:Sprite;
		
		public function GameMenu() {
			if (_instance) throw new Error("GameMenu.as: Instance already exists...");
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );	
			_instance = this;
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			drawOverlay();
			buildInterface();
		}
		
		// [ ========== Add signals from external sources ========= ]
		public function registerSettingChangedSignal(signal:Signal):void {
			signal.add(externalSettingChangedHandler); //if (signal.numListeners > 1) trace ("Are you sure you wanted to add more?");
		}
		
		// [ ========== Handle settings changes from external sources ========= ]
		private function externalSettingChangedHandler(name:String, data:Object):void {
			externalSettingChangedSignal.dispatch(name, data);
		}
		
		// [============ Translucent overlay to dim your game while the menu is visible  ============]
		private function drawOverlay():void {
			w = this.stage.stageWidth;
			h = this.stage.stageHeight;
			overlay = StarlingGraphicsUtils.getGradientQuad(w, h, 0x001130, 0x000000, 0.7);
			addChild(overlay);
		}
		
		// [============] Build interface and add pages to it [============]
		private function buildInterface():void {
			w = 950;			// Width of menu + content
			h = 500;			// Hight of menu + content
			widthRatio = 0.22 	// Ratio of menu to content
			
			if (stage.stageWidth < w) this.scaleX = this.scaleY = (stage.stageWidth / w); // TODO: fix this
			
			menuWidth 		= w * widthRatio;				// width of nav menu (left)
			menuHeight 		= h ; 						// hight of nav menu (left)
			menuPadding 	= 0; 							// distance between the menu and the content
			menuItemWidth 	= w - menuWidth - menuPadding;	// the width of the page
			menuItemHeight 	= h;							// the hight of the page
			
			// [============ Set up Theme ============]
			this.theme = new PixelSphereTheme( this.stage, false );

			// [============ make menu button (toggles the menu visibility) ============]
			menuButton = new Button();
			menuButton.nameList.add(PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON_SMALL);
			menuButton.label = "Main Menu";
			menuButton.height = 25;
			menuButton.addEventListener( Event.TRIGGERED, showMenu );
			addChild(menuButton);
			menuButton.validate();
			
			// [============ make menu container (BOTH the master and slave go in here) ============]
			menuContainer = new Sprite();
			menuContainer.y = menuButton.height + 50;
			addChild(menuContainer);
			
			var pad:Number = 10;
			overlay1 = StarlingGraphicsUtils.getHorizontalGradientQuad(w + pad * 1.5, h + pad, 0x000000, 0x222222, 0.3);
			overlay1.x = -(pad / 2);
			overlay1.y = -(pad / 2);
			menuContainer.addChild(overlay1);
			
			// [============ build menu items ============]
			menuItems.push(new MenuItem("Play", 			new TitlePage("Pixelsphere")));
			menuItems.push(new MenuItem("Level Select", 	new LevelPage("Select Your Starting Level")));
			menuItems.push(new MenuItem("Settings", 		new SettingsPage("Settings")));
			menuItems.push(new MenuItem("Credits", 			new CreditsPage("Credits")));
			//menuItems.push(new MenuItem("Stats", 			new StatsPage("Stats For Your Game")));
			menuItems.push(new MenuItem("Debug", 			new DebugPage("Debug Settings")));
			
			// [============ make menu selector (navigation bar on left) ============]
			mainMenu = new MenuButtons(menuItems, menuWidth, menuHeight);
			menuContainer.addChild(mainMenu);
			mainMenu.validate();
			mainMenu.menuItemChanged.add(handleMenuItemChanged);
			
			// [============ make slave screen (right) & add listeners to the menuItem's AMenuPage ============]
			var menuItem:MenuItem;
			slave = new MenuContents(menuItemWidth, menuItemHeight);
			menuContainer.addChild(slave);
			menuContainer.addChild(mainMenu); // keep mainMenu on top
			
			var i:int;
			for (i = 0; i < menuItems.length; i++) {
				menuItem = menuItems[i];
				menuItem.menuPage.settingChangedSignal.add(internalSettingChangedHandler);		// Get setting changes from pages
				menuItem.menuPage.externalSettingChangedSignal = externalSettingChangedSignal; 	// Push setting changes to pages
				slave.addScreen(menuItem.screen, menuItem.id);
			}
			slave.x = menuWidth + menuPadding + pad/2;
		
			menuItem = menuItems[2]; // pick default menu item. [1] is level select...choose [0] for title screen
			slave.changeScreen(menuItem.id);
			
		}
		// [================ Handle a setting change from any registered AMenuPage ====================]
		private function internalSettingChangedHandler(name:String, value:Object, closeMenu:Boolean):void {
			if (closeMenu) this.hideMenu();
			settingChanged.dispatch(name, value);
		}
		
		private function handleMenuItemChanged(mi:MenuItem):void {
			slave.changeScreen(mi.id);
			settingChanged.dispatch("MenuItemChanged", true);
		}
		
		private function showMenu(e:Event):void {
			toggleMenuVisibility();
		}
		
		// [=========================== Public functions =============================]
		public function setContentPosition(x:int, y:int):void {
			if (this.parent) {
				menuContainer.x = x;
				menuContainer.y = y;
			}
		}
		
		public function setMenuButtonPosition(x:int, y:int):void {
			if (this.parent) {
				menuButton.x = x;
				menuButton.y = y;
			}
		}
		
		public function toggleMenuVisibility():void {
			overlay.visible = !overlay.visible
			menuContainer.visible = !menuContainer.visible;
			slave.toggleVisible();
			settingChanged.dispatch("GUIClosed", true);
		}
		
		public function hideMenu():void {
			overlay.visible 	= false;
			menuContainer.visible = false;
			slave.hide();
			settingChanged.dispatch("GUIClosed", true);
		}
		
		static public function get instance():GameMenu {
			if (!_instance) _instance = new GameMenu();
			return _instance;
		}
	}

}