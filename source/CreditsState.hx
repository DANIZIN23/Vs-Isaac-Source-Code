package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditsState extends MusicBeatState
{
    var crap:FlxSprite;
    var credits:FlxSprite;
	
	override function create()
	{
		#if windows
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('MenuIsaac'));
		}
		
		persistentUpdate = persistentDraw = true;
		
			FlxG.camera.flash(FlxColor.BLACK, 2.5);
		
			crap = new FlxSprite(-80).loadGraphic(Paths.image('paperbg'));
			crap.scrollFactor.x = 0;
			crap.scrollFactor.y = 0;
			crap.setGraphicSize(Std.int(crap.width * 0.7));
			crap.updateHitbox();
			crap.screenCenter();
			crap.visible = true;
			crap.antialiasing = true;
			add(crap);
			
			credits = new FlxSprite(-80).loadGraphic(Paths.image('menu/credits', 'shared'));
			credits.scrollFactor.x = 0;
			credits.scrollFactor.y = 0;
			credits.setGraphicSize(Std.int(credits.width * 0.68));
			credits.updateHitbox();
			credits.screenCenter();
			credits.visible = true;
			credits.antialiasing = true;
			add(credits);
             
		super.create();

	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

	}
}
