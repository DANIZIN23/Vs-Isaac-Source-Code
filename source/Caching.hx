package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var IsaacLogo:FlxSprite;
	var tip:FlxText;
	var isaacbanner:FlxSprite;
	var loadingshit:FlxSprite;

	override function create()
	{
	
	var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1000, FlxColor.WHITE);
	add(white);
	
	isaacbanner= new FlxSprite(0, 0).loadGraphic(Paths.image('isaacloading'));
	isaacbanner.antialiasing = true;
	isaacbanner.setGraphicSize(Std.int(isaacbanner.width * 0.67));
	isaacbanner.scrollFactor.set(0, 0);
	isaacbanner.active = false;
	isaacbanner.updateHitbox();
	isaacbanner.alpha = 0;
	
	add(isaacbanner);
	
	var diceroll = FlxG.random.float(0,400);
	
	if (diceroll >= 0 && diceroll <= 49)
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Brimstone notes will blind you temporarily and reset your combo. Make sure to avoid them!" : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 50 && diceroll <= 99)
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Find your optimal settings in the options menu." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 100 && diceroll <= 149)
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Eternal charts were made with DFJK controls in mind." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 150 && diceroll <= 199)
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Curses can be avoided by playing on lower difficulties." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 200 && diceroll <= 249)
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Look to la luna." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 250 && diceroll <= 299)
    {
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "I smell wet fur." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 300 && diceroll <= 349)
    {
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Some mechanics will be disabled when playing in lower difficulties." : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else if (diceroll >= 350)
    {
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "Complete the story mode to unlock bonus songs!" : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
	else
	{
		tip = new FlxText(5, FlxG.height - 28, 0, (Main.watermarks ? "2305131709" : ""), 12);
		tip.scrollFactor.set();
		tip.setFormat(Paths.font("upheavtt.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(tip);
	}
			
			
	
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 400,0,"Loading...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.setFormat(34, FlxColor.RED);
        text.alpha = 0;

        IsaacLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('IsaacLogo'));
        IsaacLogo.x -= IsaacLogo.width / 2;
        IsaacLogo.y -= IsaacLogo.height / 2 - 200;
		IsaacLogo.antialiasing = true;
		IsaacLogo.screenCenter();
        text.y -= IsaacLogo.height / 2 - 125;
        text.x -= 170;
        IsaacLogo.setGraphicSize(Std.int(IsaacLogo.width * 0.7));

        IsaacLogo.alpha = 0;

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;	

    override function update(elapsed) 
    {

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            IsaacLogo.alpha = alpha;
            text.alpha = alpha;
			isaacbanner.alpha = alpha;
            text.text = "Loading... (" + done + "/" + toBeDone + ")";
        }

        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];

        trace("caching images...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }

        trace("caching music...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(images) + Lambda.count(music);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in images)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
            FlxG.sound.cache(Paths.inst(i));
            FlxG.sound.cache(Paths.voices(i));
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");
		


        FlxG.switchState(new TitleState());
    }
	

}