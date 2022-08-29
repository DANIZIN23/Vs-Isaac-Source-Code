package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var MenuIdle:FlxSprite;
	var Note:FlxSprite;
	var IsaacJammin:FlxSprite;
	var hardblood:FlxSprite;
	var reallyblackscreen:FlxSprite;
	var bg:FlxSprite;
	var paper:FlxSprite;
	var paperhard:FlxSprite;
	var keeper:FlxSprite;
	var isaacb:FlxSprite;
	var portal:FlxSprite;
	var isaacc:FlxSprite;
	var isaacd:FlxSprite;
	var bb:FlxSprite;
	var stext:FlxText; //sex?!?!??! 

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		hardblood = new FlxSprite(0, 0).loadGraphic(Paths.image('hardblood'));
		hardblood.scrollFactor.x = 0;
		hardblood.scrollFactor.y = 0;
		hardblood.setGraphicSize(Std.int(hardblood.width * 0.67));
		hardblood.updateHitbox();
		hardblood.alpha = 0;
		hardblood.antialiasing = true;
		add(hardblood);
		
		keeper = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/keeper', 'shared'));
		keeper.scrollFactor.x = 0;
		keeper.scrollFactor.y = 0;
		keeper.setGraphicSize(Std.int(keeper.width * 0.67));
		keeper.updateHitbox();
		keeper.visible = false;
		keeper.antialiasing = true;
		add(keeper);
		
		bb = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/bb', 'shared'));
		bb.scrollFactor.x = 0;
		bb.scrollFactor.y = 0;
		bb.setGraphicSize(Std.int(bb.width * 0.67));
		bb.updateHitbox();
		bb.visible = false;
		bb.antialiasing = true;
		add(bb);
	
		isaacb = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/isaacb', 'shared'));
		isaacb.scrollFactor.x = 0;
		isaacb.scrollFactor.y = 0;
		isaacb.setGraphicSize(Std.int(isaacb.width * 0.67));
		isaacb.updateHitbox();
		isaacb.visible = false;
		isaacb.antialiasing = true;
		add(isaacb);
		
		isaacc = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/isaacc', 'shared'));
		isaacc.scrollFactor.x = 0;
		isaacc.scrollFactor.y = 0;
		isaacc.setGraphicSize(Std.int(isaacc.width * 0.67));
		isaacc.updateHitbox();
		isaacc.visible = false;
		isaacc.antialiasing = true;
		add(isaacc);
		
		isaacd = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/isaacd', 'shared'));
		isaacd.scrollFactor.x = 0;
		isaacd.scrollFactor.y = 0;
		isaacd.setGraphicSize(Std.int(isaacd.width * 0.67));
		isaacd.updateHitbox();
		isaacd.visible = false;
		isaacd.antialiasing = true;
		add(isaacd);
		
				portal = new FlxSprite(510, 230);
				portal.frames = Paths.getSparrowAtlas('void/bg','shared');
				portal.animation.addByPrefix('idle', 'void', 24);
				portal.animation.play('idle');
			    portal.updateHitbox();
				portal.alpha = 0.5;
				portal.visible = false;
				portal.screenCenter();
				portal.scrollFactor.set();
				portal.scale.set(7, 7);
			    portal.antialiasing = false;
				add(portal);
		
		paper = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/paper', 'shared'));
		paper.scrollFactor.x = 0;
		paper.scrollFactor.y = 0;
		paper.setGraphicSize(Std.int(paper.width * 0.6));
		paper.updateHitbox();
		paper.antialiasing = true;
		add(paper);
		
		paperhard = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/paperhard', 'shared'));
		paperhard.scrollFactor.x = 0;
		paperhard.scrollFactor.y = 0;
		paperhard.setGraphicSize(Std.int(paperhard.width * 0.6));
		paperhard.updateHitbox();
		paperhard.alpha = 0;
		paperhard.antialiasing = true;
		add(paperhard);
		
		var arrows:FlxSprite = new FlxSprite(-150, 0);
		arrows.frames = Paths.getSparrowAtlas('freeplay/lazyarrows','shared');
		arrows.animation.addByPrefix('duh','arrow',24,true);
		arrows.animation.play('duh');
		arrows.screenCenter(Y);
		arrows.antialiasing = true;
		arrows.setGraphicSize(Std.int(arrows.width * 0.67));
		add(arrows);
		
			    new FlxTimer().start(0.1, function(blacktimer:FlxTimer)
			    {
				    if (reallyblackscreen.alpha > 0)
					{
						reallyblackscreen.alpha -= 0.05;
						blacktimer.reset();
					}
					else
				    {
					    blacktimer.reset();
				    }
			    });
		

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, 0, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			songText.y += 340;
			songText.x += 90;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		stext = new FlxText(100, 425);
		stext.setFormat(Paths.font("upheavtt.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(stext);
		
				reallyblackscreen = new FlxSprite(-800, -600).makeGraphic(Std.int(FlxG.width * 4), Std.int(FlxG.height * 4), FlxColor.BLACK);
				reallyblackscreen.scrollFactor.set();
				reallyblackscreen.alpha = 0;
		        add(reallyblackscreen);
		
		scoreText = new FlxText(15, 15, 0, "", 24);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("upheavtt.ttf"), 24, FlxColor.BLACK, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;


		diffText = new FlxText(scoreText.x, scoreText.y + 25, 0, "", 24);
		diffText.setFormat(Paths.font("upheavtt.ttf"), 24, FlxColor.BLACK, RIGHT);
		add(diffText);

		add(scoreText);
		

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST: " + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		
		//fak u

		if (upP)
		{
			changeSelection(-1);
			FlxG.sound.play(Paths.sound('scrollup'), 0.4);
		}
		if (downP)
		{
			changeSelection(1);
			FlxG.sound.play(Paths.sound('scrolldown'), 0.4);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{	
			var poop:String = Highscore.formatSong(StringTools.replace(songs[curSelected].songName," ", "-").toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, StringTools.replace(songs[curSelected].songName," ", "-").toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
			
		if (curDifficulty == 2)
		{
		        paperhard.alpha = 0;
				paperhard.visible = true;
			    new FlxTimer().start(0.05, function(bloodTimer:FlxTimer)
			    {
				    paperhard.alpha += 0.05;
				    if (paperhard.alpha < 1)
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
			    paperhard.alpha = 0;
				paperhard.visible = false;
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "<> EASY";
			case 1:
				diffText.text = '<> NORMAL';
			case 2:
				diffText.text = "<> ETERNAL";
		}
		
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		

		curSelected += change;


		if (FlxG.save.data.WeekAngel || FlxG.save.data.WeekDemon)
		{
		if (curSelected < 0)
			curSelected = 6;
			(changeSelection);
		if (curSelected > 6)
			curSelected = 0;
			(changeSelection);
		}
		else
		{
		if (curSelected < 0)
			curSelected = 3;
			(changeSelection);
		if (curSelected > 3)
			curSelected = 0;
			(changeSelection);
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0;
		}

		iconArray[curSelected].alpha = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		keeper.visible = false;
		bb.visible = false;
		isaacb.visible = false;
		isaacc.visible = false;
		isaacd.visible = false;
		portal.visible = false;
		
		switch (curSelected)
		{
			case 0:
				stext.text = "First Contact.";
				isaacb.visible = true;
			case 1:
				stext.text = 'ascend.';
				isaacc.visible = true;
			case 2:
				stext.text = "corrupted by sin.";
				isaacb.visible = true;
			case 3:
				stext.text = "my true self.";
				isaacd.visible = true;
			case 4:
				stext.text = "And then... He saw nothing.";
				bb.visible = true;
			case 5:
				stext.text = "Give me a voice.";
				keeper.visible = true;
			case 6:
				stext.text = "It's all in the mind.";
				portal.visible = true;
			default:
				stext.text = "eat ass";
		}
		
		reallyblackscreen.alpha = 1;

		
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
