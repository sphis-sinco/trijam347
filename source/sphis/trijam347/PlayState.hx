package sphis.trijam347;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import lime.utils.Assets;
import flixel.FlxState;

using StringTools;

class PlayState extends FlxState
{
	var objective:FlxText;

	var map_tiles:FlxTypedGroup<Tile>;
	var map_tiles_overlay:FlxTypedGroup<Tile>;

	var player:Player;

	var level:String = '1';
	var next_level:String = null;

	var dirty_tiles_start:Int = 0;
	var dirty_tiles:Int = 0;

	override public function new(level:String = '1')
	{
		super();
		this.level = level;
	}

	override public function create()
	{
		super.create();

		next_level = Assets.exists('assets/data/map-' + level + '-next.txt') ? Assets.getText('assets/data/map-' + level + '-next.txt') : null;

		map_tiles = new FlxTypedGroup<Tile>();
		add(map_tiles);

		map_tiles = readMap('map-' + level);

		if (map_tiles == null)
			throw 'NULL MAP : WTF';

		player = new Player();
		player.scale.set(2, 2);
		player.updateHitbox();

		var startPosFile:Array<String> = Assets.exists('assets/data/map-' + level + '-startpos.txt') ? Assets.getText('assets/data/map-' + level
			+ '-startpos.txt')
			.split('\n') : ['0', '0'];
		var startPosX:Int = Std.parseInt(startPosFile[0]);
		var startPosY:Int = Std.parseInt(startPosFile[1]);

		player.setPosition((startPosX * 8) * 4, (startPosY * 8) * 4);
		player.animation.play('walk');
		add(player);
		player.dir = 0;

		map_tiles_overlay = new FlxTypedGroup<Tile>();
		add(map_tiles_overlay);
		map_tiles_overlay = readMap('map-' + level + '-overlay');

		FlxG.camera.zoom = 2;
		FlxG.camera.follow(player, LOCKON, 1);

		objective = new FlxText();
		objective.size = 16;
		objective.text = "Clean up your mess.\n(Space)";
		add(objective);
		objective.scrollFactor.set();
		objective.screenCenter();
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
					if (Std.parseInt(tile) - 1 == 1 || Std.parseInt(tile) - 1 == 2)
					{
						dirty_tiles++;
						dirty_tiles_start++;
					}

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

		if (FlxG.keys.anyJustReleased([W, A, S, D, LEFT, DOWN, UP, RIGHT, SPACE]) && objective.visible)
		{
			objective.visible = false;
		}

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

		if (FlxG.keys.anyJustReleased([SPACE]))
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

			dirty_tiles = dirty_tiles_start;
			for (tile in map_tiles.members)
				if (player.overlaps(tile) && tile.exists)
				{
					tile.interaction((tile_number:Int) ->
					{
						if (tile_number == 4)
						{
							for (tile in map_tiles.members)
								if (tile.cleaned && tile.was_dirty)
									dirty_tiles--;

							if (dirty_tiles == 0)
							{
								if (next_level != null)
								{
									FlxG.switchState(() -> new PlayState(next_level));
								}
								else
								{
									FlxG.switchState(() -> new GameOver());
								}
							}
						}
					});
				}

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
