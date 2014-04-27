package game.feathersUI.util {
	import starling.display.Quad;
	import starling.filters.BlurFilter;
	/**
	 * ...
	 * @author Alex
	 * 
	 * Some static methods for doing Starling things...
	 */
	public class StarlingGraphicsUtils {
		
		public function StarlingGraphicsUtils() {}
		
		public static function getGradientQuad(w:int = 256, h:int = 256, c1:uint = 0x111111, c2:uint = 0x453535, alpha:Number = 1.0):Quad {
			var bottomColor:uint = c1;
			var topColor:uint = c2;
			
			var quad:Quad = new Quad(w, h);
			quad.setVertexColor(0, topColor);
			quad.setVertexColor(1, topColor);
			quad.setVertexColor(2, bottomColor);
			quad.setVertexColor(3, bottomColor);
			quad.alpha = alpha;
			return quad;
		}
		
		public static function getHorizontalGradientQuad(w:int = 256, h:int = 256, c1:uint = 0x111111, c2:uint = 0x453535, alpha:Number = 1.0, a1:Number = 1, a2:Number=1):Quad {
			var leftColor:uint = c1;
			var rightColor:uint = c2;
			
			var quad:Quad = new Quad(w, h);
			quad.setVertexColor(0, leftColor);
			quad.setVertexColor(1, rightColor);
			quad.setVertexColor(2, leftColor);
			quad.setVertexColor(3, rightColor);
			
			quad.setVertexAlpha(0, a1);
			quad.setVertexAlpha(1, a2);
			quad.setVertexAlpha(2, a1);
			quad.setVertexAlpha(3, a2);
			
			quad.alpha = alpha;
			return quad;
		}
		
		
		public static function getDropShadow(dist:Number = 4, angle:Number = 0.785, color:uint = 0x000000, alpha:Number = 0.5):BlurFilter {
			var filter:BlurFilter = BlurFilter.createDropShadow(dist, angle, color, alpha);
			return filter;
		}
			
			
		
		
		
	}

}