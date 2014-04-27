package game.feathersUI.pages {
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.layout.VerticalLayout;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import flash.utils.Dictionary;
	import game.feathersUI.PixelSphereTheme;
	/**
	 * ...
	 * @author Alex
	 */
	public class SettingsPage extends AMenuPage {
		private var slider1:Slider, slider2:Slider, slider3:Slider, slider4:Slider;
		private var button1:Button, button2:Button, button3:Button, button4:Button;
		private var check1:Check,	check2:Check, 	check3:Check, 	check4:Check;
		private var toggle1:ToggleSwitch;
		private var scrollContainer:ScrollContainer;
		private var dict:Dictionary = new Dictionary();	// holds updater functions to update UI controls when the setting values change in your game
		
		public function SettingsPage(titleText:String = "") { super(titleText); }
		
		override protected function drawPage():void {
			// [============] Scroll Container [============]
			scrollContainer = new ScrollContainer();
			scrollContainer.scrollerProperties.horizontalScrollPolicy = "off";
			scrollContainer.scrollerProperties.verticalScrollPolicy = "off";
			contentContainer.addChild(scrollContainer);
			
			// [============[ Layout ]============]
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 18;
			layout.paddingLeft = 25;
			layout.paddingTop = 20;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			scrollContainer.layout = layout;
			
			// [============[ Slider ]============]
			slider1 = addSlider("MusicVolume", function(e:Event):void 
			{ settingChangedSignal.dispatch("MusicVolume", Slider(e.currentTarget).value, false);} );
			
			slider2 = addSlider("SoundVolume", function(e:Event):void 
			{ settingChangedSignal.dispatch("SoundVolume", Slider(e.currentTarget).value, false);} );
			
			slider3 = addSlider("Particles", function(e:Event):void 
			{ settingChangedSignal.dispatch("Particles", Slider(e.currentTarget).value, false); } );
			
			// [============[ Checkbox ]============]
			check1 = addCheckbox("ShowHUD", "Show HUD", function(e:Event):void 
				{ settingChangedSignal.dispatch("ShowHUD", Check(e.currentTarget).isSelected, false); }, true);
			
			check2 = addCheckbox("ShowDebugLevelSelect", "Show debug level select", function(e:Event):void 
				{ settingChangedSignal.dispatch("ShowDebugLevelSelect", Check(e.currentTarget).isSelected, false); }, true);
			
			check3 = addCheckbox("ShowDebugStats", "Show debug stats", function(e:Event):void 
				{ settingChangedSignal.dispatch("ShowDebugStats", Check(e.currentTarget).isSelected, false); }, true);
			
			check4 = addCheckbox("ShowStarlingStats", "Show starling stats", function(e:Event):void // This one saves the setting and calls into Starling for you...
				{ Starling.current.showStats = Check(e.currentTarget).isSelected; settingChangedSignal.dispatch("ShowStarlingStats", Check(e.currentTarget).isSelected, false); }, Starling.current.showStats);
			
			// [============[ ToggleSwitch ]============]
			toggle1 = addToggleSwitch("Debug", function(e:Event):void 
				{ settingChangedSignal.dispatch("Debug", ToggleSwitch(e.currentTarget).isSelected, false); }, false);
			
			// [============[ Button ]============]
			/*button1 = addButton("DoThing", "Show Box2D Debug Art", function(e:Event):void 
				{ settingChangedSignal.dispatch("DoThing", true , false); });*/
		
			// [============[ Make sure all controls are validated, validation only works once.   ]=========]
			// [============[ Add Text Labels that are positioned relative to the UI controls     ]=========]
			scrollContainer.validate();
			var pad:int = 7;
			if (slider1) addTextLabel("Music Volume", 		slider1.x + slider1.width + pad, slider1.y-3);
			if (slider2) addTextLabel("Sound Volume", 		slider2.x + slider2.width + pad, slider2.y-3);
			if (slider3) addTextLabel("Particles", 			slider3.x + slider3.width + pad, slider3.y-3);
			if (toggle1) addTextLabel("Debug Mode", 		toggle1.x + toggle1.width + pad, toggle1.y + 5);
		}

		private function addCheckbox(name:String,text:String, handler:Function = null, value:Boolean = false):Check {
			var check:Check = new Check();
			check.label = text;
			check.height = 25;
			check.isSelected = value;
			if (handler != null) check.addEventListener("change", handler);
			scrollContainer.addChild(check);
			dict[name] = function(data:Object):void { check.isSelected = Boolean(data); }
			return check;
		}
		
		private function addButton(name:String, text:String, handler:Function = null):Button {
			var button:Button = new Button();
			button.label = text;
			button.width = 270;
			button.height = 32;
			button.nameList.add(PixelSphereTheme.ALTERNATE_NAME_MENU_BUTTON);
			button.addEventListener("triggered", handler);
			scrollContainer.addChild( button );
			return button;
		}
		
		private function addToggleSwitch(name:String, handler:Function = null, value:Boolean = false):ToggleSwitch {
			var toggleSwitch:ToggleSwitch = new ToggleSwitch();
			toggleSwitch.addEventListener("change", handler);
			toggleSwitch.height = 55;
			toggleSwitch.width = 120;
			toggleSwitch.scaleX = 0.8;
			toggleSwitch.scaleY = 0.8;
			toggleSwitch.thumbProperties = { height: 55 };
			toggleSwitch.isSelected = value;
			scrollContainer.addChild(toggleSwitch);
			return toggleSwitch;
		}
		
		private function addSlider(name:String, handler:Function = null, value:int = 50):Slider {
			var soundHandler:Function = function(e:Event):void 
				{ settingChangedSignal.dispatch("PlaySound", Slider(e.currentTarget).value, false);}
			var s:Slider = new Slider();
			s.width 	= w - 370;
			s.height 	= 35;
			s.minimum 	= 0;
			s.maximum 	= 100;
			s.value 	= value;
			s.thumbProperties.height = 34;
			s.trackLayoutMode = "directional";
			if (handler != null) s.addEventListener("change", handler);
			if (soundHandler != null) s.addEventListener("endInteraction", soundHandler);
			scrollContainer.addChild( s );
			dict[name] = function(data:Object):void { s.value = Number(data); } // handle external setting change
			return s;
		}
		
		private function addTextLabel(text:String, x:Number, y:Number):Label {
			var label:Label = new Label();
			label.text = text;
			label.x = x;
			label.y = y;
			label.height = 35;
			contentContainer.addChild(label); // (avoid layout in the scroll container)
			return label;
		}
		
		// [============ Handle incoming setting changes to update the GUI control values ============]
		override protected function handleExternalSettingChange(name:String, data:Object):void {
			if (dict[name] != null) {
				if (dict[name] is Function) {
					dict[name](data);
				}
			} 
		}
	}

}