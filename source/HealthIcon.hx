package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	public var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		switch(char)
		{
		
		case 'delirium':
				var file:FlxAtlasFrames = Paths.getSparrowAtlas('void/deliriumicons', 'shared');
				frames = file;
				animation.addByPrefix(char, 'icon', 24, true);
				
		case 'deliriumfp':
				var file:FlxAtlasFrames = Paths.getSparrowAtlas('void/deliriumiconsfp', 'shared');
				frames = file;
				animation.addByPrefix(char, 'icon', 24, true);
		
		
		default:
		    loadGraphic(Paths.image('iconGrid'), true, 150, 150);
			antialiasing = true;
			animation.add('bf', [0, 1], 0, false, isPlayer);
			animation.add('bfcandle', [0, 1], 0, false, isPlayer);
			animation.add('bf-car', [0, 1], 0, false, isPlayer);
			animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
			animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
			animation.add('spooky', [2, 3], 0, false, isPlayer);
			animation.add('pico', [4, 5], 0, false, isPlayer);
			animation.add('mom', [6, 7], 0, false, isPlayer);
			animation.add('mom-car', [6, 7], 0, false, isPlayer);
			animation.add('tankman', [8, 9], 0, false, isPlayer);
			animation.add('face', [10, 11], 0, false, isPlayer);
			animation.add('dad', [12, 13], 0, false, isPlayer);
			animation.add('senpai', [22, 22], 0, false, isPlayer);
			animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
			animation.add('spirit', [23, 23], 0, false, isPlayer);
			animation.add('bf-old', [14, 15], 0, false, isPlayer);
			animation.add('gf', [16], 0, false, isPlayer);
			animation.add('gf-christmas', [16], 0, false, isPlayer);
			animation.add('gf-pixel', [16], 0, false, isPlayer);
			animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
			animation.add('monster', [19, 20], 0, false, isPlayer);
			animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
			animation.add('funkyisaac', [24, 25], 0, false, isPlayer);
			animation.add('isaacclassic', [24, 25], 0, false, isPlayer);
			animation.add('isaacshifting', [24, 25], 0, false, isPlayer);
			animation.add('isaacangel', [24, 25], 0, false, isPlayer);
			animation.add('angelclassic', [24, 25], 0, false, isPlayer);
			animation.add('isaacdemon', [26, 27], 0, false, isPlayer);
			animation.add('dabluebaby', [28, 29], 0, false, isPlayer);
			animation.add('TheStupendousMeatPerson', [30, 31], 0, false, isPlayer);
			animation.add('delirium', [32, 33], 0, false, isPlayer);
			animation.add('bfdeli', [32, 33], 0, false, isPlayer);
			animation.add('keeper', [34, 35], 0, false, isPlayer);
			animation.add('gfshop', [16], 0, false, isPlayer);
			

			switch(char)
			{
				case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
					antialiasing = false;
			}

		}
		this.char = char;
		
		scrollFactor.set();
		animation.play(char);
		antialiasing = true;
		
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
