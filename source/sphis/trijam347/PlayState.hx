package sphis.trijam347;

import lime.utils.Assets;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;

using StringTools;

class PlayState extends FlxState
{
	var mapTiles:FlxSpriteGroup;

	override public function create()
	{
		super.create();

		mapTiles = new FlxSpriteGroup();
		add(mapTiles);

		var map = Assets.getText('assets/data/map.txt');
		var x = 0;
		var y = 0;
		for (tileGroup in map.split('\n'))
		{
			trace(tileGroup);

			for (tile in tileGroup.split(' '))
			{
				if (Std.parseInt(tile) != 0)
				{
					var tile_sprite = new Tile(Std.parseInt(tile));
					tile_sprite.setPosition(x * 8, y * 8);
					mapTiles.add(tile_sprite);
				}

				if (x >= 16)
				{
					y++;
					x = 0;
				}

				x++;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
