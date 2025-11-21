package sphis.trijam347;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
	override public function new(tile_index:Int = 0)
	{
		super();

		loadGraphic('assets/images/tiles.png', true, 8, 8);
		setTile(tile_index);
	}

	public function setTile(tile:Int = 0)
		this.animation.frameIndex = tile;
}
