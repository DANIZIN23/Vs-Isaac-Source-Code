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

class UnlockState extends MusicBeatState
{
    var crap:FlxSprite;
    var credits:FlxSprite;
	
	override function create()
	{
		#if windows
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (FlxG.save.data.SeenUnlock)
		{
			FlxG.switchState(new CreditsState());
		}
		else
		{
		
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('MenuIsaac'));
		}
		
		persistentUpdate = persistentDraw = true;
		
			FlxG.camera.flash(FlxColor.BLACK, 2.5);
		
			crap = new FlxSprite(0, 0).loadGraphic(Paths.image('menu/unlock', 'shared'));
			crap.scrollFactor.x = 0;
			crap.scrollFactor.y = 0;
			crap.setGraphicSize(Std.int(crap.width * 0.67));
			crap.updateHitbox();
			crap.screenCenter();
			crap.visible = true;
			crap.antialiasing = true;
			add(crap);
             
			new FlxTimer().start(5, function(dumbtimer:FlxTimer)
			{
				FlxG.switchState(new CreditsState());
			});
			FlxG.save.data.SeenUnlock = true;
		}
			 
		super.create();

	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

	}
}
