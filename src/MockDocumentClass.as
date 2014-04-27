package {
	import flash.display.Sprite;
	import starling.core.Starling;
	[SWF(width="1024",height="800",frameRate="60",backgroundColor="#69AAF9")]
	public class MockDocumentClass extends Sprite {
		private var _starling:Starling;
		public function MockDocumentClass() {
			_starling = new Starling(MockMainClass, stage);
			_starling.start();
		}
	}
}