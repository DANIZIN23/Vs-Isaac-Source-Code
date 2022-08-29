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
import flash.system.System;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var platgod:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	//used to say 1.5.1, had to change it manually. I'm sure this is 1.5.4, idk why that happened. weird.
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var Pedestal:FlxSprite;
	var Note:FlxSprite;
	var Incubus:FlxSprite;
	var mom:FlxSprite;
	var creepyshit:Bool;
	var demon:FlxSprite;
	var angel:FlxSprite;
	var bg:FlxSprite;
	var rottenbaby:FlxSprite;
	var bb:FlxSprite;
	var freezer:FlxSprite;
	var marked:FlxSprite;
	var menuItem:FlxSprite;
	var versionShit:FlxText;
	var FREEZER:FlxSprite;
	var finished:Bool;
	var steven:FlxSprite;
	var crash:FlxSprite;
	var babyplum:FlxSprite;
	var darkbum:FlxSprite;
	var gurdy:FlxSprite;
	var logoanim:FlxSprite;
	var nonexistent:FlxSprite;
	var camFollow:FlxObject;
	var RagMan:FlxSprite;
	var Forgor:FlxSprite;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('MenuIsaac'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-15).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 0.7));
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);
		
		var diceroll = FlxG.random.float(0,500);
			if (diceroll >= 0 && diceroll <= 49.8)
			{
			
				
				
				Pedestal = new FlxSprite(-230, 470).loadGraphic(Paths.image('menu/Pedestal', 'shared'));
		        Pedestal.updateHitbox();
		        Pedestal.scrollFactor.x = 0;
	 	        Pedestal.scrollFactor.y = 0;
	            Pedestal.antialiasing = true;
                Pedestal.active = false;
		        add(Pedestal);
		
		        Incubus = new FlxSprite(0, 120);
		        Incubus.frames = Paths.getSparrowAtlas('menu/Incubus', 'shared');
		        Incubus.antialiasing = true;
		        Incubus.scrollFactor.x = 0;
		        Incubus.scrollFactor.y = 0;
		        Incubus.animation.addByPrefix('flap', 'flappybird', 24);
		        Incubus.animation.play('flap');
		        Incubus.updateHitbox();
		        add(Incubus);
				
			    logoanim = new FlxSprite(315, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			else if (diceroll >= 50 && diceroll <= 99.8)
			{
				Pedestal = new FlxSprite(680, 470).loadGraphic(Paths.image('menu/Pedestal', 'shared'));
		        Pedestal.updateHitbox();
		        Pedestal.scrollFactor.x = 0;
	 	        Pedestal.scrollFactor.y = 0;
	            Pedestal.antialiasing = true;
                Pedestal.active = false;
		        add(Pedestal);
		
		        darkbum = new FlxSprite(950, 240);
		        darkbum.frames = Paths.getSparrowAtlas('menu/darkbum', 'shared');
		        darkbum.antialiasing = true;
		        darkbum.scrollFactor.x = 0;
		        darkbum.scrollFactor.y = 0;
		        darkbum.animation.addByPrefix('beat', 'dbum', 24);
		        darkbum.animation.play('beat');
		        darkbum.updateHitbox();
		        add(darkbum);
				
			    logoanim = new FlxSprite(-165, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 100 && diceroll <= 149.8)
			{

		
		        mom = new FlxSprite(30, -25);
		        mom.frames = Paths.getSparrowAtlas('menu/mom', 'shared');
		        mom.antialiasing = true;
		        mom.scrollFactor.x = 0;
		        mom.scrollFactor.y = 0;
		        mom.animation.addByPrefix('beat', 'mombeat', 24);
		        mom.animation.play('beat');
		        mom.updateHitbox();
		        mom.setGraphicSize(Std.int(mom.width * 0.7));
		        add(mom);
				
			}
			
			else if (diceroll >= 150 && diceroll <= 199.8)
			{

		
				Pedestal = new FlxSprite(-200, 520).loadGraphic(Paths.image('menu/Pedestal', 'shared'));
		        Pedestal.updateHitbox();
		        Pedestal.scrollFactor.x = 0;
	 	        Pedestal.scrollFactor.y = 0;
	            Pedestal.antialiasing = true;
                Pedestal.active = false;
		        add(Pedestal);
				
				rottenbaby = new FlxSprite(-100, 35);
		        rottenbaby.frames = Paths.getSparrowAtlas('menu/rottenbaby', 'shared');
		        rottenbaby.antialiasing = true;
		        rottenbaby.scrollFactor.x = 0;
		        rottenbaby.scrollFactor.y = 0;
		        rottenbaby.animation.addByPrefix('breathe', 'rotten', 24);
		        rottenbaby.animation.play('breathe');
		        rottenbaby.updateHitbox();
		        rottenbaby.setGraphicSize(Std.int(rottenbaby.width * 0.6));
				rottenbaby.flipX = true;
		        add(rottenbaby);
				
			    logoanim = new FlxSprite(315, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
				
			}
			
			else if (diceroll >= 200 && diceroll <= 249.8)
			{
		
		        steven = new FlxSprite(675, -50);
		        steven.frames = Paths.getSparrowAtlas('menu/steven', 'shared');
		        steven.antialiasing = true;
		        steven.scrollFactor.x = 0;
		        steven.scrollFactor.y = 0;
		        steven.animation.addByPrefix('beat', 'steven', 24);
		        steven.animation.play('beat');
		        steven.updateHitbox();
		        steven.setGraphicSize(Std.int(steven.width * 0.6));
		        add(steven);
				
			    logoanim = new FlxSprite(-165, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 250 && diceroll <= 299.8)
			{
		
		        babyplum = new FlxSprite(750, 75);
		        babyplum.frames = Paths.getSparrowAtlas('menu/babyplum', 'shared');
		        babyplum.antialiasing = true;
		        babyplum.scrollFactor.x = 0;
		        babyplum.scrollFactor.y = 0;
		        babyplum.animation.addByPrefix('beat', 'daplum', 24);
		        babyplum.animation.play('beat');
		        babyplum.updateHitbox();
		        babyplum.setGraphicSize(Std.int(babyplum.width * 0.7));
		        add(babyplum);
				
			    logoanim = new FlxSprite(-165, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 300 && diceroll <= 349.8)
			{
		
		        gurdy = new FlxSprite(450, -150);
		        gurdy.frames = Paths.getSparrowAtlas('menu/gurdy', 'shared');
		        gurdy.antialiasing = true;
		        gurdy.scrollFactor.x = 0;
		        gurdy.scrollFactor.y = 0;
		        gurdy.animation.addByPrefix('beat', 'gurdy', 24);
		        gurdy.animation.play('beat');
		        gurdy.updateHitbox();
		        gurdy.setGraphicSize(Std.int(gurdy.width * 0.7));
		        add(gurdy);
				
			    logoanim = new FlxSprite(-165, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 300 && diceroll <= 349.8)
			{
		
		        gurdy = new FlxSprite(450, -150);
		        gurdy.frames = Paths.getSparrowAtlas('menu/gurdy', 'shared');
		        gurdy.antialiasing = true;
		        gurdy.scrollFactor.x = 0;
		        gurdy.scrollFactor.y = 0;
		        gurdy.animation.addByPrefix('beat', 'gurdy', 24);
		        gurdy.animation.play('beat');
		        gurdy.updateHitbox();
		        gurdy.setGraphicSize(Std.int(gurdy.width * 0.7));
		        add(gurdy);
				
			    logoanim = new FlxSprite(-165, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 350 && diceroll <= 399.8)
			{
		
		        RagMan = new FlxSprite(-225, 125);
		        RagMan.frames = Paths.getSparrowAtlas('menu/RagMan', 'shared');
		        RagMan.antialiasing = true;
		        RagMan.scrollFactor.x = 0;
		        RagMan.scrollFactor.y = 0;
		        RagMan.animation.addByPrefix('fire', 'ragboi', 24);
		        RagMan.animation.play('fire');
		        RagMan.updateHitbox();
		        RagMan.setGraphicSize(Std.int(RagMan.width * 0.8));
		        add(RagMan);
				
			    logoanim = new FlxSprite(315, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			else if (diceroll >= 400 && diceroll <= 449.8)
			{
		
		        Forgor = new FlxSprite(-150, -35);
		        Forgor.frames = Paths.getSparrowAtlas('menu/I forgor', 'shared');
		        Forgor.antialiasing = true;
		        Forgor.scrollFactor.x = 0;
		        Forgor.scrollFactor.y = 0;
		        Forgor.animation.addByPrefix('skeletonsansundertale', 'forgotten', 24);
		        Forgor.animation.play('skeletonsansundertale');
		        Forgor.updateHitbox();
		        Forgor.setGraphicSize(Std.int(Forgor.width * 0.7));
		        add(Forgor);
				
			    logoanim = new FlxSprite(315, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			
			
			
			else if (diceroll >= 450 && diceroll <= 499.8)
			{
		
		        marked = new FlxSprite(-90, 120);
		        marked.frames = Paths.getSparrowAtlas('menu/marked', 'shared');
		        marked.antialiasing = true;
		        marked.scrollFactor.x = 0;
		        marked.scrollFactor.y = 0;
		        marked.animation.addByPrefix('beat', 'marked', 24);
		        marked.animation.play('beat');
		        marked.updateHitbox();
				marked.flipX = true;
		        marked.setGraphicSize(Std.int(marked.width * 0.7));
		        add(marked);
				
			    logoanim = new FlxSprite(315, 150);
		        logoanim.frames = Paths.getSparrowAtlas('menu/LogoAnim', 'shared');
		        logoanim.antialiasing = true;
		        logoanim.scrollFactor.x = 0;
		        logoanim.scrollFactor.y = 0;
		        logoanim.animation.addByPrefix('bnc', 'bounce', 24);
		        logoanim.animation.play('bnc');
		        logoanim.updateHitbox();
		        logoanim.setGraphicSize(Std.int(logoanim.width * 0.7));
		        add(logoanim);
			}
			else
			{
		        freezer = new FlxSprite(0, 75);
		        freezer.frames = Paths.getSparrowAtlas('17000/FREEZER', 'shared');
		        freezer.antialiasing = true;
		        freezer.scrollFactor.x = 0;
		        freezer.scrollFactor.y = 0;
		        freezer.animation.addByPrefix('glitch', 'keepout', 24);
		        freezer.animation.play('glitch');
		        freezer.updateHitbox();
		        freezer.setGraphicSize(Std.int(freezer.width * 0.7));
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('17000'));
				
		        add(freezer);
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					crash.alpha = 6.66;
				});
			}



		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			menuItem = new FlxSprite(160, FlxG.height * 1);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.5));
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

				finishedFunnyMove = true; 
				changeItem();
				menuItem.y = 20 + (i * 100);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		versionShit = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
	
        if (FlxG.keys.justPressed.A)
		{
		    FlxG.switchState(new AchievementState());
		}
		
        if (FlxG.keys.justPressed.C)
		{
		    FlxG.switchState(new CreditsState());
		}
		
		
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				if (creepyshit)
				{
				
				}
				else
				{
				FlxG.sound.play(Paths.sound('scrollup'));
				changeItem(-1);
				}
			}

			if (controls.DOWN_P)
			{
			    if (creepyshit)
				{
				
				}
				else
				{
				FlxG.sound.play(Paths.sound('scrolldown'));
				changeItem(1);
				}
			}

			if (controls.BACK)
			{
				if (creepyshit)
				{
				
				}
				else
				{
					FlxG.switchState(new QuitState());
				}
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{

				}
				if (creepyshit)
				{
				
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
									goToState();
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		
		var daChoice:String = optionShit[curSelected];

		if (creepyshit)
		{
		switch (daChoice)
		{
			case 'story mode':
				add(nonexistent);
				trace("Story Menu Selected");
			case 'freeplay':
				add(nonexistent);

				trace("Freeplay Menu Selected");

			case 'options':
				add(nonexistent);
		}
		}
		else

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (creepyshit)
		{

		}
		else
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
