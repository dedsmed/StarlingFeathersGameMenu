package game.feathersUI.menu {
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Alex
	 * [RIGHT SIDE CONTENT]
	 * The content container on the right side which hosts the various pages of your menu system
	 * It is controlled by menu/FeathersMainMenu
	 */
	public class MenuContents extends Screen {
		private var navigator:ScreenNavigator;
		private var transition:ScreenFadeTransitionManager;
		private var currentScreenID:String;
		private var w:int;
		private var h:int;
	
		public function MenuContents(w:int, h:int) {
			this.h = h;
			this.w = w;
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			// [============ make navigator ============]
			navigator = new ScreenNavigator();
			navigator.width 	= w;
			navigator.height 	= h;
			addChild( navigator );
			
			// [============ make transition ============]
			transition = new ScreenFadeTransitionManager(navigator);
			transition.delay = 0.05
			transition.duration = 0.28;
		}
		
		public function addScreen(screen:Screen, id:String):void {
			navigator.addScreen(id, new ScreenNavigatorItem(screen));
		}
		
		public function toggleVisible():void {
			if (navigator.activeScreen == null) navigator.showScreen(currentScreenID);
			else navigator.clearScreen();
		}
		
		public function hide():void {
			navigator.clearScreen();
		}
		
		public function changeScreen(screenID:String):void {
			navigator.showScreen(screenID);
			currentScreenID = screenID;
		}
	}
}