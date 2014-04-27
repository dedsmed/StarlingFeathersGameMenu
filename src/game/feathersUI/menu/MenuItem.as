package game.feathersUI.menu {
	import feathers.controls.Screen;
	import game.feathersUI.pages.AMenuPage;
	/**
	 * ...
	 * @author Alex
	 * Group properties for menu items and their associated screens.
	 */
	public class MenuItem {
		public var name:String;		
		public var screen:Screen;		// a reference to the screen this item represents
		public var id:String;			// screen ID for navigator.showScreen()
		public var enabled:Boolean;		// whether button is enabled (not used currently)
		public var menuPage:AMenuPage 	// just the Scren object cast to AMenuPage
		
		public function MenuItem(name:String, screen:Screen = null, enabled:Boolean = true) {
			this.enabled 	= enabled;
			this.screen 	= screen;
			this.name 		= name;
			this.menuPage 	= AMenuPage(screen);
		}
	}
}