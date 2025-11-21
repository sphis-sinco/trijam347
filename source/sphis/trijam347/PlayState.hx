package sphis.trijam347;

import flixel.FlxState;
import flixel.group.FlxSpriteGroup;

class PlayState extends FlxState
{
	var mapTiles:FlxSpriteGroup;

	override public function create()
	{
		super.create();
		
		mapTiles = new FlxSpriteGroup();
		add(mapTiles);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
