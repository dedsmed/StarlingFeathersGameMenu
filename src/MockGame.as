package  {
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import game.gameSettingsManager.GameSetting;
	import game.gameSettingsManager.GameSettingsManager;
	import game.feathersUI.util.StarlingGraphicsUtils;
	import org.osflash.signals.Signal;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * ...
	 * @author Alex
	 * This is a demonstration on how you incorporate GameSettings, GameSettingsManager and the GameMenu UI into your game.
	 * 
	 */
	public class MockGame extends Sprite {
		private var scrollText:ScrollText;
		private var gameSettingsManager:GameSettingsManager;
		
		public function MockGame(gameSettingsManager:GameSettingsManager) {
			this.gameSettingsManager = gameSettingsManager;
			registerSettings();
			drawUI();
			gameSettingsManager.readSettingsFromDisk(); // Read all settings from disk.
		}
		
		// [============ Register and connect the settings for this game ==============]
		public function registerSettings():void {
			// [==================================================================================]
			// IMPORTANT: Pay attention to the boolean values when creating a new GameSetting.
			// To use a setting as a notifyer that is not saved to disk, 
			// set BOTH the 3rd and 4th boolean params to false
			// this makes sure that 1) not saved to disk 2) signal always fired regardless of whether the data changes
			// things like LevelChanged and NewGame are set up this way...
			// [==================================================================================]
			r(new GameSetting("MusicVolume", 80, true), handleMusicVolumeChanged);
			r(new GameSetting("SoundVolume", 80, true), handleSettingChanged);
			r(new GameSetting("Particles", 90, true), handleSettingChanged);
			r(new GameSetting("Level", 0, false), null);								// used to store the level
			r(new GameSetting("LevelChanged", 0, false, false), handleLevelChanged); 	// used to change the current level
			r(new GameSetting("NewGame", 0, false, false), handleSettingChanged); 		// start a new game.
			r(new GameSetting("ContinueGame", 0, false, false), handleSettingChanged); 	// continue game
			r(new GameSetting("GUIClosed", 0, false, false), handleGUIClosed); 			// used to save settings to disk whenever the GUI closes
			r(new GameSetting("Debug", 0, true), handleSettingChanged);
			r(new GameSetting("ShowHUD", 0, true), handleSettingChanged);
			r(new GameSetting("ShowDebugLevelSelect", 0, true), handleSettingChanged);
			r(new GameSetting("ShowStarlingStats", 0, true), handleSettingChanged);
			r(new GameSetting("ShowDebugStats", 0, true), handleSettingChanged);
			r(new GameSetting("DoThing", 0, false, false), handleSettingChanged);
			r(new GameSetting("MenuItemChanged", 0, false, false), handleSettingChanged);
		}
		
		// [============ helper function for clean code (register and connect) ==============]
		private function r(gs:GameSetting, handler:Function = null):void {
			this.gameSettingsManager.registerSetting(gs);
			var signal:Signal = gameSettingsManager.getSignalForSetting(gs.name);
			if (signal && handler != null) signal.add(handler);
		}
		
		// [============ Handle incoming setting changes in the game ==============]
		private function handleLevelChanged(name:String, data:Object):void {
			log("Level was changed to: " + data);
		}
		
		private function handleMusicVolumeChanged(name:String, data:Object):void {
			log("Music Volume was changed to: " + data);
		}
		
		private function handleSettingChanged(name:String, data:Object):void {
			log("Setting " + name + " was changed to: " + data);
		}
		
		private function handleGUIClosed(name:String, data:Object):void {
			log("Saved Game Data...");
			gameSettingsManager.writeSettingsToDisk();
		}
		
		// [============ Game UI ============]
		protected function drawUI():void {
			addChild(StarlingGraphicsUtils.getGradientQuad(1100, 200));
			
			scrollText = new ScrollText();
			scrollText.width = 700;
			scrollText.height = 150;
			scrollText.text = "Mock Game";
			scrollText.border = true;
			scrollText.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED; // always show scroll bar
			this.addChild( scrollText );
			
			var button:Button = new Button();
			button.label = "Change Music Volume";
			button.x = scrollText.width;
			button.y = 10;
			button.height = 25;
			button.addEventListener("triggered", volumeButtonHandler);
			this.addChild(button);
			
			var saveButton:Button = new Button();
			saveButton.label = "Save Settings to disk";
			saveButton.x = scrollText.width;
			saveButton.y = 40;
			saveButton.height = 25;
			saveButton.addEventListener("triggered", saveButtonHandler);
			this.addChild(saveButton);
			
			var loadButton:Button = new Button();
			loadButton.label = "Load Settings from disk";
			loadButton.x = scrollText.width;
			loadButton.y = 70;
			loadButton.height = 25;
			loadButton.addEventListener("triggered", loadButtonHandler);
			this.addChild(loadButton);
		}
		
		private function volumeButtonHandler(e:Event):void {
			gameSettingsManager.changeSetting("MusicVolume", Number(Math.random() * 99));
		}
		
		private function saveButtonHandler(e:Event):void {
			gameSettingsManager.writeSettingsToDisk();
			log("Saved to disk...");
		}
		
		private function loadButtonHandler(e:Event):void {
			gameSettingsManager.readSettingsFromDisk();
			log("Loaded from disk...");
		}

		public function log(value:String):void {
			scrollText.text = value + "\n" + scrollText.text;
			if (scrollText.text.length > 500) scrollText.text = scrollText.text.substr(0,500);
		}
		
	}

}