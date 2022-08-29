package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	var trasheffect:FlxSprite;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var dad:Character;
	public static var isaacshifting:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var shakeEffect:Bool = false; 
	private var redflash:Bool = false; 
    private var shakeEffectCont:Bool = false; 
	private var startingSong:Bool = false;
	public var canhitspace:Bool = false;
	public var excited:Bool = false;
	public var paralyzed:Bool = false;
	public var addedtimer:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var camHP:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var Staticlol:FlxSprite;
	var darksmoke:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var holylight:FlxSprite;
	var staticlol:FlxSprite;
	var gfbrim:FlxSprite;
	var darknesseff:FlxSprite;
	var darknessanim:FlxSprite;
	var blindanim:FlxSprite;
	var qmark:FlxSprite;
	var trainSound:FlxSound;
	var gapers:FlxSprite;
	var flies:FlxSprite;
	var spaceprompt:FlxSprite;
	var basement:FlxSprite;
	var portal:FlxSprite;
	var paralyzedeffect:FlxSprite;
	var bg:FlxSprite;
	var basementvoid:FlxSprite;
	var chestvoid:FlxSprite;
	var drvoid:FlxSprite;
	var effectTween:FlxTween;
	var effectTween2:FlxTween;
	var effectTween3:FlxTween;
	var delistatic:FlxSprite;
	var end:FlxSprite;
	var miscLerp:Float = 0.09;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var shine:FlxSprite;
	var shine1:FlxSprite;
	var shine2:FlxSprite;
	var shine3:FlxSprite;
	var darkroomdecor:FlxSprite;
	var darkroomdecor2:FlxSprite;
	var IsaacInChest:FlxSprite;
	var House:FlxSprite;
	var chestidle:FlxSprite;
	var GFdisappointed:FlxSprite;
	var trashitem:FlxSprite;
	var blackscreen:FlxSprite;
	var phd:FlxSprite;
	var reallyblackscreen:FlxSprite;
	var songending:Bool = false; 
	var canblind:Bool = false;
	var vanishnotes:Bool = false;
	var vanishnotesd:Bool = false;
	var retrovision:Bool = false;
	var rain:FlxSound;
	var tearsplash:FlxSprite;
	var angelsmoke:FlxSprite;
	var demonsmoke:FlxSprite;
	var introText:FlxSprite;
	var Roundworm:FlxSprite;
	var shopitems:FlxSprite;
	var camX:Int = 0;
	var camY:Int = 0;
	var bfcamX:Int = 0;
	var bfcamY:Int = 0;
	var pilltext:FlxText;
	//stolen code from sonic.exe, lol https://github.com/CryBitDev/Sonic.exe-source-1.5-and-2/blob/master/source/PlayState.hx

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var arroweffect:MosaicEffect = new MosaicEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	public var paralyzedbreak:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;


		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHP = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHP.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
		    case 'basement':
			{
				curStage = 'basement';

			    basement = new FlxSprite(-520, -210).loadGraphic(Paths.image('basement'));
			    basement.setGraphicSize(Std.int(basement.width * 0.85));
			    basement.updateHitbox();
			    basement.antialiasing = true;
			    basement.scrollFactor.set(0.9, 0.9);
			    basement.active = false;
			    add(basement);
		
				Roundworm = new FlxSprite(1200, 500);
			    remove(Roundworm);
			    Roundworm.frames = Paths.getSparrowAtlas('Rworm','shared');
				Roundworm.scrollFactor.set(0.9, 0.9);
			    Roundworm.animation.addByPrefix('yo','hey',24,false);
			    Roundworm.animation.play('yo');
				Roundworm.antialiasing = true;
				Roundworm.visible = false;
			    add(Roundworm);
			    Roundworm.animation.finishCallback = function(name:String) {
			    	remove(Roundworm);		
			    }
				
			    gapers = new FlxSprite(-600, 700);
		        gapers.frames = Paths.getSparrowAtlas('gapersanim', 'shared');
		        gapers.antialiasing = true;
			    gapers.setGraphicSize(Std.int(gapers.width * 0.77));
		        gapers.animation.addByPrefix('bounce', 'gaper', 24);
				gapers.scrollFactor.set(1.3, 1.3);
		        gapers.updateHitbox();
				add(gapers);
				
			    flies = new FlxSprite(-200, 320);
		        flies.frames = Paths.getSparrowAtlas('flies', 'shared');
		        flies.antialiasing = true;
			    flies.setGraphicSize(Std.int(flies.width * 0.6));
		        flies.animation.addByPrefix('fly', 'bzz', 24);
				flies.scrollFactor.set(0.9, 0.9);
				flies.animation.play('fly');
		        flies.updateHitbox();
				add(flies);
				
			    Staticlol= new FlxSprite(0, 0).loadGraphic(Paths.image('Staticlol'));
			    Staticlol.scrollFactor.set(0,0);
			    Staticlol.setGraphicSize(Std.int(Staticlol.width * 1));
				Staticlol.visible = false;
				
				blackscreen = new FlxSprite(-500, -400).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackscreen.alpha = 0;
				blackscreen.scrollFactor.set();
		        add(blackscreen);

				defaultCamZoom = 0.80;
			}
			
		    case 'cathedral':
			{
				curStage = 'cathedral';

			    var cathedral:FlxSprite = new FlxSprite(-850, -800).loadGraphic(Paths.image('cathedral'));
			    cathedral.setGraphicSize(Std.int(cathedral.width * 0.90));
			    cathedral.updateHitbox();
			    cathedral.antialiasing = true;
			    cathedral.scrollFactor.set(0.9, 0.9);
			    cathedral.active = false;
			    add(cathedral);
				
		        holylight = new FlxSprite(-580, -870);
		        holylight.frames = Paths.getSparrowAtlas('holylight');
		        holylight.antialiasing = true;
		        holylight.animation.addByPrefix('glow', 'holylight', 24);
		        holylight.animation.play('glow');
				holylight.alpha = 0.5;
				holylight.visible = false;
		        holylight.updateHitbox();
				add(holylight);
				
		        angelsmoke = new FlxSprite(-1450, 350);
		        angelsmoke.frames = Paths.getSparrowAtlas('angelsmoke', 'shared');
		        angelsmoke.antialiasing = true;
		        angelsmoke.animation.addByPrefix('bruh', 'smoke', 24);
			    angelsmoke.scrollFactor.set(1, 1);
				angelsmoke.alpha = 0;
		        angelsmoke.updateHitbox();
				
				defaultCamZoom = 0.60;
			}
			
		    case 'darkroom':
			{
				
				
				var darkroombg:FlxSprite = new FlxSprite(-700, -400).loadGraphic(Paths.image('darkroombg'));
			    darkroombg.updateHitbox();
			    darkroombg.setGraphicSize(Std.int(darkroombg.width * 1.2));
			    darkroombg.antialiasing = true;
			    darkroombg.scrollFactor.set(0.3, 0.3);
			    darkroombg.active = false;
			    add(darkroombg);	

		        darkroomdecor = new FlxSprite(-500, -250);
		        darkroomdecor.frames = Paths.getSparrowAtlas('darkroomdecor');
		        darkroomdecor.antialiasing = true;
		        darkroomdecor.animation.addByPrefix('bump', 'decorbump', 24);
			    darkroomdecor.scrollFactor.set(0.4, 0.4);
		        darkroomdecor.animation.play('bump');
		        darkroomdecor.updateHitbox();
				add(darkroomdecor);	
				
		        darkroomdecor2 = new FlxSprite(900, -50);
		        darkroomdecor2.frames = Paths.getSparrowAtlas('darkroomdecor2');
		        darkroomdecor2.antialiasing = true;
		        darkroomdecor2.animation.addByPrefix('bump', 'decorbump', 24);
			    darkroomdecor2.scrollFactor.set(0.4, 0.4);
		        darkroomdecor2.animation.play('bump');
		        darkroomdecor2.updateHitbox();
				add(darkroomdecor2);

		        gfbrim = new FlxSprite(300, -100);
		        gfbrim.frames = Paths.getSparrowAtlas('gfbrim');
		        gfbrim.antialiasing = true;
		        gfbrim.animation.addByPrefix('laser', 'gfbrim', 24);
			    gfbrim.scrollFactor.set(0.6, 0.6);
		        gfbrim.animation.play('laser');
		        gfbrim.updateHitbox();
				add(gfbrim);	

		        trasheffect = new FlxSprite(-1700,-850);
		        trasheffect.frames = Paths.getSparrowAtlas('trasheffect');
		        trasheffect.antialiasing = true;
		        trasheffect.animation.addByPrefix('ass', 'red', 24);
		        trasheffect.animation.play('ass');
		        trasheffect.updateHitbox();
				trasheffect.alpha = 0;
				add(trasheffect);					

			    var darkroom:FlxSprite = new FlxSprite(-200, -700).loadGraphic(Paths.image('darkroom'));
			    darkroom.setGraphicSize(Std.int(darkroom.width * 1.4));
			    darkroom.updateHitbox();
			    darkroom.antialiasing = true;
			    darkroom.scrollFactor.set(0.95, 0.95);
			    darkroom.active = false;
			    add(darkroom);
				
				
		        demonsmoke = new FlxSprite(150, 430);
		        demonsmoke.frames = Paths.getSparrowAtlas('demonsmoke');
		        demonsmoke.antialiasing = true;
		        demonsmoke.animation.addByPrefix('blow', 'dasmoke', 24);
				//haha i said blow
			    demonsmoke.scrollFactor.set(0.95, 0.95);
		        demonsmoke.updateHitbox();	
				demonsmoke.alpha = 0;
				
				blackscreen = new FlxSprite(-700, -600).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
				blackscreen.alpha = 0.6;
				blackscreen.scrollFactor.set();
				blackscreen.visible = false;
				add(blackscreen);
				
			
				curStage = 'darkroom';
				
				defaultCamZoom = 0.50;
			}
		    case 'chest':
			{

				curStage = 'chest';
				
				var dabg:FlxSprite = new FlxSprite(-1403, -1500).loadGraphic(Paths.image('chest/bg', 'shared'));
			    dabg.updateHitbox();
			    dabg.setGraphicSize(Std.int(dabg.width * 0.74));
			    dabg.antialiasing = true;
				dabg.scrollFactor.set(0.9, 1);
			    dabg.active = false;
			    add(dabg);	
				
		        GFdisappointed = new FlxSprite(500, 100);
		        GFdisappointed.frames = Paths.getSparrowAtlas('chest/GFdisappointed', 'shared');
		        GFdisappointed.antialiasing = true;
				GFdisappointed.scrollFactor.set(0.9, 1);
		        GFdisappointed.animation.addByPrefix('dance', 'dance', 24);
		        GFdisappointed.updateHitbox();
				add(GFdisappointed);	
		
		        trashitem = new FlxSprite(420, 290);
		        trashitem.frames = Paths.getSparrowAtlas('chest/trashitem', 'shared');
		        trashitem.antialiasing = true;
				trashitem.scrollFactor.set(0.9, 1);
		        trashitem.animation.addByPrefix('bop', 'brain', 24);
		        trashitem.animation.play('bop');
		        trashitem.updateHitbox();
				add(trashitem);
				
		        chestidle = new FlxSprite(-600, -850);
		        chestidle.frames = Paths.getSparrowAtlas('chest/chestidle', 'shared');
		        chestidle.antialiasing = true;
		        chestidle.animation.addByPrefix('glow', 'idle', 24);
			    chestidle.scrollFactor.set(1, 1);
		        chestidle.animation.play('glow');
				chestidle.visible = false;
		        chestidle.updateHitbox();
				add(chestidle);	
				
				songending = false;
				rain = FlxG.sound.play(Paths.sound('rain', 'shared'), 1, true);

				
				defaultCamZoom = 0.60;
			}
			
		    case 'void':
			{	
				var effect = new MosaicEffect();
				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, 5, {type: PINGPONG}, function(v)
				{
					effect.setStrength(v, v);
				});
				
				
				//haha stolen code go brrrrr https://github.com/HaxeFlixel/flixel-demos/tree/master/Effects/MosaicEffect/source
				
				portal = new FlxSprite(510, 230);
				portal.frames = Paths.getSparrowAtlas('void/bg','shared');
				portal.animation.addByPrefix('idle', 'void', 24);
				portal.animation.play('idle');
			    portal.updateHitbox();
				portal.alpha = 0.5;
				portal.scrollFactor.set();
				portal.scale.set(9, 9);
			    portal.antialiasing = false;
				add(portal);
				
				basementvoid = new FlxSprite(-500, -300).loadGraphic(Paths.image('void/basementvoid', 'shared'));
				basementvoid.screenCenter(X);
				basementvoid.screenCenter(Y);
			    basementvoid.updateHitbox();
			    basementvoid.setGraphicSize(Std.int(basementvoid.width * 1));
			    basementvoid.antialiasing = true;
				basementvoid.scrollFactor.set();
			    basementvoid.active = false;
				basementvoid.visible = false;
				basementvoid.shader = effect.shader;
			    add(basementvoid);

				chestvoid = new FlxSprite(-500, -1600).loadGraphic(Paths.image('void/chestvoid', 'shared'));
				chestvoid.screenCenter(X);
			    chestvoid.updateHitbox();
			    chestvoid.setGraphicSize(Std.int(chestvoid.width * 0.7));
			    chestvoid.antialiasing = true;
				chestvoid.scrollFactor.set();
			    chestvoid.active = false;
				chestvoid.visible = false;
				chestvoid.shader = effect.shader;
			    add(chestvoid);
				
				drvoid = new FlxSprite(-500, -300).loadGraphic(Paths.image('void/drvoid', 'shared'));
				drvoid.screenCenter(X);
				drvoid.screenCenter(Y);
			    drvoid.updateHitbox();
			    drvoid.setGraphicSize(Std.int(drvoid.width * 1));
			    drvoid.antialiasing = true;
				drvoid.scrollFactor.set();
			    drvoid.active = false;
				drvoid.visible = false;
				drvoid.shader = effect.shader;
			    add(drvoid);
				
				staticlol = new FlxSprite(-440, -240);
		        staticlol.frames = Paths.getSparrowAtlas('staticlol');
			    staticlol.setGraphicSize(Std.int(staticlol.width * 7.2));
		        staticlol.antialiasing = false;
		        staticlol.animation.addByPrefix('move', 'Static', 24);
			    staticlol.scrollFactor.set(0, 0);
		        staticlol.animation.play('move');
		        staticlol.updateHitbox();
				staticlol.alpha = 0.1;
				staticlol.visible = false;
				add(staticlol);

				curStage = 'void';
				
				defaultCamZoom = 0.60;
			}
			
		    case 'shop':
			{
				curStage = 'shop';

			    basement = new FlxSprite(-620, -450).loadGraphic(Paths.image('shop/shopbg', 'shared'));
			    basement.setGraphicSize(Std.int(basement.width * 0.85));
			    basement.updateHitbox();
			    basement.antialiasing = true;
			    basement.scrollFactor.set(0.9, 0.9);
			    basement.active = false;
			    add(basement);
				
				shopitems = new FlxSprite(-250, 400);
			    shopitems.frames = Paths.getSparrowAtlas('shop/shopitems','shared');
				shopitems.scrollFactor.set(0.9, 0.9);
				shopitems.setGraphicSize(Std.int(shopitems.width * 0.7));
			    shopitems.animation.addByPrefix('bruh','beat',24,false);
				shopitems.antialiasing = true;
			    add(shopitems);
				
				shine = new FlxSprite(-440, -10);
		        shine.frames = Paths.getSparrowAtlas('shop/shine', 'shared');
		        shine.antialiasing = true;
		        shine.animation.addByPrefix('move', 'shine', 24);
			    shine.scrollFactor.set(0.9, 0.9);
		        shine.animation.play('move');
		        shine.updateHitbox();
				shine.alpha = 0;
				add(shine);
				
				//ridiculous ammount of coding for a shitty shine effect that 90% of ppl wont even notice :flushed:
				
				shine1 = new FlxSprite(640, 20);
		        shine1.frames = Paths.getSparrowAtlas('shop/shine', 'shared');
		        shine1.antialiasing = true;
		        shine1.animation.addByPrefix('move', 'shine', 24);
			    shine1.scrollFactor.set(0.9, 0.9);
		        shine1.animation.play('move');
		        shine1.updateHitbox();
				shine1.alpha = 0;
				add(shine1);
				
				shine2 = new FlxSprite(470, -290);
		        shine2.frames = Paths.getSparrowAtlas('shop/shine', 'shared');
		        shine2.antialiasing = true;
		        shine2.animation.addByPrefix('move', 'shine', 24);
			    shine2.scrollFactor.set(0.9, 0.9);
		        shine2.animation.play('move');
		        shine2.updateHitbox();
				shine2.alpha = 0;
				add(shine2);
				
				shine3 = new FlxSprite(1470, -10);
		        shine3.frames = Paths.getSparrowAtlas('shop/shine', 'shared');
		        shine3.antialiasing = true;
		        shine3.animation.addByPrefix('move', 'shine', 24);
			    shine3.scrollFactor.set(0.9, 0.9);
		        shine3.animation.play('move');
		        shine3.updateHitbox();
				shine3.alpha = 0;
				add(shine3);
				
				
				defaultCamZoom = 0.70;
		    }
		
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		}
		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'gfshop':
				curGf = 'gfshop';
			default:
				curGf = 'gf';
		}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);
		
		if (curStage == 'basement' && FlxG.save.data.oldisaac)
		{
		dad = new Character(100, 100, 'isaacclassic');
		}
		else if (curStage == 'cathedral' && FlxG.save.data.oldisaac)
		{
		dad = new Character(380, 200, 'angelclassic');
		}
		else
		{
		dad = new Character(100, 100, SONG.player2);
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'funkyisaac':
				dad.y += 380;
			case 'isaacangel':
				dad.y -= 80;
				dad.x -= 600;
			case 'isaacdemon':
				dad.x -= 670;
				camPos.y -= 150;
			case 'dabluebaby':
				dad.y -= 110;
				dad.x -= 290;
				dad.visible = false;
			case 'keeper':
				dad.y -= 300;
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
				
			case 'chest':
				boyfriend.y -= 60;

		}
		
		if (boyfriend.curCharacter == 'bfcandle')
		{
			boyfriend.y -= 20;
		}

		if (!PlayStateChangeables.Optimize)
		{
			if (SONG.song.toLowerCase() == 'decide')
			{
			}
			else
			{
			add(gf);
			}

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			add(boyfriend);
			
			add(dad);
		}


		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}
		
        if (curStage == 'cathedral')
		{
		add(angelsmoke);
		angelsmoke.animation.play('bruh');
			new FlxTimer().start(0.03, function(smoketimer:FlxTimer)
			{
				if (angelsmoke.alpha > 0)
				{
			        angelsmoke.alpha -= 0.05;	
					smoketimer.reset();
				}
				else
				{
					smoketimer.reset();
				}
			});
		}
		
		if (curStage == 'shop')
		{
			new FlxTimer().start(0.02, function(shinetimer:FlxTimer)
			{
				if (shine.alpha > 0)
				{
			        shine.alpha -= 0.10;	
				}
				if (shine1.alpha > 0)
				{
			        shine1.alpha -= 0.10;	
				}
				if (shine2.alpha > 0)
				{
			        shine2.alpha -= 0.10;	
				}
				if (shine3.alpha > 0)
				{
			        shine3.alpha -= 0.10;	
				}

                shinetimer.reset();
			});
			
			new FlxTimer().start(0 + FlxG.random.int(2, 4), function(shinetimer:FlxTimer)
			{
				var randomshine = FlxG.random.float(0,200);
				if (randomshine >= 0 && randomshine <= 49)
				{
				    shine.alpha = 1;
				}
				if (randomshine >= 50 && randomshine <= 99)
				{
				    shine1.alpha = 1;
				}
				if (randomshine >= 100 && randomshine <= 149)
				{
				    shine2.alpha = 1;
				}
				if (randomshine >= 150)
				{
				    shine3.alpha = 1;
				}

                shinetimer.reset();
			});
		
		}
		
        if (curStage == 'darkroom')
		{
		gf.visible = false;
		startCountdown();
		add(demonsmoke);
		demonsmoke.animation.play('blow');
			new FlxTimer().start(0.03, function(dasmoketimer:FlxTimer)
			{
				if (demonsmoke.alpha > 0)
				{
			        demonsmoke.alpha -= 0.10;	
					dasmoketimer.reset();
				}
				else
				{
					dasmoketimer.reset();
				}
			});
			new FlxTimer().start(0.02, function(trashtimer:FlxTimer)
			{
				if (trasheffect.alpha > 0)
				{
			        trasheffect.alpha -= 0.05;	
					trashtimer.reset();
				}
				else
				{
					trashtimer.reset();
				}
			});
			darknesseff = new FlxSprite(-800, -600).makeGraphic(Std.int(FlxG.width * 4), Std.int(FlxG.height * 4), FlxColor.BLACK);
			darknesseff.scrollFactor.set();
			darknesseff.cameras = [camHUD];
			darknesseff.visible = false;
			add(darknesseff);
			
		}
		
        if (SONG.song.toLowerCase() == 'acceptance' && curStage == 'chest')
		{
		IsaacInChest = new FlxSprite(-350, -200);
		IsaacInChest.frames = Paths.getSparrowAtlas('chest/IsaacInChest', 'shared');
		IsaacInChest.antialiasing = true;
		IsaacInChest.animation.addByPrefix('breath', 'Isaac', 24);
		IsaacInChest.scrollFactor.set(1, 1);
		IsaacInChest.animation.play('breath');
		IsaacInChest.cameras = [camHUD];
		IsaacInChest.updateHitbox();
		IsaacInChest.alpha = 0;
		IsaacInChest.setGraphicSize(Std.int(IsaacInChest.width * 0.67));
		add(IsaacInChest);	
		
		House = new FlxSprite(0, 0).loadGraphic(Paths.image('chest/SmallHouseOnAHill', 'shared'));
		House.antialiasing = true;
		House.setGraphicSize(Std.int(House.width * 0.67));
		House.scrollFactor.set(0, 0);
		House.active = false;
		House.cameras = [camHUD];
		House.updateHitbox();
	    add(House);
		
		end = new FlxSprite(20, 0);
		end.frames = Paths.getSparrowAtlas('chest/ending', 'shared');
		end.antialiasing = true;
		end.screenCenter();
		end.setGraphicSize(Std.int(end.width * 1));
	    end.scrollFactor.set(0, 0);
		end.animation.addByPrefix('end', 'angel', 24);
		end.updateHitbox();
		add(end);	
		end.visible = false;
		}
			
        if (SONG.song.toLowerCase() == 'delirious')
		{
			delistatic = new FlxSprite(-440, -240);
		    delistatic.frames = Paths.getSparrowAtlas('staticlol');
			delistatic.setGraphicSize(Std.int(delistatic.width * 7.2));
		    delistatic.antialiasing = false;
			delistatic.cameras = [camHUD];
		    delistatic.animation.addByPrefix('move', 'Static', 24);
			delistatic.scrollFactor.set(0, 0);
		    delistatic.animation.play('move');
		    delistatic.updateHitbox();
			delistatic.alpha = 0;
			add(delistatic);
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		
        switch(curSong.toLowerCase()){
            case 'decide':
                healthBar.createFilledBar(0xFFba0000, 0xFF31b0d1);
            case 'acceptance':
                healthBar.createFilledBar(0xFF444d89, 0xFF31b0d1);
            case 'delirious':
                healthBar.createFilledBar(0xFFf3ff6e, 0xFFff9191);
            case 'avarice':
                healthBar.createFilledBar(0xFF987133, 0xFF31b0d1);
            default:
                healthBar.createFilledBar(0xFFe2d2b4, 0xFF31b0d1);
				
            //fuck green and red healthbar, looks ass ugly lmao
        }
		
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - " + CoolUtil.difficultyFromInt(storyDifficulty) + (Main.watermarks ? " | KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');
		
		switch (curSong.toLowerCase())
		{
				
			case 'misperception':
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/misp','shared');
				introText.animation.addByPrefix('shit','mis',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				FlxG.sound.play(Paths.sound('whoop'));
				FlxG.sound.play(Paths.sound('basementintro'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
			case 'sacrificial':
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/sacr','shared');
				introText.animation.addByPrefix('shit','sac',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				FlxG.sound.play(Paths.sound('whoop'));
				FlxG.sound.play(Paths.sound('basementintro'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
			case 'decide':
			
			    var brimlaser:FlxSprite = new FlxSprite(9000, -425);
			    remove(brimlaser);
			    brimlaser.frames = Paths.getSparrowAtlas('noteeffects/brimlaser','shared');
			    brimlaser.animation.addByPrefix('beam','laser',24,false);
			    brimlaser.animation.play('beam');
			    brimlaser.setGraphicSize(Std.int(brimlaser.width * 0.7));
			    brimlaser.cameras = [camHUD];
			    add(brimlaser);
			    brimlaser.animation.finishCallback = function(name:String) {
			    	remove(brimlaser);		
			    }
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/deci','shared');
				introText.animation.addByPrefix('shit','dec',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				FlxG.sound.play(Paths.sound('whoop'));
				FlxG.sound.play(Paths.sound('darkintro'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
                if (FlxG.save.data.downscroll)
				{
				darknessanim = new FlxSprite(-450, 50);
				}
				else
				{
				darknessanim = new FlxSprite(-450, 580);
				}
			    darknessanim.frames = Paths.getSparrowAtlas('darknessanim','shared');
			    darknessanim.animation.addByPrefix('appear','darkness',24,false);
				darknessanim.visible = false;
				darknessanim.cameras = [camHUD];
				darknessanim.setGraphicSize(Std.int(darknessanim.width * 0.7));
				add(darknessanim);
			case 'innermost-apocalypse':
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/inne','shared');
				introText.animation.addByPrefix('shit','inn',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				FlxG.sound.play(Paths.sound('whoop'));
				FlxG.sound.play(Paths.sound('cathedralintro'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
                if (FlxG.save.data.downscroll)
				{
				blindanim = new FlxSprite(-450, 20);
				qmark = new FlxSprite(0, 10).loadGraphic(Paths.image('qmark', 'shared'));
				}
				else
				{
				blindanim = new FlxSprite(-450, 580);
				qmark = new FlxSprite(0, 600).loadGraphic(Paths.image('qmark', 'shared'));
				}
			    blindanim.frames = Paths.getSparrowAtlas('blindanim','shared');
			    blindanim.animation.addByPrefix('appear','blind',24,false);
				blindanim.visible = false;
				blindanim.antialiasing = true;
				blindanim.cameras = [camHUD];
				blindanim.setGraphicSize(Std.int(blindanim.width * 0.7));
				add(blindanim);
				qmark.visible = false;
				qmark.antialiasing = true;
				qmark.cameras = [camHUD];
				qmark.screenCenter(X);
				add(qmark);
			case 'delirious':
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/deli','shared');
				introText.animation.addByPrefix('shit','del',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				FlxG.sound.play(Paths.sound('whoop'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
				FlxG.sound.play(Paths.sound('voidintro'));
				FlxG.sound.play(Paths.sound('death_card_mix'));
				new FlxTimer().start(0.3, function(dstatictimer:FlxTimer)
				{
					if (paused)
					{
						delistatic.alpha += 0;
						dstatictimer.reset();
					}
					else
					{
					if (delistatic.alpha > 0)
					{
						delistatic.alpha -= 0.05;
					}
					dstatictimer.reset();
					}
				});
			case 'avarice':
							
				introText = new FlxSprite(-750, 200);
				introText.frames = Paths.getSparrowAtlas('IntroText/avar','shared');
				introText.animation.addByPrefix('shit','ava',24,false);
				introText.animation.play('shit');
				introText.setGraphicSize(Std.int(introText.width * 1));
				introText.cameras = [camHUD];
				add(introText);
				gf.x += 330;
				gf.y -= 200;
				gf.scrollFactor.set(0.9, 0.9);
				FlxG.sound.play(Paths.sound('whoop'));
				introText.animation.finishCallback = function(name:String) {
					remove(introText);	
				}
				
				if (storyDifficulty == 0)
				{
					phd = new FlxSprite(1010, 745).loadGraphic(Paths.image('shop/phd', 'shared'));
					phd.updateHitbox();
					phd.antialiasing = true;
					phd.scrollFactor.set(1, 1);
					phd.active = false;
					add(phd);
				}
				
				paralyzedeffect = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/paralyzed', 'shared'));
			    paralyzedeffect.updateHitbox();
			    paralyzedeffect.setGraphicSize(Std.int(paralyzedeffect.width * 0.7));
			    paralyzedeffect.antialiasing = true;
			    paralyzedeffect.active = false;
				paralyzedeffect.visible = false;
				paralyzedeffect.cameras = [camHUD];
				paralyzedeffect.screenCenter();
			    add(paralyzedeffect);	
				
				spaceprompt = new FlxSprite(0, 0);
				spaceprompt.frames = Paths.getSparrowAtlas('shop/spaceprompt', 'shared');
				spaceprompt.antialiasing = true;
				spaceprompt.animation.addByPrefix('button', 'spacebar', 24);
				spaceprompt.scrollFactor.set(1, 1);
				spaceprompt.animation.play('button');
				spaceprompt.visible = false;
				spaceprompt.cameras = [camHUD];
				spaceprompt.updateHitbox();
				spaceprompt.setGraphicSize(Std.int(spaceprompt.width * 0.6));
				spaceprompt.screenCenter();
				add(spaceprompt);	
		}

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
					
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
			
			    case 'delirious':
				    if (curStage == 'void')
					{
						gf.visible = false;
						
						if (FlxG.save.data.downscroll)
						{
						iconP2.y += 140;
						}
						else
						{
						iconP2.y += 120;
						}
						boyfriend.visible = false;
						new FlxTimer().start(0.03, function(statictimer:FlxTimer)
						{
							if (staticlol.alpha > 0.1)
							{
								staticlol.alpha -= 0.05;	
								statictimer.reset();
							}
							else
							{
								statictimer.reset();
							}
						});
					}
					startCountdown();
				
				
				case 'acceptance':
					if (curStage == 'chest')
					{
				    camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			        var misseffect:FlxSprite = new FlxSprite(-7000, 0);
			        misseffect.frames = Paths.getSparrowAtlas('chest/misseffect','shared');
			        misseffect.animation.addByPrefix('miss','hurt',24,false);
			        misseffect.animation.play('miss');
			        misseffect.setGraphicSize(Std.int(misseffect.width * 0.7));
				    misseffect.antialiasing = true;
				    misseffect.cameras = [camHUD];
				    misseffect.scrollFactor.set(0, 0);
			        add(misseffect);
			        misseffect.animation.finishCallback = function(name:String) {
			        	remove(misseffect);		
			        }
				    var bluebabyintro = new FlxSprite(-600,-850);
					bluebabyintro.frames = Paths.getSparrowAtlas('chest/bluebabyintro','shared');
					bluebabyintro.animation.addByPrefix('spawn','intro',24,false);
					bluebabyintro.visible = false;
					bluebabyintro.antialiasing = true;
					healthBar.visible = false;
					healthBarBG.visible = false;
					scoreTxt.visible = false;
					kadeEngineWatermark.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
					add(bluebabyintro);
					FlxTween.tween(camHUD, {zoom: 1.2}, 6);
					
						    new FlxTimer().start(3, function(introtimer:FlxTimer)
						    {
							IsaacInChest.alpha = 1;
							House.visible = false;
							rain.volume = 0.6;

						new FlxTimer().start(5, function(introtimerex:FlxTimer)
						{
                            IsaacInChest.alpha = 0;
							rain.volume = 0.3;
							FlxTween.tween(FlxG.camera, {zoom: 0.70});
							FlxG.camera.flash(FlxColor.BLACK, 2.5);
							bluebabyintro.visible = true;
							healthBar.visible = true;
					        healthBarBG.visible = true;
					        scoreTxt.visible = true;
					        kadeEngineWatermark.visible = true;
					        iconP1.visible = true;
					        iconP2.visible = true;
							FlxTween.tween(camHUD, {zoom: 1}, 1);
						    new FlxTimer().start(3, function(introtimer:FlxTimer)
						    {
							    bluebabyintro.animation.play('spawn');
							    FlxG.sound.play(Paths.sound('bbintro'));
						    });
						});
				            });
					
                    bluebabyintro.animation.finishCallback = function(pog:String)
				    {
						dad.visible = true;
						remove(bluebabyintro);
						canhitspace = true;
						rain.fadeOut();
						if (curStage == 'chest')
						{
						    chestidle.visible = true;
							FlxG.camera.flash(0xFFfffae8, 3);
							introText = new FlxSprite(-750, 200);
							introText.frames = Paths.getSparrowAtlas('IntroText/acce','shared');
							introText.animation.addByPrefix('shit','acc',24,false);
							introText.animation.play('shit');
							introText.setGraphicSize(Std.int(introText.width * 1));
							introText.cameras = [camHUD];
							add(introText);
							introText.animation.finishCallback = function(name:String) {
								remove(introText);	
							}
							FlxG.sound.play(Paths.sound('whoop'));
							startCountdown();
							canblind = true;
						}
						else
						{
						startCountdown();
						}

					};
					gf.visible = false;
					}
					 
					 
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'roses' || StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
		{
			remove(black);

			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		

		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;


		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			// generateSong('fresh');
		});
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused || paralyzed)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));
	
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];

		var data = -1;
		
		switch(evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (evt.keyLocation == KeyLocation.NUM_PAD)
		{
			trace(String.fromCharCode(evt.charCode) + " " + key);
		}

		if (data == -1)
			return;

		var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit


		dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note
		
		if (dataNotes.length != 0)
		{
			var coolNote = dataNotes[0];

			goodNoteHit(coolNote);
			var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			ana.hit = true;
			ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			ana.nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
		}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

                    var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}
				
					case 'normal':
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
	
					default:
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
	    if (shakeEffect)
		{
		   FlxG.camera.shake(0.03, 0.03);
		}
		
	    if (shakeEffectCont)
		{
		   FlxG.camera.shake(0.01, 0.01);
		}
		
		if (FlxG.keys.justPressed.SPACE && paralyzed)
		{
			paralyzedbreak += 1;
			FlxG.camera.shake(0.02,0.2);
		}
		
		//yes i know this updates every frame. is that bad? probably, idk shit about coding lmao. you tell me
		#if !debug
		perfectMode = false;
		#end

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;
			camHP.visible = !camHP.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('hpZoom', camHP.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}


		if (FlxG.keys.justPressed.SEVEN)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (dad.curCharacter == 'delirium')
		{

		}
		else
		{

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
			
		}	

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'funkyisaac':
						camFollow.y += camY;
						camFollow.x += camX;
					case 'isaacangel':
						camFollow.y += camY;
						camFollow.x += camX;
					case 'dabluebaby':
						camFollow.y += camY;
						camFollow.x += camX;
					case 'isaacdemon':
						camFollow.x = dad.getMidpoint().x + 250;
						camFollow.y += camY;
						camFollow.x += camX;
					case 'delirium':
						camFollow.x = dad.getMidpoint().x - 30;
					case 'keeper':
						camFollow.y += camY;
						camFollow.x += camX;
				}
				
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
				
				
				camFollow.x = boyfriend.getMidpoint().x -100;
				camFollow.y = boyfriend.getMidpoint().y -100;
				camFollow.x += bfcamX;
				camFollow.y += bfcamY;
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			camHP.zoom = FlxMath.lerp(1, camHP.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			if (curStage == 'void')
			{
				openSubState(new DeliLoseSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			else
			{
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					if (curStage == 'void')
					{
						openSubState(new DeliLoseSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					}
					else
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					}
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
                    
					var arrowStrum = strumLineNotes.members[daNote.noteData % 4].y;
					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
				if ((vanishnotesd
					&& daNote.y > arrowStrum - (FlxG.height + arrowStrum) * (50 / 100) + 11))
					daNote.alpha = FlxMath.lerp(daNote.alpha, 0, miscLerp / (FlxG.save.data.fpsCap / 60));
				else if ((vanishnotesd
					&& daNote.y <= arrowStrum - (FlxG.height + arrowStrum) * (50 / 100) + 11))
					daNote.alpha = 1;
					
				if ((vanishnotes
					&& daNote.y > arrowStrum + (FlxG.height - arrowStrum) * (75 / 100) - 11))
					daNote.alpha = 1;
				else if ((vanishnotes
					&& daNote.y <= arrowStrum + (FlxG.height - arrowStrum) * (75 / 100) - 11))
					daNote.alpha = FlxMath.lerp(daNote.alpha, 0, miscLerp / (FlxG.save.data.fpsCap / 60));
					
				//literally all of this is stolen from mic'd up's long sighted modifier lol, credits https://github.com/Verwex/Funkin-Mic-d-Up-SC/blob/stable/source/PlayState.hx
				
				var effect = new MosaicEffect();
				
				if (retrovision)
				{
					arroweffect.setStrength(10, 10);
					daNote.shader = arroweffect.shader;
				}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
								
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									camY = -15;
									camX = 0;
								case 3:
									camX = 15;
									camY = 0;
								case 1:
									camY = 15;
									camX = 0;
								case 0:
									camX = -15;
									camY = 0;
							}
					
								switch(dad.curCharacter)
						        {

							        case 'isaacdemon': 
							        FlxG.camera.shake(0.04,0.4);

						        }
						}
						
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end
						switch(dad.curCharacter)
						{

							case 'isaacdemon': 
							FlxG.camera.shake(0.02,0.2);
							demonsmoke.alpha = 1;
							trasheffect.alpha = 0.3;
							case 'isaacangel': 
							FlxG.camera.shake(0.01,0.2);
							angelsmoke.alpha = 1;
							case 'angelclassic': 
							FlxG.camera.shake(0.01,0.2);
							angelsmoke.alpha = 1;
							case 'delirium': 
							if (health >= 0.10)
							{
							    health -= 0.01;
							}
							if (FlxG.random.bool(20))
							{
								staticlol.alpha = 0.7;
							}


						}
						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate && PlayStateChangeables.useDownscroll) && daNote.mustPress)
					{
                        switch (daNote.noteType) 
						{
						
							case 0: 
							{
								if (daNote.isSustainNote && daNote.wasGoodHit)
									{

										daNote.kill();
										notes.remove(daNote, true);
										daNote.destroy();
											
									}
								else
									{
										if (daNote.mustPress)
										{
											health -= 0.075;
											vocals.volume = 0;
											if (theFunne)
												noteMiss(daNote.noteData, daNote);

										}
									}
					
									daNote.active = false;
									daNote.visible = false;
					
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
							}
							case 2: 
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
								
						}	
					}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}



		if (isStoryMode)
		{
			campaignMisses = misses;
			if (SONG.song.toLowerCase() == 'decide')
			{
			
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.WeekDemonHard = true;
					FlxG.save.data.WeekDemon = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.WeekDemon = true;
				}
					
				camHUD.visible = false;
				var video:MP4Handler = new MP4Handler();
                video.playMP4(Paths.video('badending'));
				video.finishCallback = function()
				{
					if (PlayStateChangeables.botPlay)
					{
					LoadingState.loadAndSwitchState(new CreditsState());
					FlxG.sound.playMusic(Paths.music('MenuIsaac'));
					}
					else
					{
					LoadingState.loadAndSwitchState(new UnlockState());
					FlxG.sound.playMusic(Paths.music('MenuIsaac'));
					}
				}
				
			}
			
			if (SONG.song.toLowerCase() == 'innermost-apocalypse')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.WeekAngelHard = true;
					FlxG.save.data.WeekAngel = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.WeekAngel = true;
				}
			}
			
			if (SONG.song.toLowerCase() == 'innermost-apocalypse')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenWeekAngelHard = true;
					FlxG.save.data.beatenWeekAngel = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beatenWeekAngel = true;
				}
				LoadingState.loadAndSwitchState(new UnlockState());
			}
		}
			if (SONG.song.toLowerCase() == 'acceptance')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenBbHard = true;
					FlxG.save.data.beatenBb = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beatenBb = true;
				}
			}
			
			if (SONG.song.toLowerCase() == 'avarice')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenKeepsHard = true;
					FlxG.save.data.beatenKeeps = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beatenKeeps = true;
				}
			}
			
			if (SONG.song.toLowerCase() == 'decide')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenHard = true;
					FlxG.save.data.beaten = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beaten = true;
				}
			}
					
			if (SONG.song.toLowerCase() == 'innermost-apocalypse')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenAngelHard = true;
					FlxG.save.data.beatenAngel = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beatenAngel = true;
				}
			}
			if (SONG.song.toLowerCase() == 'delirious')
			{
				if (PlayStateChangeables.botPlay)
				{
				}
				else
				{
				if (storyDifficulty >= 2)
					FlxG.save.data.beatenDeliHard = true;
					FlxG.save.data.beatenDeli = true;
				if (storyDifficulty >= 1)
					FlxG.save.data.beatenDeli = true;
				}
			}

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('MenuIsaac'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					paused = true;

					FlxG.sound.music.stop();
					vocals.stop();
					if (FlxG.save.data.scoreScreen)
					{
					    if (SONG.song.toLowerCase() == 'decide' || SONG.song.toLowerCase() == 'misperception')
					    {
					    FlxG.sound.music.stop();
					    vocals.stop();
						}
						else
						{
						FlxG.sound.playMusic(Paths.music('MenuIsaac'));
						FlxG.switchState(new MainMenuState());
						}
					}
					else
					{
					    if (SONG.song.toLowerCase() == 'decide' || SONG.song.toLowerCase() == 'misperception')
					    {
						}
						else
						{
						FlxG.sound.playMusic(Paths.music('MenuIsaac'));
						FlxG.switchState(new MainMenuState());
						}
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					if (StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					if (SONG.song.toLowerCase() == 'misperception')
					{
						camHUD.visible = false;
						var video:MP4Handler = new MP4Handler();
						video.playMP4(Paths.video('decideintro'));
						video.finishCallback = function()
						{
							PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
					else if (SONG.song.toLowerCase() == 'sacrificial')
					{
						camHUD.visible = false;
						var video:MP4Handler = new MP4Handler();
						video.playMP4(Paths.video('angeltransform'));
						video.finishCallback = function()
						{
							PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
					else
					{
						PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
						LoadingState.loadAndSwitchState(new PlayState());
					}
					FlxG.sound.music.stop();
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;


				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
                    FlxG.switchState(new FreeplayState());
				else
					FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

		if (daNote.noteType == 2)
			{
				if (SONG.song.toLowerCase() == 'decide')
				{
				var brimlaser:FlxSprite = new FlxSprite(375, -425);
				remove(brimlaser);
				brimlaser.frames = Paths.getSparrowAtlas('noteeffects/brimlaser','shared');
				brimlaser.animation.addByPrefix('beam','laser',24,false);
				brimlaser.animation.play('beam');
				brimlaser.setGraphicSize(Std.int(brimlaser.width * 0.7));
				brimlaser.cameras = [camHUD];
				add(brimlaser);
				FlxG.sound.play(Paths.sound('brimbeam'));
				combo = 0;
				brimlaser.animation.finishCallback = function(name:String) {
				remove(brimlaser);	
				}
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.mustPress && daNote.noteType == 2)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				misses++;
				}
				if (SONG.song.toLowerCase() == 'delirious')
				{
				    if (delistatic.alpha <= 1.2)
					{
			  	        delistatic.alpha += 0.4;
					}
					FlxG.sound.play(Paths.sound('delistatic'));
					misses++;
				}
				if (curStage == 'basement')
				{

					health -= 0.35;
					//HAH GET IT? CUZ 3.5 BASE DAMAGE!!11!!
					FlxG.sound.play(Paths.sound('tear'));
					remove(tearsplash);	
					tearsplash = new FlxSprite(daNote.x - daNote.width + 15, daNote.y - daNote.height);
					tearsplash.frames = Paths.getSparrowAtlas('noteeffects/tearsplash', 'shared');
					tearsplash.animation.addByPrefix('wee','splash',24,false);
					tearsplash.animation.play('wee');
					tearsplash.setGraphicSize(Std.int(tearsplash.width * 0.6));
					tearsplash.cameras = [camHUD];
					add(tearsplash);
					combo = 0;
					tearsplash.animation.finishCallback = function(name:String) {
						remove(tearsplash);	
					}
					misses++;
				}
				if (curStage == 'shop')
				{
					if (storyDifficulty >= 2)
					{
					remove(pilltext);
					var randomshit = FlxG.random.float(0,250);
					if (randomshit >= 0 && randomshit <= 49)
					{
						if (health <= 0.25)
						{
							health += 999;
							FlxG.sound.play(Paths.sound('pillgood'));
							pilltext = new FlxText("FULL HEALTH");
							boyfriend.playAnim('hey', true);
							//full health
						}
						else
						{
						// bad trip
						FlxG.camera.shake(0.02,0.2);
						health -= 0.35;
						if (health <=0)
						{
						    health = 0.1;
						}
						pilltext = new FlxText("BAD TRIP");
						FlxG.sound.play(Paths.sound('pillbad'));
						boyfriend.playAnim('hit', true);
						}
					}
					else if (randomshit >= 50 && randomshit <= 99)
					{
						FlxG.camera.shake(0.02,0.2);
						//retro vision
						FlxG.sound.play(Paths.sound('pillbad'));
						pilltext = new FlxText("RETRO VISION");
						
						if (!addedtimer)
						{
							var effect = new MosaicEffect();
							effect.setStrength(10, 10);
							var effect2 = new MosaicEffect();
							effect2.setStrength(10, 10);
							basement.shader = effect.shader;
							shopitems.shader = effect2.shader;
							gf.shader = effect2.shader;
							dad.shader = effect2.shader;
							boyfriend.shader = effect2.shader;
							playerStrums.forEach(function(spr:FlxSprite)
							{
								spr.shader = effect.shader;
							});
							cpuStrums.forEach(function(spr:FlxSprite)
							{					
								spr.shader = effect.shader;
							});
							retrovision = true;
						    addedtimer = true;
							new FlxTimer().start(20, function(retrotimer:FlxTimer)
							{
								retrovision = false;
								effect.setStrength(0.1, 0.1);
								effect2.setStrength(0.1, 0.1);
								arroweffect.setStrength(0.1, 0.1);
								FlxG.camera.shake(0.02,0.2);
								addedtimer = false;
							});
						}
						boyfriend.playAnim('hit', true);
					}
					
					else if (randomshit >= 100 && randomshit <= 149)
					{
						notes.forEachAlive(function(daNote:Note)
						{
						    if (daNote.noteType == 2)
							{
							}
							else
							{
								FlxTween.tween(daNote, {alpha: 0}, 2.8);
							}
						});
						FlxG.camera.shake(0.02,0.2);
						//amnesia
						FlxG.sound.play(Paths.sound('pillbad'));
						pilltext = new FlxText("AMNESIA");
						boyfriend.playAnim('hit', true);
					}
					else if (randomshit >= 150 && randomshit <= 199)
					{
                        if (!excited)
						{
						PlayStateChangeables.scrollSpeed = 4.2;
						trace(PlayStateChangeables.scrollSpeed);
						FlxG.camera.shake(0.02,0.2);
						pilltext = new FlxText("I'M EXCITED!");
						FlxG.sound.play(Paths.sound('pillbad'));
						boyfriend.playAnim('hit', true);
						excited = true;
						}
						else
						{
						PlayStateChangeables.scrollSpeed = 3.4;
						trace(PlayStateChangeables.scrollSpeed);
						pilltext = new FlxText("I'M DROWSY...");
						FlxG.sound.play(Paths.sound('pillgood'));
						boyfriend.playAnim('hey', true);
						excited = false;
						}
					}
					else if (randomshit >= 200 && randomshit <= 249)
					{
                        paralyzed = true;
						paralyzedbreak = 0;
						FlxG.sound.play(Paths.sound('pillbad'));
						boyfriend.playAnim('hit', true);
						FlxG.camera.shake(0.02,0.2);
						pilltext = new FlxText("PARALYSIS");
						spaceprompt.visible = true;
						paralyzedeffect.visible = true;
					}
					else
					{
					    pilltext = new FlxText("I FOUND PILLS");
						FlxG.sound.play(Paths.sound('foundpills'));
					}
					
					}
					else if (storyDifficulty == 1)
					{
					remove(pilltext);
					var randomshit = FlxG.random.float(0,250);
					if (randomshit >= 0 && randomshit <= 49)
					{
							health += 999;
							FlxG.sound.play(Paths.sound('pillgood'));
							pilltext = new FlxText("FULL HEALTH");
							boyfriend.playAnim('hey', true);
							//full health
					}

					else if (randomshit >= 50 && randomshit <= 99)
					{
						FlxG.camera.shake(0.02,0.2);
						//retro vision
						FlxG.sound.play(Paths.sound('pillbad'));
						pilltext = new FlxText("RETRO VISION");
						
						if (!addedtimer)
						{
							var effect = new MosaicEffect();
							effect.setStrength(10, 10);
							var effect2 = new MosaicEffect();
							effect2.setStrength(10, 10);
							basement.shader = effect.shader;
							gf.shader = effect2.shader;
							dad.shader = effect2.shader;
							boyfriend.shader = effect2.shader;
							playerStrums.forEach(function(spr:FlxSprite)
							{
								spr.shader = effect.shader;
							});
							cpuStrums.forEach(function(spr:FlxSprite)
							{					
								spr.shader = effect.shader;
							});
							retrovision = true;
						    addedtimer = true;
							new FlxTimer().start(10, function(retrotimer:FlxTimer)
							{
								retrovision = false;
								effect.setStrength(0.1, 0.1);
								effect2.setStrength(0.1, 0.1);
								arroweffect.setStrength(0.1, 0.1);
								FlxG.camera.shake(0.02,0.2);
								addedtimer = false;
							});
						}
						boyfriend.playAnim('hit', true);
					}
					
					else if (randomshit >= 100 && randomshit <= 149)
					{
						notes.forEachAlive(function(daNote:Note)
						{
						    if (daNote.noteType == 2)
							{
							}
							else
							{
								FlxTween.tween(daNote, {alpha: 0}, 2.8);
							}
						});
						FlxG.camera.shake(0.02,0.2);
						//amnesia
						FlxG.sound.play(Paths.sound('pillbad'));
						pilltext = new FlxText("AMNESIA");
						boyfriend.playAnim('hit', true);
					}
					else if (randomshit >= 150 && randomshit <= 199)
					{
                        if (!excited)
						{
						PlayStateChangeables.scrollSpeed = 3.8;
						trace(PlayStateChangeables.scrollSpeed);
						FlxG.camera.shake(0.02,0.2);
						pilltext = new FlxText("I'M EXCITED!");
						FlxG.sound.play(Paths.sound('pillbad'));
						boyfriend.playAnim('hit', true);
						excited = true;
						}
						else
						{
						PlayStateChangeables.scrollSpeed = 3;
						trace(PlayStateChangeables.scrollSpeed);
						pilltext = new FlxText("I'M DROWSY...");
						FlxG.sound.play(Paths.sound('pillgood'));
						boyfriend.playAnim('hey', true);
						excited = false;
						}
					}
					else if (randomshit >= 200 && randomshit <= 249)
					{
                        paralyzed = true;
						paralyzedbreak = 0;
						FlxG.sound.play(Paths.sound('pillbad'));
						boyfriend.playAnim('hit', true);
						FlxG.camera.shake(0.02,0.2);
						pilltext = new FlxText("PARALYSIS");
						spaceprompt.visible = true;
						paralyzedeffect.visible = true;
					}
					else
					{
					    pilltext = new FlxText("I FOUND PILLS");
						FlxG.sound.play(Paths.sound('foundpills'));
					}
					
					}
					else
					{
					remove(pilltext);
					var randomshit = FlxG.random.float(0,60);
					if (randomshit >= 0 && randomshit <= 49)
					{
						health += 999;
						FlxG.sound.play(Paths.sound('pillgood'));
						pilltext = new FlxText("FULL HEALTH");
						boyfriend.playAnim('hey', true);
						//full health
					}
					else
					{
					    pilltext = new FlxText("I FOUND PILLS");
						FlxG.sound.play(Paths.sound('foundpills'));
					}
					}
					
					pilltext.cameras = [camHUD];
					pilltext.updateHitbox();
					pilltext.setFormat(38, FlxColor.WHITE, RIGHT, FlxColor.WHITE);
					pilltext.y = 170;
					pilltext.x = 700;
		
					add(pilltext);
					FlxTween.tween(pilltext, {alpha: 0}, 3);

				}
			}
			
			else
			{
			
				switch(daRating)
				{
					case 'shit':
						score = -300;
						combo = 0;
						misses++;
						health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit -= 1;

					case 'bad':
						daRating = 'bad';
						score = 0;
						health -= 0.06;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;

					case 'good':
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;

					case 'sick':
						if (health < 2)
							health += 0.1;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
				}
			
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
				
				if (daNote.noteType == 2)
					{

					}
					else
					{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				if(paralyzed)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}

				var anas:Array<Ana> = [null,null,null,null];

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									{ // if a direction is hit that shouldn't be
										if (pressArray[shit] && !directionList.contains(shit))
											noteMiss(shit, null);
									}
							}
							for (coolNote in possibleNotes)
							{
								if (pressArray[coolNote.noteData])
								{
									if (mashViolations != 0)
										mashViolations--;
									scoreTxt.color = FlxColor.WHITE;
									var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
									anas[coolNote.noteData].hit = true;
									anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
									anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
									goodNoteHit(coolNote);
								}
							}
						}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
				notes.forEachAlive(function(daNote:Note)
				{
					if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
					!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if (daNote.noteType == 2)
						{
						
						}
						else
						{
						if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
						PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								var n = findByTime(daNote.strumTime);
								trace(n);
								if(n != null)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
						bfcamX = 0; 
						bfcamY = 0;
					}
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					if (SONG.song.toLowerCase() == 'decide')
					{
					}
					else
					{
					add(gf);
					}
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
				
				
			}
			//miss effect shit
			if (SONG.song.toLowerCase() == 'acceptance' && curStep < 1568)
			{
			    var misseffect:FlxSprite = new FlxSprite(-400, -200);
			    remove(misseffect);
				FlxG.camera.flash(FlxColor.BLACK, 0.5);
				FlxG.camera.shake(0.02,0.2);
			    misseffect.frames = Paths.getSparrowAtlas('chest/misseffect','shared');
			    misseffect.animation.addByPrefix('miss','hurt',24,false);
			    misseffect.animation.play('miss');
			    misseffect.setGraphicSize(Std.int(misseffect.width * 0.7));
				misseffect.antialiasing = true;
				misseffect.cameras = [camHUD];
				misseffect.scrollFactor.set(0, 0);
			    add(misseffect);
			    misseffect.animation.finishCallback = function(name:String) {
			    	remove(misseffect);		
			    }
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else
				if (!loadRep)
				{
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{   
					{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
					}
					
					if (curStage == 'shop')
					{
						if (!note.isbadnote)
						{
							switch (note.noteData)
							{
								case 2:
									boyfriend.playAnim('singUP', true);
								case 3:
									boyfriend.playAnim('singRIGHT', true);
								case 1:
									boyfriend.playAnim('singDOWN', true);
								case 0:
									boyfriend.playAnim('singLEFT', true);
							}
						}
					}
					else
					{
						if (!note.isbadnote)
						{
							switch (note.noteData)
							{
								case 2:
									boyfriend.playAnim('singUP', true);
								case 3:
									boyfriend.playAnim('singRIGHT', true);
								case 1:
									boyfriend.playAnim('singDOWN', true);
								case 0:
									boyfriend.playAnim('singLEFT', true);
							}
						}

						else
						{
							switch (note.noteData)
							{
								case 2:
									boyfriend.playAnim('hit', true);
								case 3:
									boyfriend.playAnim('hit', true);
								case 1:
									boyfriend.playAnim('hit', true);
								case 0:
									boyfriend.playAnim('hit', true);
							}
						}
					}
					
					switch (note.noteData)
					{
						case 2:
							bfcamY = -15;
							bfcamX = 0;
						case 3:
							bfcamX = 15;
							bfcamY = 0;
						case 1:
							bfcamY = 15;
							bfcamX = 0;
						case 0:
							bfcamX = -15;
							bfcamY = 0;
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
        
		if (storyDifficulty <= 1)
		{
        if (paralyzedbreak >= 3)
		{
			paralyzed = false;
			paralyzedbreak = 0;
			spaceprompt.visible = false;
			paralyzedeffect.visible = false;
			FlxG.sound.play(Paths.sound('pillgood'));
		}
		}
		else
		{
        if (paralyzedbreak >= 5)
		{
			paralyzed = false;
			paralyzedbreak = 0;
			spaceprompt.visible = false;
			paralyzedeffect.visible = false;
			FlxG.sound.play(Paths.sound('pillgood'));
		}
		}
		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		
		camFollow.x = 0;
		camFollow.y = 0;
		camFollow.x += bfcamX;
		camFollow.y += bfcamY;
		
		if (SONG.song.toLowerCase() == 'sacrificial')
		{
			if (curStep == 35 || curStep == 147  || curStep == 339 || curStep == 483 || curStep == 675 || curStep == 835 || curStep == 1075)
			{
			    if (FlxG.random.bool(50))
				{
				Roundworm = new FlxSprite(1200, 500);
			    remove(Roundworm);
			    Roundworm.frames = Paths.getSparrowAtlas('Rworm','shared');
				Roundworm.scrollFactor.set(0.9, 0.9);
			    Roundworm.animation.addByPrefix('yo','hey',24,false);
			    Roundworm.animation.play('yo');
			    add(Roundworm);
				Roundworm.antialiasing = true;
				Roundworm.visible = true;
			    Roundworm.animation.finishCallback = function(name:String) {
			    	remove(Roundworm);		
			    }
				}
			}
		
		    if (curStep == 288 || curStep == 574)
			{
			    FlxG.camera.shake(0.02,0.2);
			}

		}
		
		
		if (SONG.song.toLowerCase() == 'innermost-apocalypse')
		{
			if (curStep == 64)
			{
				if (storyDifficulty >= 1)
				{
			    blindanim.animation.play('appear');
				blindanim.visible = true;
			    blindanim.animation.finishCallback = function(name:String) {
			    	remove(blindanim);				
			    }
                    healthBar.visible = false;
					healthBarBG.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;	
					qmark.visible = true;
				}
			}
			if (curStep == 64 || curStep == 448)
			{
				FlxG.camera.shake(0.02,0.2);
			}
			if (curStep == 832)
			{
			    dad.visible = false;
				FlxG.camera.flash(FlxColor.WHITE, 5);
				holylight.visible = true;
                healthBar.visible = true;
				healthBarBG.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;	
				qmark.visible = false;
			}
			
			
		}
		
        if (SONG.song.toLowerCase() == 'misperception')
		{
			
			if (curStep == 35 || curStep == 99  || curStep == 195 || curStep == 323 || curStep == 515 || curStep == 771 || curStep == 1027 || curStep == 1731)
			{
			    if (FlxG.random.bool(50))
				{
				Roundworm = new FlxSprite(1200, 500);
			    remove(Roundworm);
			    Roundworm.frames = Paths.getSparrowAtlas('Rworm','shared');
				Roundworm.scrollFactor.set(0.9, 0.9);
			    Roundworm.animation.addByPrefix('yo','hey',24,false);
			    Roundworm.animation.play('yo');
			    add(Roundworm);
				Roundworm.antialiasing = true;
				Roundworm.visible = true;
			    Roundworm.animation.finishCallback = function(name:String) {
			    	remove(Roundworm);		
			    }
				}
			}
			
			if (curStep == 1152)
			{
			    new FlxTimer().start(0.05, function(darkTimer:FlxTimer)
			    {
				    blackscreen.alpha += 0.05;
				    if (blackscreen.alpha < 0.30)
				    {
					    darkTimer.reset();
				    }
				    else
				    {
				    }
			    });
                FlxTween.tween(FlxG.camera, {zoom: 0.85});
				defaultCamZoom = 0.85;
			}
			if (curStep == 1280)
			{
			    new FlxTimer().start(0.05, function(darkTimer:FlxTimer)
			    {
				    blackscreen.alpha += 0.05;
				    if (blackscreen.alpha < 0.60)
				    {
					    darkTimer.reset();
				    }
				    else
				    {
				    }
			    });
                FlxTween.tween(FlxG.camera, {zoom: 0.90});
				defaultCamZoom = 0.90;
			}
			if (curStep == 1408)
			{
			    new FlxTimer().start(0.05, function(antidarkTimer:FlxTimer)
			    {
				    blackscreen.alpha -= 0.05;
				    if (blackscreen.alpha > 0)
				    {
					    antidarkTimer.reset();
				    }
				    else
				    {
				    }
			    });
                FlxTween.tween(FlxG.camera, {zoom: 0.80});
				defaultCamZoom = 0.80;
			}
		}
		
        if (SONG.song.toLowerCase() == 'delirious')
		{
			if (curStep == 288)
			{
				var effect = new MosaicEffect();
				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 8, 1, {type: PINGPONG}, function(v)
				{
					effect.setStrength(v, v);
				});
				
				dad.shader = effect.shader;
                staticlol.alpha = 1;
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				health = 0.01;
				portal.alpha = 1;
				FlxTween.tween(FlxG.camera, {zoom: 0.60});
				defaultCamZoom = 0.60;
			}
				
			
			if (curStep == 1344)
			{
                staticlol.alpha = 1;
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				health = 0.01;
				FlxTween.tween(FlxG.camera, {zoom: 0.60});
				defaultCamZoom = 0.60;
			}
			if (curStep == 1600)
			{
                staticlol.alpha = 1;
			}

			if (curStep == 1952)
			{
                staticlol.alpha = 1;
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				health = 0.01;
				FlxTween.tween(FlxG.camera, {zoom: 0.60});
				defaultCamZoom = 0.60;
			}
			if (curStep == 272 || curStep == 1328 || curStep == 1920)
			{
				FlxTween.tween(FlxG.camera, {zoom: 0.70});
				defaultCamZoom = 0.70;
				staticlol.alpha = 1;
				staticlol.visible = true;
			}
			
			if (curStep == 800 || curStep == 1664 || curStep == 1792)
			{
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				staticlol.alpha = 1;
				basementvoid.visible = true;
				chestvoid.visible = false;
			}
			
			if (curStep == 928)
			{
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				staticlol.alpha = 1;
				drvoid.visible = true;
				portal.alpha = 0.5;
				basementvoid.visible = false;
			}
			
			if (curStep == 1056)
			{
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				staticlol.alpha = 1;
				drvoid.visible = false;
				basementvoid.visible = true;
				portal.alpha = 1;
			}
			
			if (curStep == 1184 || curStep == 1600 || curStep == 1728)
			{
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				staticlol.alpha = 1;
				chestvoid.visible = true;
				basementvoid.visible = false;
			}
			
			if (curStep == 1344 || curStep == 1856)
			{
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('death_card_mix'));
				staticlol.alpha = 1;
				chestvoid.visible = false;
				basementvoid.visible = false;
				drvoid.visible = false;
			}
			
			if (curStep == 1984)
			{
				FlxG.camera.flash(FlxColor.WHITE, 5);
				dad.visible = false;
				staticlol.alpha = 1;
			}
		}
		
        if (SONG.song.toLowerCase() == 'decide')
		{	
			//curse of darkness shit
			if (curStep == 112 || curStep == 848 || curStep == 1408 || curStep == 1712)
			{
				
				if (storyDifficulty >= 1)
				{
				darknesseff.visible = true;
				darknesseff.alpha = 0;
				blackscreen.visible = true;
				}
				
			}
			
			if (curStep == 112 || curStep == 120 || curStep == 128 || curStep == 136 || curStep == 144 || curStep == 152 || curStep == 160 || curStep == 168 || curStep == 848 || curStep == 856 || curStep == 864 || curStep == 872 || curStep == 880 || curStep == 888 || curStep == 1408 || curStep == 1416 || curStep == 1424 || curStep == 1432 || curStep == 1712 || curStep == 1720 || curStep == 1728 || curStep == 1736 || curStep == 1744 || curStep == 1752)
			{
				
				if (storyDifficulty >= 1)
				{
				darknesseff.alpha = 0;
				FlxTween.tween(darknesseff, {alpha: 1}, 0.5);
				}
				
			}
			
			
			if (curStep == 112)
			{
				if (storyDifficulty >= 1)
				{
				healthBar.alpha = 0.5;
				healthBarBG.alpha = 0.5;
				iconP1.alpha = 0.5;
				iconP2.alpha = 0.5;
			    darknessanim.animation.play('appear');
				darknessanim.visible = true;
			    darknessanim.animation.finishCallback = function(name:String) {
			    	remove(darknessanim);
                    healthBar.alpha = 1;
					healthBarBG.alpha = 1;
					iconP1.alpha = 1;
					iconP2.alpha = 1;					
			    }

				}
			
			}
			

		    if (curStep == 176 || curStep == 896 || curStep == 1440 || curStep == 1760)
			{
				if (storyDifficulty >= 1)
				{
			    darknesseff.visible = false;
				FlxG.camera.flash(FlxColor.BLACK, 1);
				blackscreen.visible = false;
				}
			}
			
			
		    if (curStep == 379 || curStep == 1456)
		    {
                FlxTween.tween(FlxG.camera, {zoom: 0.6}, 0.8, {
                    ease: FlxEase.expoOut
		    });
				FlxG.camera.flash(FlxColor.RED, 0.2);
		        blackscreen.visible = true;
			}
			
		    if (curStep >= 379 && curStep < 384 || curStep >= 1456 && curStep < 1468)
		    {
			    dad.playAnim('brim', true);
				vocals.volume = 1;
		        FlxG.camera.shake(0.07,0.7);
				boyfriend.playAnim('dodge', true);
		    }
			
			if (curStep == 384 || curStep == 1468)
			{
			    FlxG.camera.flash(FlxColor.RED, 0.2);
				blackscreen.visible = false;
			}
			
			if (curStep == 1468)
			{
			    dad.playAnim('idle', true);
			}
			
		    if (curStep == 1856)
		    {
                FlxTween.tween(FlxG.camera, {zoom: 0.6}, 0.8, {
                    ease: FlxEase.expoOut
		    });
		    }			

		    if (curStep >= 1856 && curStep < 1871)
		    {
			    dad.playAnim('brim', true);
		        FlxG.camera.shake(0.07,0.7);
				vocals.volume = 1;
				boyfriend.playAnim('hit', true);
		    }
			
			if (curStep == 1861)
			{
				reallyblackscreen = new FlxSprite(-800, -600).makeGraphic(Std.int(FlxG.width * 4), Std.int(FlxG.height * 4), FlxColor.BLACK);
				reallyblackscreen.scrollFactor.set();
		        add(reallyblackscreen);
			    FlxG.camera.flash(FlxColor.RED, 5);
			}
			
			//yanderedev moment :flushed:
			//prob could have used a switch or somethin but fuck you lmao
			


    
			
		}
			
        if (SONG.song.toLowerCase() == 'acceptance')
		{
			if (curStep == 128 || curStep == 448 || curStep == 1008 || curStep == 1456)
			{
			
            if (storyDifficulty >= 1)		
			{
			if (FlxG.save.data.downscroll)
			{
				var DrawingMom:FlxSprite = new FlxSprite(570, 180);
			    DrawingMom.frames = Paths.getSparrowAtlas('chest/DrawingMom','shared');
			    DrawingMom.animation.addByPrefix('mom','mom',24,false);
			    DrawingMom.animation.play('mom');
				DrawingMom.antialiasing = true;
			    DrawingMom.setGraphicSize(Std.int(DrawingMom.width * 0.9));
			    DrawingMom.cameras = [camHUD];
			    add(DrawingMom);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingMom.animation.finishCallback = function(name:String) {
			    	remove(DrawingMom);	
			}
			}
			else
			{
				var DrawingMom:FlxSprite = new FlxSprite(570, 300);
			    DrawingMom.frames = Paths.getSparrowAtlas('chest/DrawingMom','shared');
			    DrawingMom.animation.addByPrefix('mom','mom',24,false);
			    DrawingMom.animation.play('mom');
				DrawingMom.antialiasing = true;
			    DrawingMom.setGraphicSize(Std.int(DrawingMom.width * 0.9));
			    DrawingMom.cameras = [camHUD];
			    add(DrawingMom);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingMom.animation.finishCallback = function(name:String) {
			    	remove(DrawingMom);		
					
		    }
			}
			}
			}

			if (curStep == 160 || curStep == 512 || curStep == 880 || curStep == 1424)
			{
            if (storyDifficulty >= 1)		
			{
			if (FlxG.save.data.downscroll)
			{
				var DrawingDemon:FlxSprite = new FlxSprite(780, 10);
			    DrawingDemon.frames = Paths.getSparrowAtlas('chest/DrawingDemon','shared');
			    DrawingDemon.animation.addByPrefix('demon','demon',24,false);
			    DrawingDemon.animation.play('demon');
				DrawingDemon.antialiasing = true;
			    DrawingDemon.setGraphicSize(Std.int(DrawingDemon.width * 0.9));
			    DrawingDemon.cameras = [camHUD];
			    add(DrawingDemon);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingDemon.animation.finishCallback = function(name:String) {
			    	remove(DrawingDemon);		
					
		    }
			}
			else
			{
				var DrawingDemon:FlxSprite = new FlxSprite(780, 130);
			    DrawingDemon.frames = Paths.getSparrowAtlas('chest/DrawingDemon','shared');
			    DrawingDemon.animation.addByPrefix('demon','demon',24,false);
			    DrawingDemon.animation.play('demon');
				DrawingDemon.antialiasing = true;
			    DrawingDemon.setGraphicSize(Std.int(DrawingDemon.width * 0.9));
			    DrawingDemon.cameras = [camHUD];
			    add(DrawingDemon);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingDemon.animation.finishCallback = function(name:String) {
			    	remove(DrawingDemon);		
					
		    }
			}
			}
			}
			if (curStep == 320 || curStep == 656 || curStep == 1296 || curStep == 1552)
			{
				
            if (storyDifficulty >= 1)		
			{
			if (FlxG.save.data.downscroll)
			{
				var DrawingDemon2:FlxSprite = new FlxSprite(700, 130);
			    DrawingDemon2.frames = Paths.getSparrowAtlas('chest/DrawingDemon2','shared');
			    DrawingDemon2.animation.addByPrefix('demon2','demon2',24,false);
			    DrawingDemon2.animation.play('demon2');
				DrawingDemon2.antialiasing = true;
			    DrawingDemon2.setGraphicSize(Std.int(DrawingDemon2.width * 0.9));
			    DrawingDemon2.cameras = [camHUD];
			    add(DrawingDemon2);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingDemon2.animation.finishCallback = function(name:String) {
			    	remove(DrawingDemon2);			
					
		    }
			}
			else
			{
				
				var DrawingDemon2:FlxSprite = new FlxSprite(700, 250);
			    DrawingDemon2.frames = Paths.getSparrowAtlas('chest/DrawingDemon2','shared');
			    DrawingDemon2.animation.addByPrefix('demon2','demon2',24,false);
			    DrawingDemon2.animation.play('demon2');
				DrawingDemon2.antialiasing = true;
			    DrawingDemon2.setGraphicSize(Std.int(DrawingDemon2.width * 0.9));
			    DrawingDemon2.cameras = [camHUD];
			    add(DrawingDemon2);
				FlxG.sound.play(Paths.sound('whoop'));
			    DrawingDemon2.animation.finishCallback = function(name:String) {
			    	remove(DrawingDemon2);			
					
		    }
			}
			}
			}
			
			
			if (curStep == 1808)
			{
				FlxG.camera.flash(0xFFfffae8, 5);
				FlxTween.tween(camHUD, {alpha: 0}, 2.8);
				dad.visible = false;
				chestidle.visible = false;
			    FlxG.sound.music.volume = 1;
		        vocals.volume = 1;
				end.animation.play('end');
				end.visible = true;
				FlxTween.tween(FlxG.camera, {zoom: 0.50}, 6);
				canPause = false;
				defaultCamZoom = 0.55;
				
				songending = true;
			}

			if (curStep == 1872)
			{
				reallyblackscreen = new FlxSprite(-800, -600).makeGraphic(Std.int(FlxG.width * 4), Std.int(FlxG.height * 4), FlxColor.BLACK);
				reallyblackscreen.scrollFactor.set();
		        add(reallyblackscreen);
			}
			
			
			if (curStep == 1040 || curStep == 1104 || curStep == 1168 || curStep == 1232 || curStep == 1552 || curStep == 1584 || curStep == 1616 || curStep == 1648 || curStep == 1680 || curStep == 1712 || curStep == 1744)
			{
                FlxTween.tween(FlxG.camera, {zoom: 0.70});
				defaultCamZoom = 0.70;
			}
			//zoom when blue baby's turns start 
			
			if (curStep == 1072 || curStep == 1136 || curStep == 1200 || curStep == 1568 || curStep == 1600 || curStep == 1632 || curStep == 1664 || curStep == 1696 || curStep == 1728 || curStep == 1760)
			{
                FlxTween.tween(FlxG.camera, {zoom: 0.65});
				defaultCamZoom = 0.65;
			}
			//zoom out a bit when bf's turns start
			
			if (curStep == 1264 || curStep == 1776)
			{
                FlxTween.tween(FlxG.camera, {zoom: 0.60});
				defaultCamZoom = 0.60;
			}
			

		}
		
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
				camX = 0;
				camY = 0;
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
				camHP.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
				camHP.zoom += 0.03;
			}
	
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}
		

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}
				
			case 'chest':
				if(FlxG.save.data.distractions){
					GFdisappointed.animation.play('dance', true);
				}
				
			case 'basement':
				if(FlxG.save.data.distractions){
					gapers.animation.play('bounce', true);
				}
				
			case 'shop':
				if(FlxG.save.data.distractions){
					shopitems.animation.play('bruh', true);
				}


			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
