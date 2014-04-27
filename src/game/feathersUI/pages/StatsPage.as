package game.feathersUI.pages {
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.controls.TextArea;
	import feathers.layout.AnchorLayoutData;
	import flash.text.TextFormat;
	import starling.events.Event;
	import feathers.controls.Scroller;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class StatsPage extends AMenuPage {
		
		public function StatsPage(titleText:String = "") {
			super(titleText);
		}
		
		override protected function drawPage():void {
			var scrollText:ScrollText = new ScrollText();
			scrollText.width = w;
			scrollText.height = contentContainer.height;
			scrollText.text = "Stats for this level";
			scrollText.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED; // always show scroll bar
			contentContainer.addChild( scrollText );
		}
	}
}