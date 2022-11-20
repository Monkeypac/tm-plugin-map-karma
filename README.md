# Overview

This is a rework of [this plugin](https://github.com/Monkeypac/tm-twitch-map-command).
The idea is to get something more polished and more documented.

This allows voting for a map from both the In-Game chat and a Twitch chat.

# Install

## From github

Go to [the github repository](https://github.com/Monkeypac/tm-plugin-map-karma) and download the archive. You can then just decompress it in your OpenplanetNext/Plugins folder.

# Usage

Install the plugin, then in the Openplanet menu, click on Scripts > Streaming > Map karma > Game interface > Show bar.

## Settings

Settings for this plugin can be found in the Openplanet menu under Openplanet > Settings > MapKarma.

From there, you can click on Bar > Move karma windows to resize and reposition the different displays. Untoggle this when you're happy with the positioning.

You can also change the colors and various things from this menu.

## Twitch

To connect to your Twitch chat, you'll need to have the `Twitch Base` plugin installed. 

1. From in game in Plugin manager > Open manager > Search `Twitch Base` > Click `Info` > Click `Install`.
2. Go to Openplanet > Settings > Twitch Base and fill in the information. You can check the plugin information on how to fill those from the [website](https://openplanet.dev/plugin/twitchbase) or directly from the game plugin manager.
3. Reload the MapKarma plugin (Developer > (Re)Load plugin > MapKarma).

## Custom textures

You can completely replace the whole bar drawing with custom textures of your choice.

To do this, go to your OpenplanetNext folder and add in a folder named as you want, let's say "MyTextures".

Add all the textures you want to use for your karma bar in this folder.

You then need to create a file named "manifest.json" in which you'll have to put something like that:
```json
{
  "steps": [{
	  "at": 0,
	  "texture": "karma0.png"
    }, {
	  "at": 25,
	  "texture": "karma1.png"
    }, {
	  "at": 50,
	  "texture": "karma2.png"
    }, {
	  "at": 75,
	  "texture": "karma3.png"
    }, {
	  "at": 100,
	  "texture": "karma4.png"
    }]
}
```

Note that you can put any number of ranges in there but putting too much might lead the plugin to fail or even the game to crash so be wise about it.

Then go to Openplanet > Settings > MapKarma > Bar and in the "Custom textures folder" field, add in the name of the folder you created (here "MyTextures").

Now you can just go to Scripts > Streaming > Map karma > Administrate > Reload textures and your textures should load.
