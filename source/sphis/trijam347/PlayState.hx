package sphis.trijam347;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import lime.utils.Assets;
import flixel.FlxState;

using StringTools;

class PlayState extends FlxState
{
	var mapTiles:FlxTypedGroup<Tile>;

	var player:Player;

	override public function create()
	{
		super.create();

		mapTiles = new FlxTypedGroup<Tile>();
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
					tile_sprite.scale.set(4, 4);
					tile_sprite.setPosition((x * 8) * tile_sprite.scale.x, (y * 8) * tile_sprite.scale.y);
					mapTiles.add(tile_sprite);
				}

				x++;
			}

			y++;
			x = 0;
		}

		player = new Player();
		player.scale.set(2, 2);
		player.updateHitbox();
		player.setPosition((7 * 8) * 4, (13 * 8) * 4);
		player.animation.play('walk');
		add(player);
		player.dir = 0;

		FlxG.camera.zoom = 2;
		FlxG.camera.follow(player, LOCKON, 1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([A, LEFT]))
		{
			player.flipX = false;
			player.dir = 0;
			player.x -= player.width;

			for (tile in mapTiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.x += player.width;
		}
		if (FlxG.keys.anyJustReleased([D, RIGHT]))
		{
			player.flipX = true;
			player.dir = 1;
			player.x += player.width;

			for (tile in mapTiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.x -= player.width;
		}

		if (FlxG.keys.anyJustReleased([W, UP]))
		{
			player.dir = 2;
			player.y -= player.height;

			for (tile in mapTiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.y += player.height;
		}
		if (FlxG.keys.anyJustReleased([S, DOWN]))
		{
			player.dir = 3;
			player.y += player.height;

			for (tile in mapTiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.y -= player.height;
		}

		if (FlxG.keys.anyJustReleased([ENTER]))
		{
			switch (player.dir)
			{
				case 0:
					player.x -= player.width;
				case 1:
					player.x += player.width;
				case 2:
					player.y -= player.height;
				case 3:
					player.y += player.height;
			}

			for (tile in mapTiles.members)
				if (player.overlaps(tile) && tile.exists)
					tile.interaction();

			switch (player.dir)
			{
				case 0:
					player.x += player.width;
				case 1:
					player.x -= player.width;
				case 2:
					player.y += player.height;
				case 3:
					player.y -= player.height;
			}
		}
	}
}
