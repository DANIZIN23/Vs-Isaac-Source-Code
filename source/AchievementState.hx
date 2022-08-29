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

class AchievementState extends MusicBeatState
{
    var crap:FlxSprite;
	var arrowdown:FlxSprite;
	var arrowup:FlxSprite;
	var ac:FlxSprite;
	var ac0:FlxSprite;
	var ac1:FlxSprite;
	var ac2:FlxSprite;
	var ac3:FlxSprite;
	var ac4:FlxSprite;
	var ac5:FlxSprite;
	var ac6:FlxSprite;
	var ac7:FlxSprite;
	var ac8:FlxSprite;
	var ac9:FlxSprite;
	var ac10:FlxSprite;
	var ac11:FlxSprite;
	var camFollow:FlxObject;
	var prompts:FlxSprite;
	
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

			arrowup = new FlxSprite(580, 25);
			arrowup.frames = Paths.getSparrowAtlas('Achievements/arrow', 'shared');
			arrowup.antialiasing = true;
			arrowup.animation.addByPrefix('bruh', 'arrow', 24);
			arrowup.scrollFactor.set(0, 0);
			arrowup.animation.play('bruh');
			arrowup.updateHitbox();
			arrowup.setGraphicSize(Std.int(arrowup.width * 0.7));
			add(arrowup);	
			
			arrowdown = new FlxSprite(580, 550);
			arrowdown.frames = Paths.getSparrowAtlas('Achievements/arrow', 'shared');
			arrowdown.antialiasing = true;
			arrowdown.animation.addByPrefix('bruh2', 'arrow', 24);
			arrowdown.scrollFactor.set(0, 0);
			arrowdown.animation.play('bruh2');
			arrowdown.updateHitbox();
			arrowdown.setGraphicSize(Std.int(arrowdown.width * 0.7));
			arrowdown.flipY = true;
			add(arrowdown);

			prompts = new FlxSprite(25, 500).loadGraphic(Paths.image('Achievements/prompts', 'shared'));
			prompts.setGraphicSize(Std.int(prompts.width * 0.7));
			prompts.updateHitbox();
			prompts.antialiasing = true;
			prompts.scrollFactor.set(1, 1);
			prompts.active = false;
			add(prompts);
             
			//week complete shit
			
            if (FlxG.save.data.WeekAngel)
			{
			    if (FlxG.save.data.WeekAngelHard)
				{
				ac = new FlxSprite(25, 225).loadGraphic(Paths.image('Achievements/Angel', 'shared'));
				}
				else
				{
				ac = new FlxSprite(25, 225).loadGraphic(Paths.image('Achievements/AngelEasy', 'shared'));
				}
			}
			else
			{
				ac = new FlxSprite(25, 225).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac.alpha = 0.5;
			}
			ac.setGraphicSize(Std.int(ac.width * 0.7));
			ac.updateHitbox();
			ac.antialiasing = true;
			ac.scrollFactor.set(1, 1);
			ac.active = false;
			add(ac);
			
            if (FlxG.save.data.WeekDemon)
			{
			    if (FlxG.save.data.WeekDemonHard)
				{
				ac0 = new FlxSprite(725, 225).loadGraphic(Paths.image('Achievements/Demon', 'shared'));
				}
				else
				{
				ac0 = new FlxSprite(725, 225).loadGraphic(Paths.image('Achievements/DemonEasy', 'shared'));
				}
			}
			else
			{
				ac0 = new FlxSprite(725, 225).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac0.alpha = 0.5;
			}
			ac0.setGraphicSize(Std.int(ac0.width * 0.7));
			ac0.updateHitbox();
			ac0.antialiasing = true;
			ac0.scrollFactor.set(1, 1);
			ac0.active = false;
			add(ac0);
			
			//specific songs
           

		   if (FlxG.save.data.beaten || FlxG.save.data.WeekDemon)
			{
				ac1 = new FlxSprite(25, -175).loadGraphic(Paths.image('Achievements/DecEasy', 'shared'));
			}
			else
			{
				ac1 = new FlxSprite(25, -175).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac1.alpha = 0.5;
			}
			ac1.setGraphicSize(Std.int(ac1.width * 0.7));
			ac1.updateHitbox();
			ac1.antialiasing = true;
			ac1.scrollFactor.set(1, 1);
			ac1.active = false;
			add(ac1);
			
            if (FlxG.save.data.beatenAngel || FlxG.save.data.WeekAngel)
			{
				ac2 = new FlxSprite(25, 25).loadGraphic(Paths.image('Achievements/InnEasy', 'shared'));
			}
			else
			{
				ac2 = new FlxSprite(25, 25).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac2.alpha = 0.5;
			}
			ac2.setGraphicSize(Std.int(ac2.width * 0.7));
			ac2.updateHitbox();
			ac2.antialiasing = true;
			ac2.scrollFactor.set(1, 1);
			ac2.active = false;
			add(ac2);
			
			if (FlxG.save.data.beatenHard || FlxG.save.data.WeekDemonHard)
			{
				ac3 = new FlxSprite(725, -175).loadGraphic(Paths.image('Achievements/Dec', 'shared'));
			}
			else
			{
				ac3 = new FlxSprite(725, -175).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac3.alpha = 0.5;
			}
			ac3.setGraphicSize(Std.int(ac3.width * 0.7));
			ac3.updateHitbox();
			ac3.antialiasing = true;
			ac3.scrollFactor.set(1, 1);
			ac3.active = false;
			add(ac3);
			
			if (FlxG.save.data.beatenAngelHard || FlxG.save.data.WeekAngelHard)
			{
				ac4 = new FlxSprite(725, 25).loadGraphic(Paths.image('Achievements/Inn', 'shared'));
			}
			else
			{
				ac4 = new FlxSprite(725, 25).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac4.alpha = 0.5;
			}
			ac4.setGraphicSize(Std.int(ac4.width * 0.7));
			ac4.updateHitbox();
			ac4.antialiasing = true;
			ac4.scrollFactor.set(1, 1);
			ac4.active = false;
			add(ac4);
			
            //SECOND SET
			
			if (FlxG.save.data.beatenDeli)
			{
				ac5 = new FlxSprite(25, -775).loadGraphic(Paths.image('Achievements/DelEasy', 'shared'));
			}
			else
			{
				ac5 = new FlxSprite(25, -775).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac5.alpha = 0.5;
			}
			ac5.setGraphicSize(Std.int(ac5.width * 0.7));
			ac5.updateHitbox();
			ac5.antialiasing = true;
			ac5.scrollFactor.set(1, 1);
			ac5.active = false;
			add(ac5);
			
			if (FlxG.save.data.beatenKeeps)
			{
				ac9 = new FlxSprite(25, -575).loadGraphic(Paths.image('Achievements/AvaEasy', 'shared'));
			}
			else
			{
				ac9 = new FlxSprite(25, -575).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac9.alpha = 0.5;
			}
			ac9.setGraphicSize(Std.int(ac9.width * 0.7));
			ac9.updateHitbox();
			ac9.antialiasing = true;
			ac9.scrollFactor.set(1, 1);
			ac9.active = false;
			add(ac9);
			
			if (FlxG.save.data.beatenKeepsHard)
			{
				ac10 = new FlxSprite(725, -575).loadGraphic(Paths.image('Achievements/Ava', 'shared'));
			}
			else
			{
				ac10 = new FlxSprite(725, -575).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac10.alpha = 0.5;
			}
			ac10.setGraphicSize(Std.int(ac10.width * 0.7));
			ac10.updateHitbox();
			ac10.antialiasing = true;
			ac10.scrollFactor.set(1, 1);
			ac10.active = false;
			add(ac10);
			
            if (FlxG.save.data.beatenBb)
			{
				ac6 = new FlxSprite(25, -375).loadGraphic(Paths.image('Achievements/AccEasy', 'shared'));
			}
			else
			{
				ac6 = new FlxSprite(25, -375).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac6.alpha = 0.5;
			}
			ac6.setGraphicSize(Std.int(ac6.width * 0.7));
			ac6.updateHitbox();
			ac6.antialiasing = true;
			ac6.scrollFactor.set(1, 1);
			ac6.active = false;
			add(ac6);
			
			if (FlxG.save.data.beatenDeliHard)
			{
				ac7 = new FlxSprite(725, -775).loadGraphic(Paths.image('Achievements/Del', 'shared'));
			}
			else
			{
				ac7 = new FlxSprite(725, -775).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac7.alpha = 0.5;
			}
			ac7.setGraphicSize(Std.int(ac7.width * 0.7));
			ac7.updateHitbox();
			ac7.antialiasing = true;
			ac7.scrollFactor.set(1, 1);
			ac7.active = false;
			add(ac7);
			
			if (FlxG.save.data.WeekAngelHard && FlxG.save.data.WeekDemonHard && FlxG.save.data.beatenBbHard && FlxG.save.data.beatenKeepsHard && FlxG.save.data.beatenDeliHard)
			{
				ac11 = new FlxSprite(375, -975);
				ac11.frames = Paths.getSparrowAtlas('Achievements/platgod','shared');
				ac11.animation.addByPrefix('shine','god',24,false);
				ac11.animation.play('shine');
			}
			else
			{
				ac11 = new FlxSprite(375, -975).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac11.alpha = 0.5;
				ac11.active = false;
			}
			ac11.setGraphicSize(Std.int(ac11.width * 0.7));
			ac11.updateHitbox();
			ac11.antialiasing = true;
			ac11.scrollFactor.set(1, 1);
			add(ac11);
			
			if (FlxG.save.data.beatenBbHard)
			{
				ac8 = new FlxSprite(725, -375).loadGraphic(Paths.image('Achievements/Acc', 'shared'));
			}
			else
			{
				ac8 = new FlxSprite(725, -375).loadGraphic(Paths.image('Achievements/Nope', 'shared'));
				ac8.alpha = 0.5;
			}
			ac8.setGraphicSize(Std.int(ac8.width * 0.7));
			ac8.updateHitbox();
			ac8.antialiasing = true;
			ac8.scrollFactor.set(1, 1);
			ac8.active = false;
			add(ac8);

        //if (FlxG.save.data.beatenHard) --demon

        //if (FlxG.save.data.beatenAngelHard) --angel
	
        //if (FlxG.save.data.beatenBbHard) --bb

		// magenta.scrollFactor.set();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
			
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

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
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
		{
			if (FlxG.keys.justPressed.UP)
				if (camFollow.y <= -641)
				{
				}
				else
				{
				camFollow.y -= 200;
				}
			else if (FlxG.keys.justPressed.DOWN)
			    if (camFollow.y >= 359)
				{
				}
				else
				{
				camFollow.y += 200;
				}
			else
				camFollow.y += 0;
				
			trace(camFollow.y);
		}
		
		if (camFollow.y >= 359)
		{
		    arrowdown.visible = false;
			prompts.visible = true;
		}
		else if (camFollow.y <= -641)
		{
		    arrowup.visible = false;
		}
		else
		{
		    arrowdown.visible = true;
			arrowup.visible = true;
			prompts.visible = false;
		}

	}
}
