package sphis.trijam347;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
	public var has_collisions:Bool = true;
	public var cleaned:Bool = true;
	public var was_dirty:Bool = false;

	override public function new(tile_index:Int = 1)
	{
		super();

		loadGraphic('assets/images/tiles.png', true, 8, 8);
		animation.add('tiles', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 0);
		setTile(tile_index - 1);
	}

	public function setTile(tile:Int = 0)
	{
		this.animation.frameIndex = tile;

		switch (tile)
		{
			default:
				has_collisions = true;
				cleaned = true;
				was_dirty = false;
			case 1,2:
				cleaned = false;
				was_dirty = true;
			case 3, 10, 11, 8, 9, 12, 13:
				has_collisions = false;
		}
	}

	public function interaction(?additional_func:Dynamic)
	{
		if (!exists)
			return;

		switch (this.animation.frameIndex)
		{
			case 1:
				cleaned = true;
				setTile(0);
			case 2:
				setTile(1);
			case 3:
				this.destroy();
			default:
				if (additional_func != null)
					additional_func(this.animation.frameIndex);
		}
	}
}
