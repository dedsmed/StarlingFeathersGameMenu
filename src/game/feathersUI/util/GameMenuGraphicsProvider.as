package game.feathersUI.util {
	/**
	 * ...
	 * @author Alex
	 */
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class GameMenuGraphicsProvider {
		[Embed(source="/../assets/logoFinal.png")]
		private static const LOGO:Class;
		
		[Embed(source="/../assets/images/levelIcons.png")]
		private static const ICONS_IMAGE:Class;

		[Embed(source="/../assets/images/levelIcons.xml",mimeType="application/octet-stream")]
		private static const ICONS_XML:Class;
		
		private var _logoImage:Image;
		private var _primaryTextureAtlas:TextureAtlas;  // has level icons and dots for theme
		private static var _instance:GameMenuGraphicsProvider;
	
		public function GameMenuGraphicsProvider() {
			if (_instance) throw new Error("GameMenuGraphicsProvider.as: Can't make multiple GraphicsProviders");
			_instance = this;
			createGraphics();
		}
		
		public static function get instance():GameMenuGraphicsProvider {
			if (!_instance) _instance = new GameMenuGraphicsProvider();
			return _instance;
		}
		
		private function createGraphics():void {
			var bitmap:Bitmap;
			var texture:Texture;
			
			// [============[ Logo ]============]
			bitmap = new LOGO();
			texture = Texture.fromBitmap(bitmap);
			_logoImage = new Image(texture);
			
			// [============[ Primary texture atlas. Level art, and fonts are in here ]============]
			_primaryTextureAtlas = new TextureAtlas(Texture.fromBitmap(new ICONS_IMAGE(), false), XML(new ICONS_XML()));
		}
		
		// [============ Getters for Images, Textures and Atlases ============]
		public function get primaryTextureAtlas():TextureAtlas {
			return _primaryTextureAtlas;
		}
		
		public function get logoImage():Image {
			return _logoImage;
		}
	}
}