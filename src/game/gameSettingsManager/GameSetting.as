package game.gameSettingsManager {
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Alex
	 */
	public class GameSetting {
		private var _name:String;	// name to be used as key in dictionary for this setting
		private var _data:Object;	// value for this setting. Should be primative data types like number, int, bool
		private var _dispatchOnlyWhenDataChanges:Boolean; // don't dispatch the settingsChangedSignal if the value doesn't actually change
		private var _saveToSharedObject:Boolean; // whether this setting should be written to disk. Notifiers like "changeLevel" should not be written to disk otherwise they will trigger a dispatch when loading from disk
		public var settingChangedSignal:Signal = new Signal(String, Object); // broadcast when the UI changes the setting
		
		public function GameSetting(name:String, data:Object, dispatchOnlyWhenDataChanges:Boolean = false, saveToSharedObject:Boolean = true) {
			this._saveToSharedObject = saveToSharedObject;
			this._dispatchOnlyWhenDataChanges = dispatchOnlyWhenDataChanges;
			this._data = data;
			this._name = name;
		}
		
		public function get name():String {
			return _name;
		}
		public function get data():Object {
			return _data;
		}
		public function get saveToSharedObject():Boolean {
			return _saveToSharedObject;
		}
		
		public function set data(value:Object):void {
			if (_dispatchOnlyWhenDataChanges && _data == value) {
				_data = value;
				return; 
			} else {
				_data = value;
				settingChangedSignal.dispatch(_name, _data);
			}
		}
		
		
	}
}