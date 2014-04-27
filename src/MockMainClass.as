package  {
	import game.feathersUI.GameMenu;
	import game.gameSettingsManager.GameSettingsManager;
	import game.gameSettingsManager.GameSettingsSaveData;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Alex
	 */
	public class MockMainClass extends Sprite {
		private var gameSettingsManager:GameSettingsManager;
		private var gameMenu:GameMenu;
		private var mockGame:MockGame;
		
		public function MockMainClass() {
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function init():void {
			// [============[ GameSettingsManager to store and communicate settings ]============]
			gameSettingsManager = new GameSettingsManager();
			
			// [============[ GameMenu is a customizable game menu GUI ]============]
			gameMenu = new GameMenu();
			gameMenu.registerSettingChangedSignal(gameSettingsManager.outgoingSettingChangeSignal);
			addChild(gameMenu);
			gameMenu.setContentPosition(50, 50);
			gameMenu.setMenuButtonPosition(10, 10);
			
			// [============[ Register the signal for settings changed in UI ]============]
			// [ ===========[ Currently, only one signal may be registered at a time ]=======]
			gameSettingsManager.registerSettingChangedSignal(gameMenu.settingChanged);
			
			// [============[ MockGame for testing communication between GameMenu and Game ]============]
			mockGame = new MockGame(gameSettingsManager);
			mockGame.x = 20;
			mockGame.y = 600;
			mockGame.alpha = 0.9;
			mockGame.scaleX = 0.5;
			mockGame.scaleY = 0.5;
			addChild(mockGame);
		}
	}
}