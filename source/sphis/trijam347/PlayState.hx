package sphis.trijam347;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import lime.utils.Assets;
import flixel.FlxState;

using StringTools;

class PlayState extends FlxState
{
	var map_tiles:FlxTypedGroup<Tile>;
	var map_tiles_overlay:FlxTypedGroup<Tile>;

	var player:Player;

	var level:Int = 1;

	override public function create()
	{
		super.create();

		map_tiles = new FlxTypedGroup<Tile>();
		add(map_tiles);

		map_tiles_overlay = new FlxTypedGroup<Tile>();
		add(map_tiles_overlay);

		map_tiles = readMap('map-' + level);
		map_tiles_overlay = readMap('map-' + level + '-overlay');

		if (map_tiles == null)
			throw 'NULL MAP : WTF';

		player = new Player();
		player.scale.set(2, 2);
		player.updateHitbox();

		var startPosFile:Array<String> = Assets.exists('assets/data/map-' + level + '-startpos.txt') ? Assets.getText('assets/data/map-' + level + '-startpos.txt')
			.split('\n') : ['0', '0'];
		var startPosX:Int = Std.parseInt(startPosFile[0]);
		var startPosY:Int = Std.parseInt(startPosFile[1]);

		player.setPosition((startPosX * 8) * 4, (startPosY * 8) * 4);
		player.animation.play('walk');
		add(player);
		player.dir = 0;

		FlxG.camera.zoom = 2;
		FlxG.camera.follow(player, LOCKON, 1);
	}

	public function readMap(name:String = 'map'):FlxTypedGroup<Tile>
	{
		var new_map_tiles = new FlxTypedGroup<Tile>();
		add(new_map_tiles);

		if (!Assets.exists('assets/data/' + name + '.txt'))
			return null;

		var map = Assets.getText('assets/data/' + name + '.txt');
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
					new_map_tiles.add(tile_sprite);
				}

				x++;
			}

			y++;
			x = 0;
		}

		return new_map_tiles;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([A, LEFT]))
		{
			player.flipX = false;
			player.dir = 0;
			player.x -= player.width;

			for (tile in map_tiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.x += player.width;
		}
		if (FlxG.keys.anyJustReleased([D, RIGHT]))
		{
			player.flipX = true;
			player.dir = 1;
			player.x += player.width;

			for (tile in map_tiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.x -= player.width;
		}

		if (FlxG.keys.anyJustReleased([W, UP]))
		{
			player.dir = 2;
			player.y -= player.height;

			for (tile in map_tiles.members)
				if (player.overlaps(tile) && tile.exists && tile.has_collisions)
					player.y += player.height;
		}
		if (FlxG.keys.anyJustReleased([S, DOWN]))
		{
			player.dir = 3;
			player.y += player.height;

			for (tile in map_tiles.members)
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

			for (tile in map_tiles.members)
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
