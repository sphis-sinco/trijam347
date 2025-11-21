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
			for (tile in tileGroup.split(' '))
			{
				if (Std.parseInt(tile) != 0)
				{
					var tile_sprite = new Tile(Std.parseInt(tile));
					tile_sprite.scale.set(2, 2);
					tile_sprite.setPosition((x * 8) * tile_sprite.scale.x, (y * 8) * tile_sprite.scale.y);
					mapTiles.add(tile_sprite);
				}

				x++;
			}

			y++;
			x = 0;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
