package game.feathersUI.menu
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Quad;
	import org.osflash.signals.Signal;
	import game.feathersUI.menu.MenuItem;
	import game.feathersUI.util.StarlingGraphicsUtils;
	import game.feathersUI.PixelSphereTheme;
	/**
	 * ...
	 * @author Alex
	 * [LEFT SIDE CONTENT]
	 * Buttons on the left side. You don't need to modify anything here.
	 */
	public class MenuButtons extends Screen
	{
		private var group:ButtonGroup;
		private var listCollection:ListCollection;
		private var menuItems:Array;
		private var w:int;
		private var h:int;
		private var groupHeight:Number;
		private var buttonContainer:Sprite;
		public var menuItemChanged:Signal;
		
		public function MenuButtons(menuItems:Array, w:int, h:int) {
			this.h 			= h;
			this.w 			= w;
			this.menuItems 	= menuItems;
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			this.groupHeight = h * 0.47;
			menuItemChanged = new Signal(MenuItem);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			drawMenu();
		}
		
		private function drawMenu():void {
			// [============[ Add button group & apply custom styling from the PixelSphereTheme ]============]
			buttonContainer = new Sprite;
			addChild (buttonContainer);
			
			// background for entire height of button controls
			var bg1:Quad = StarlingGraphicsUtils.getHorizontalGradientQuad(w+7, h, 0x000000, 0x222222, 0.4);
			buttonContainer.addChild(bg1);
			buttonContainer.y = 0;
			
			// vertical divider to the right of the buttons
			var bg2:Quad = StarlingGraphicsUtils.getHorizontalGradientQuad(12, h, 0x000000, 0x000000, 0.7, 0,1);
			buttonContainer.addChild(bg2);
			bg2.x = w;
			
			group = new ButtonGroup();
			group.width = w - 10;
			group.x = 7;
			group.y = 5;
			group.height = groupHeight + 10;
			group.customButtonName 		= PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON;
			group.customFirstButtonName = PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON_BIG;
			group.customLastButtonName 	= PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON;
			// [============[ build data object from MenuItems ]============]
			var data:Array = [];
			var i:int;
			var m:MenuItem;
			
			for (i = 0; i < menuItems.length; i++) {
				m = menuItems[i];
				m.id = String(i);
				data.push( { label: m.name, triggered: buttonHandler, value: m.id} );
			}
			listCollection = group.dataProvider = new ListCollection(data);
			buttonContainer.addChild(group);
		}
		/*
		 * Handle clicking on a button
		 * The listCollection has a dynamic property through value, which is a token
		 * It carries the menuItem's id which is assigned when iterating through the menu items above.
		 */
		private function buttonHandler(event:Event):void
		{
			var button:Button = Button(event.currentTarget);
			var buttonFlag:String;
			var item:Object;
			for (var i:int = 0; i < listCollection.length; i++) {
				item = listCollection.getItemAt(i);
				if (item.label == button.label){
					buttonFlag = String(item.value);
					break;
				}
			}
			var menuItem:MenuItem = MenuItem(menuItems[i]);
			menuItemChanged.dispatch(menuItem);
		}
	}
}