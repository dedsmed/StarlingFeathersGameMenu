package game.gameSettingsManager {
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Alex
	 * 
	 * This class writes settings to disk with a Flash SharedObject.
	 */
	public class GameSettingsSaveData {
		
		private static var _instance:GameSettingsSaveData;
		private var so:SharedObject;
		
		public function GameSettingsSaveData() {
			if (_instance != null)
				throw(new Error("GameSettingsSaveData.as: illegal reinstantiation!"));
			_instance = this;
			try{
				getSharedObject();
			} catch (e:Object) { }
		}
		
		public static function getInstance():GameSettingsSaveData {
			if (!_instance) return new GameSettingsSaveData();
			else return _instance;
		}
		
		private function getSharedObject():void {
			so = SharedObject.getLocal("ps");
		}
		
		public function writeData(gs:GameSetting):void {
			if (so) so.data[gs.name] = gs.data;
		}
		
		public function readData(changeSettingFunction:Function):void {
			if (so) {
				for (var prop:Object in so.data) {
					//trace(prop + ": " + so.data[prop]);
					changeSettingFunction(prop, so.data[prop]);
				}
			} else {
				//trace ("PROBLEM READING FROM SHARED OBJECT!!!");
			}
		}
		
		public function clearSharedObject():void {
			if (so) so.clear();
		}
		
	}
}