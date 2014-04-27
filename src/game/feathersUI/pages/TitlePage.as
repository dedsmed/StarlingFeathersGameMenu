package game.feathersUI.pages {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.layout.VerticalLayout;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import game.feathersUI.util.GameMenuGraphicsProvider;
	import game.feathersUI.GameMenu;
	import game.feathersUI.PixelSphereTheme;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class TitlePage extends AMenuPage {
		private var scrollContainer:ScrollContainer;
		
		public function TitlePage(titleText:String = "") {
			super(titleText);
		}
		
		override protected function drawPage():void {
			// [============[ Scroll Container and Layout ]============]
			scrollContainer = new ScrollContainer();
			contentContainer.addChild(scrollContainer);
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 18;
			layout.paddingLeft = 10;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			scrollContainer.layout = layout;
			
			// [============[ Logo ]============]
			var imageContainer:Sprite = new Sprite();
			scrollContainer.addChild(imageContainer);
			var image:Image = GameMenuGraphicsProvider.instance.logoImage;
			imageContainer.addChild(image);
			if (image.width > w) imageContainer.scaleX = imageContainer.scaleY = (w / image.width); // resize if logo too big
			
			// [============[ Text Label ]============]
			var textLabel:Label = new Label();
			textLabel.text = "Welcome to Pixelsphere!"
			scrollContainer.addChild( textLabel );
			
			// [============[ Button ]============]
			var button1:Button = addButton("New Game", button1Handler);
			
			var textLabel1:Label = new Label();
			textLabel1.text = "Continue your game..."
			scrollContainer.addChild( textLabel1 );
			
			
			var button2:Button = addButton("Continue", button2Handler);
		}
		
		private function addButton(text:String, handler:Function = null):Button {
			var button:Button = new Button();
			button.label = text;
			button.width = 250;
			button.height = 45;
			button.nameList.add(PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON_BIG);
			button.addEventListener("triggered", handler);
			scrollContainer.addChild( button );
			return button;
		}
		
		private function button1Handler(e:Event):void {
			settingChangedSignal.dispatch("NewGame", true, true);
		}
		
		private function button2Handler(e:Event):void {
			settingChangedSignal.dispatch("ContinueGame", true, true);
		}
	}
}