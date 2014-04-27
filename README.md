StarlingFeathersGameMenu
========================

StarlingFeathersUI Game menu created by Alex Smith cynicmusic.com 


THIS IS NOT ALEX SMITH I JUST UPLOADED THIS FOR SAFE KEEPING
THE REST OF THIS TEXT COMES FROM THE README FILE WITHIN THE ZIP FOLDER
I WILL NOT KEEP THIS UPDATED OR MANAGED. IF YOU FIND BUGS FORK IT YOURSELF

[====================================]

[ Feathers GameMenu v1.0

[ Credits and License

[====================================]

Alex Smith

cynicmusic.com

License:

Game package and example by Alex Smith: Public domain. Give credit to cynicmusic.com if you'd like.

Feathers: Simplified BSD http://feathersui.com/

Starling: Simplified BSD http://gamua.com/starling/

Signals: MIT License https://github.com/robertpenner/as3-signals

Game specific assets: (logo, level icons, text) copyright Alex Smith all rights reserved. No use permitted.


[====================================]

[ About

[====================================]

GameMenu is a template for a main menu for your game. Easily add new screens from the template

and connect settings to and from your game. The template consists of three parts:

GameMenu (FeathersUI menu system with navigation bar and page layout)

GameSettingsManager (Communicate signals between GameMenu and your game)

GameSettingsSaveData (Serialize settings to disk via SharedObject)

[====================================]

[ Features

[====================================]

Add more controls including handlers in a single statement:

addSlider("MusicVolume", function(e:Event):void

{ settingChangedSignal.dispatch("MusicVolume", Slider(e.currentTarget).value, false);} );

(Easily create buttons, checkboxes, sliders, and toggle switches)

-Template game menu with title screen, level select, settings, and credits.

-Register and keep track of settings in your game such as volume, current level, score etc...

-Access settings anywhere through static reference to GameSettingsManager

-Load/Save settings to disk with SharedObject

-Automatic notification of setting changes with AS3 signals

-When a setting changes, both the GUI and your game will update

-Event driven so GameSettingsManager and GameSettingsSaveData are optional to use.


[====================================]

[ Known issues

[====================================]

- Text stays on screen for a bit during when you close the menu (5-18-13)


[====================================]

[ TODO

[====================================]

- Integration with CitrusEngine or a LevelDataProvider with the list of levels

- Ability to lock levels

- Ability to show a badge on completed levels

