package game.feathersUI
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Check;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.ScrollText;
	import feathers.controls.Slider;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	import feathers.skins.ImageStateValueSelector;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.text.TextFormat;
	import flash.text.TextRenderer;
    import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Alex
	 * 
	 * Notes:
		 * This custom theme repurposes the MetalWorksMobile theme for desktop.
		 * use button.isQuickHitAreaEnabled = false for pixel-perfect button hit areas. Otherwise they're bigger than buttons.
		 * Designed to work with Feathers 1.1 BETA. Your milage may vary with newer versions.
	 * 
	 */
	public class PixelSphereTheme extends MetalWorksMobileTheme
	{
		private const fontNames:String = "Helvetica Neue,Helvetica,Roboto,Arial,_sans";;
		public static const ALTERNATE_NAME_LEVEL_MENU:String 	= "level_menu";
		public static const ALTERNATE_NAME_MENU_BUTTON:String 	= "menu button";
		public static const ALTERNATE_NAME_MENU_BUTTON_BIG:String 	= "menu button big";
		public static const ALTERNATE_NAME_MENU_BUTTON_SMALL:String 	= "menu button small";
		public static const ALTERNATE_NAME_HEADER:String		= "custom header";
		public static const ALTERNATE_NAME_CLOSE_BUTTON:String 	= "custom close button (upper right corner X)";
		public static const ALTERNATE_NAME_NAV_BUTTON:String 	= "custom nav button";
		
		public const regularFontNames:String = "SourceSansPro";
		public const semiboldFontNames:String = "SourceSansProSemibold";
		
		public function PixelSphereTheme( root:DisplayObjectContainer, scaleToDPI:Boolean = true )
		{
			super( root, scaleToDPI );
		}
 
		override protected function initialize():void
		{
			super.initialize();
			
			// set new initializers
			this.setInitializerForClass( DefaultListItemRenderer, levelMenuListItemInitializer, ALTERNATE_NAME_LEVEL_MENU );
			this.setInitializerForClass( Button, menuButtonInitializer, ALTERNATE_NAME_MENU_BUTTON );
			this.setInitializerForClass( Button, menuButtonBigInitializer, ALTERNATE_NAME_MENU_BUTTON_BIG );
			this.setInitializerForClass( Button, menuButtonSmallInitializer, ALTERNATE_NAME_MENU_BUTTON_SMALL );
			this.setInitializerForClass( Header, customHeaderInitializer, ALTERNATE_NAME_HEADER );
			this.setInitializerForClass( Button, closeButtonInitializer, ALTERNATE_NAME_CLOSE_BUTTON);
			this.setInitializerForClass( Button, customNavigationButtonInitializer, ALTERNATE_NAME_NAV_BUTTON);
			this.headerTextFormat = new TextFormat(fontNames, 20, LIGHT_TEXT_COLOR, true);
			this.smallLightTextFormat = new TextFormat(fontNames, 22, LIGHT_TEXT_COLOR);
			this.root.removeChild(primaryBackground); // AS: remove the ugly brown background texture =)
		}
		
		
		/* [============================================================================]
		 *  Default button. Used for slider thumbs and stuff
		 * 	
		 * [============================================================================]
		*/
		override protected function simpleButtonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();

			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonSelectedUpSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			
			
			
			/*const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
			
			this.baseButtonInitializer(button);*/
			
			
			
			skinSelector.displayObjectProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = button.minHeight = 60 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}
		
		
		
		
		/* [============================================================================]
		 *  Spacing for the button group
		 * 	
		 * [============================================================================]
		*/
		override protected function buttonGroupInitializer(group:ButtonGroup):void
		{
			group.minWidth = 560 * this.scale;
			group.gap = 14 * this.scale; // originally 18 in theme
		}
		
		/* [============================================================================]
		 * 	Custom custom horizontal slider with less tall track
		 * 	
		 * [============================================================================]
		*/
		override protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;

			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.displayObjectProperties =
			{
				textureScale: this.scale
			};
			if(slider.direction == Slider.DIRECTION_VERTICAL)
			{
				skinSelector.displayObjectProperties.width = 60 * this.scale;
				skinSelector.displayObjectProperties.height = 210 * this.scale;
			}
			else
			{
				skinSelector.displayObjectProperties.width = 210 * this.scale;
				skinSelector.displayObjectProperties.height = 30 * this.scale;
			}
			slider.minimumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
			slider.maximumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
		}
		
		/* [============================================================================]
		 * 	Custom ScrollText Initializer with font for credits screen
		 * [============================================================================]
		*/
		override protected function scrollTextInitializer(text:ScrollText):void
		{
			text.textFormat = new TextFormat(regularFontNames, 24 * this.scale, LIGHT_TEXT_COLOR);
			text.embedFonts = true;
			text.paddingTop = text.paddingBottom = text.paddingLeft = 32 * this.scale;
			text.paddingRight = 36 * this.scale;

			text.verticalScrollBarFactory = this.verticalScrollBarFactory;
			text.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		}
		
		// for level selector (custom default list without a background quad)
		override protected function listInitializer(list:List):void
		{
			list.verticalScrollBarFactory = this.verticalScrollBarFactory;
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		}
		/* [============================================================================]
		 * 	Custom buttons for the LEVEL SELECT screen
		 *  These are the buttons with 128x128 pictures on them in a list view
		 * [============================================================================]
		*/
		protected function levelMenuListItemInitializer(renderer:BaseDefaultItemRenderer):void
		{
			// [============ DO SKIN =============]
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			//skinSelector.defaultValue = this.itemRendererUpSkinTextures;
			skinSelector.defaultSelectedValue = this.itemRendererSelectedSkinTextures;
			skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_HOVER, false);
			renderer.stateToSkinFunction = skinSelector.updateValue;

			// [============ LABEL PROPERTIES =============]
			const regularFontNames:String = "SourceSansPro";
			const semiboldFontNames:String = "SourceSansProSemibold";
			renderer.defaultLabelProperties.embedFonts = true;
			renderer.defaultLabelProperties.textFormat = new TextFormat(semiboldFontNames, 26, 0xFFF1DB, false);			
			renderer.downLabelProperties.textFormat = this.largeDarkTextFormat;
			renderer.defaultSelectedLabelProperties.textFormat = this.largeDarkTextFormat;

			// [============ ALIGN & ICON =============]
			//renderer.horizontalAlign = Button.ICON_POSITION_BOTTOM;
			//renderer.verticalAlign = Button.ICON_POSITION_TOP;
			renderer.horizontalAlign 	= Button.HORIZONTAL_ALIGN_CENTER;
			renderer.verticalAlign 		= Button.VERTICAL_ALIGN_MIDDLE;
			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;
			renderer.paddingLeft = 8 * this.scale;
			renderer.paddingRight = 8 * this.scale;
			renderer.gap = 5
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			renderer.minWidth = renderer.minHeight = 88 * this.scale;
			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.levelMenuListItemInitializerForImageLoaderFactory;
		}
		
		protected function levelMenuListItemInitializerForImageLoaderFactory():ImageLoader {
			const image:ImageLoader = new ImageLoader();
			return image;
		}
		
		/* [============================================================================]
		 * 	Custom Initializer for menu buttons 
		 * 	These are the orange buttons on the left
		 * [============================================================================]
		*/
		protected function menuButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
			
			this.baseButtonInitializer(button);
			
			/*button.paddingTop = button.paddingBottom = 4;
			button.paddingLeft = button.paddingRight = 55
			button.gap = 4
			button.minWidth = button.minHeight = 22
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;*/
			
			button.isQuickHitAreaEnabled = false; // AS Makes the hit area pixel exact
		}
		
		// for the top buton on the left side "Play". Its text is a little bigger.
		protected function menuButtonBigInitializer(button:Button):void
		{
			const regularFontNames:String = "SourceSansPro";
			const semiboldFontNames:String = "SourceSansProSemibold";
			
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
			
			this.baseButtonInitializer(button);
			
			button.defaultLabelProperties.textFormat = new TextFormat(semiboldFontNames, 28 * this.scale, DARK_TEXT_COLOR, true);;
			button.defaultLabelProperties.embedFonts = true;
			
			button.isQuickHitAreaEnabled = false; // AS Makes the hit area pixel exact
		}
		
		protected function menuButtonSmallInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDangerDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			button.stateToSkinFunction = skinSelector.updateValue;
	
			this.baseButtonInitializer(button);
			
			button.defaultLabelProperties.textFormat = new TextFormat(semiboldFontNames, 18 * this.scale, DARK_TEXT_COLOR, true);;
			button.defaultLabelProperties.embedFonts = true;
			
			button.isQuickHitAreaEnabled = false; // AS Makes the hit area pixel exact
		}
		
		
		/* [============================================================================]
		 * 	Custom Initializer for small navigation buttons. 
		 *  Like the < and > buttons on level select 
		 * [============================================================================]
		*/
		protected function customNavigationButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonSelectedUpSkinTextures, Button.STATE_HOVER, false);
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			
			button.stateToSkinFunction = skinSelector.updateValue;

			this.baseButtonInitializer(button);
			
			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 16 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 60 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
			button.isQuickHitAreaEnabled = false; // AS Makes the hit area pixel exact
		}
		
		/* [============================================================================]
		 * 	for checkboxes
		 * [============================================================================]
		*/
		override protected function checkInitializer(check:Check):void
		{
			const iconSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkSelectedUpIconTexture;
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			
			//iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_HOVER, true);
			iconSelector.setValueForState(this.checkSelectedDownIconTexture, Button.STATE_HOVER, true);
			
			iconSelector.displayObjectProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			check.stateToIconFunction = iconSelector.updateValue;

			check.defaultLabelProperties.textFormat = this.smallUILightTextFormat;
			check.defaultLabelProperties.embedFonts = true;
			check.disabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
			check.disabledLabelProperties.embedFonts = true;
			check.selectedDisabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
			check.selectedDisabledLabelProperties.embedFonts = true;

			check.gap = 8 * this.scale;
			check.minTouchWidth = check.minTouchHeight = 88 * this.scale;
		}
		
		/* [============================================================================]
		 * 	Custom close button. That little guy in the upper right corner (X)
		 * [============================================================================]
		*/
		protected function closeButtonInitializer(button:Button):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = this.atlas.getTexture("check-selected-down-icon");
			iconSelector.defaultSelectedValue = this.atlas.getTexture("check-selected-down-icon");
			iconSelector.setValueForState(this.atlas.getTexture("check-selected-up-icon"), Button.STATE_HOVER, false);
			button.stateToIconFunction = iconSelector.updateValue;
		
			button.paddingTop = 0;
			button.paddingLeft = 0;
			button.paddingRight = 0;
			button.gap = 0;
			button.minWidth = 0;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale; // makes this close button a bit easier to hit
		}
		
		/* [============================================================================]
		 * 	Initializer for custom headers. Note the header text format appears in the constructor for this theme
		 * [============================================================================]
		*/
		protected function customHeaderInitializer(header:Header):void
		{
			header.minWidth = 88 * this.scale;
			header.minHeight = 25 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom =
				header.paddingLeft = 5 * this.scale;

			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0x000000);
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = this.headerTextFormat;
			
			const regularFontNames:String = "SourceSansPro";
			const semiboldFontNames:String = "SourceSansProSemibold";
			header.titleProperties.textFormat = new TextFormat(semiboldFontNames, Math.round(30 * this.scale), LIGHT_TEXT_COLOR, true);
			header.titleProperties.embedFonts = true;
			header.isQuickHitAreaEnabled = false;
		}

		override protected function labelInitializer(label:Label):void
		{
			const semiboldFontNames:String = "SourceSansProSemibold";
			label.textRendererProperties.textFormat = new TextFormat(semiboldFontNames, Math.round(24 * this.scale), LIGHT_TEXT_COLOR, true);
			label.textRendererProperties.embedFonts = true;
		}
		
	}
}