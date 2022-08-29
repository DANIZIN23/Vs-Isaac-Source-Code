package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Sacrificial', 'Innermost Apocalypse'],
		['Misperception', 'Decide']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
	];

	var weekNames:Array<String> = [
		"GOOD PATH",
		"EVIL PATH",
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;
	var selected:Bool = false;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var enter:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var weekicons:FlxSprite;
	var updown:FlxSprite;
	var difficulty:FlxText;
	var whoami:FlxSprite;
	var daangel:FlxSprite;
	var dademon:FlxSprite;
	var storyblood:FlxSprite;


	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('MenuIsaac'));
		}

		persistentUpdate = persistentDraw = true;
		
		bg2 = new FlxSprite(0, 0).loadGraphic(Paths.image('paperbg'));
		bg2.scrollFactor.x = 0;
		bg2.scrollFactor.y = 0;
		bg2.setGraphicSize(Std.int(bg2.width * 0.7));
		bg2.updateHitbox();
		bg2.antialiasing = true;
		add(bg2);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat(32, FlxColor.BLACK);

		txtWeekTitle = new FlxText(25, 625, "", 32);
		txtWeekTitle.setFormat(48, FlxColor.BLACK, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);
		
		bg = new FlxSprite(0, -125).loadGraphic(Paths.image('paperfg'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 0.7));
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);
		
		updown = new FlxSprite(375, 585).loadGraphic(Paths.image('updown'));
		updown.scrollFactor.x = 0;
		updown.scrollFactor.y = 0;
		updown.updateHitbox();
		updown.antialiasing = true;
		add(updown);
		
		enter = new FlxSprite(450, 460).loadGraphic(Paths.image('enter'));
		enter.scrollFactor.x = 0;
		enter.scrollFactor.y = 0;
		enter.updateHitbox();
		enter.setGraphicSize(Std.int(enter.width * 0.7));
		enter.antialiasing = true;
		add(enter);
		
		storyblood = new FlxSprite(0, 0).loadGraphic(Paths.image('storyblood'));
		storyblood.scrollFactor.x = 0;
		storyblood.scrollFactor.y = 0;
		storyblood.setGraphicSize(Std.int(storyblood.width * 0.67));
		storyblood.updateHitbox();
		storyblood.alpha = 0;
		storyblood.antialiasing = true;
		add(storyblood);
		
		whoami = new FlxSprite(25, 75).loadGraphic(Paths.image('whoami'));
		whoami.scrollFactor.x = 0;
		whoami.scrollFactor.y = 0;
		whoami.updateHitbox();
		whoami.setGraphicSize(Std.int(whoami.width * 0.8));
		whoami.antialiasing = true;
		add(whoami);
		

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.visible = false;

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(850, 600);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		
		
        difficulty = new FlxText(965,550,"Difficulty:");
        difficulty.size = 34;
        difficulty.setFormat(34, FlxColor.BLACK);
		add(difficulty);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat(32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();

		// FlxG.watch.addQuick('font', scoreText.font);
		

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
						FlxG.sound.play(Paths.sound('scrollup'), 0.4);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
						FlxG.sound.play(Paths.sound('scrolldown'), 0.4);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				enter.visible = false;
				updown.visible = false;
				sprDifficulty.visible = false;
				remove(difficulty);
				remove(txtWeekTitle);
				FlxG.camera.flash(FlxColor.WHITE, 3);
				leftArrow.visible = false;
				rightArrow.visible = false;
			    		
				if (curWeek == 0)
				{
		        daangel = new FlxSprite(25, 75).loadGraphic(Paths.image('daangel'));
		        daangel.scrollFactor.x = 0;
		        daangel.scrollFactor.y = 0;
		        daangel.updateHitbox();
		        daangel.setGraphicSize(Std.int(daangel.width * 0.8));
		        daangel.antialiasing = true;
		        add(daangel);
				whoami.visible = false;
				}
				else
				{
		        dademon = new FlxSprite(25, 75).loadGraphic(Paths.image('dademon'));
		        dademon.scrollFactor.x = 0;
		        dademon.scrollFactor.y = 0;
		        dademon.updateHitbox();
		        dademon.setGraphicSize(Std.int(dademon.width * 0.8));
		        dademon.antialiasing = true;
		        add(dademon);
				whoami.visible = false;
				}
				
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			if (selected)
			{
			}
			else
			{
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('weekselect'));
			selected = true;
			//so the shit sound doesn't play again when u skip the cutscene
			}
			
			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
			    var video:MP4Handler = new MP4Handler();
                video.playMP4(Paths.video('drawintro'));
				video.finishCallback = function()
				{
				    LoadingState.loadAndSwitchState(new PlayState(), true);
				}
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
			
		if (curDifficulty == 2)
		{
		        storyblood.alpha = 0;
				storyblood.visible = true;
			    new FlxTimer().start(0.05, function(bloodTimer:FlxTimer)
			    {
				    storyblood.alpha += 0.05;
				    if (storyblood.alpha < 1)
				    {
					    bloodTimer.reset();
				    }
				    else
				    {
				    }
			    });
		}
		else
		{
			    storyblood.alpha = 0;
				storyblood.visible = false;
		}

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.5;
			bullShit++;
		}
		
		

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
