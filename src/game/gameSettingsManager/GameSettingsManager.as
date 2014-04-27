package game.gameSettingsManager {
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Alex
	 * 
	 * This class glues together settings from the game to the GameMenu GUI
	 * communication is handled in both directions:
		 * Setting from Local Storage ---> Populate Game Data and GUI
		 * Setting changed in Game ---> Update GUI
		 * Setting changed in GUI ---> Update Game
		 * Call writeSettingsToDisk ---> Serialize all Settings to Local Storage (SharedObject)
		 * 
		 * Note that if the GameManager dispatches an event to GameSettingsManager when a GUI
		 * control was updated through external means (not Keyboard/Mouse input) then the signal
		 * will be fired twice from the GameSetting object. This affects controls such as Sliders
		 * GameSetting has a parameter called "dispatchOnlyWhenDataChanges" to fix this.
		 * 
		 * You may also designate a GameSetting's "saveToSharedObject" property so that settings
		 * used to trigger an event such as changing level are not saved to disk, and thus don't
		 * dispatch changed signals when data is loaded from disk.
		 * 
		 * GameSetting objects currently designed to hold primitve data like bool, int, number. Complex
		 * data will not be serialized to disk properly.
		 * 
	 */
	public class GameSettingsManager {
		public static var instance:GameSettingsManager;
		public var outgoingSettingChangeSignal:Signal = new Signal(String, Object); // Dispatches outgoing signals to GameMenu
		private var incomingSettingChangeSignal:Signal; // Receives settings changes from GameMenu 
		private var settingsDict:Dictionary;			// Store GameSetting objects to be registered by your game
		private var saveData:GameSettingsSaveData;		// Used to serialize all GameSetting objects to disk.
		
		public function GameSettingsManager() {
			if (instance != null) throw(new Error("GameSettingsManager.as: illegal reinstantiation!"));
			instance = this;
			init();
		}
		
		private function init():void {
			settingsDict = new Dictionary(true);
			saveData = new GameSettingsSaveData();
		}
		
		// [============] Handle incoming setting change from GameMenu [==============]
		private function incomingSettingChangeSignalHandler(name:String, data:Object):void {
			var gs:GameSetting = GameSetting(settingsDict[name]);
			if (gs) gs.data = data;
		}
		
		// [============] Register a GameSetting object [==============]
		public function registerSetting(gs:GameSetting):void {
			settingsDict[gs.name] = gs;
		}
		
		// [============] Register the signal to listen for setting changes from GameMenu [===============]
		// [ To prevent you from stepping on your toes, setting this signal will overwrite the previous value. ]
		public function registerSettingChangedSignal(signal:Signal):void {
			if (this.incomingSettingChangeSignal) this.incomingSettingChangeSignal.remove(incomingSettingChangeSignalHandler);
			this.incomingSettingChangeSignal = signal;
			this.incomingSettingChangeSignal.add(incomingSettingChangeSignalHandler);
		}
		
		// [==============] Get a signal for a particular setting [==================]
		// [ Your game should listen to these signals to respond to settings changes ]
		public function getSignalForSetting(name:String):Signal {
			var signal:Signal;
			var gs:GameSetting;
			gs = GameSetting(settingsDict[name]);
			if (gs) signal = gs.settingChangedSignal;
			else signal = null;
			return signal;
		}
		
		public function getSettingValue(name:String):Object {
			var gs:GameSetting;
			gs = GameSetting(settingsDict[name]);
			if (gs) return gs.data;
			else return null;
		}
		
		public function getGameSettingObject(name:String):GameSetting {
			var gs:GameSetting;
			gs = GameSetting(settingsDict[name]);
			if (gs) return gs;
			else return null;
		}
		
		// [=============================] Change a setting. [====================================]
		// [ Your game should call this to change a setting and have it update in the GameMenu GUI]
		public function changeSetting(name:String, data:Object):void {
			var gs:GameSetting = GameSetting(settingsDict[name]);
			if (gs) gs.data = data;
			outgoingSettingChangeSignal.dispatch(name, data);
		}
		
		public function writeSettingsToDisk():void {
			for each (var gs:GameSetting in settingsDict) {
				if (gs.saveToSharedObject) {
					saveData.writeData(gs);
				}
			}
		}
		
		public function readSettingsFromDisk():void {
			saveData.readData(this.changeSetting);
		}
		
		public function deleteSettingsFromDisk():void {
			saveData.clearSharedObject();
		}
		
		
		
	}
}