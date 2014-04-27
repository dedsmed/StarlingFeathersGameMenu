package game.feathersUI.pages {
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.controls.TextArea;
	import feathers.controls.Scroller;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Alex
	 */
	public class CreditsPage extends AMenuPage {
		private var creditsText:String;
		
		public function CreditsPage(titleText:String = "") {
			super(titleText);
			creditsText = "Game design, development, music, sound, levels and art by Alex Smith";
			creditsText += "\n\nMany thanks to the following people who helped..."
			creditsText +=  "\n\nAymeric Lamboley (Citrus Engine)\nThomas Lefevre (Citrus Engine)\nJosh Tynjala (Feathers)";
			creditsText +=  "\n\nOpenGameArt, Surt, Hyptosis, Celianna (Art)";
			creditsText +=  "\n\...\n\n\n\n\n\n\n\n";
			creditsText +=  "Copyright 2013 Alex Smith";
		}
		
		override protected function drawPage():void {
			var scrollText:ScrollText = new ScrollText();
			scrollText.width = w;
			scrollText.height = contentContainer.height;
			scrollText.text = creditsText;
			scrollText.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED; // always show scroll bar
			contentContainer.addChild( scrollText );
		}
	}
}