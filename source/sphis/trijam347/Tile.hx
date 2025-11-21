package sphis.trijam347;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
	override public function new(tile_index:Int = 1)
	{
		super();

		loadGraphic('assets/images/tiles.png', true, 8, 8);
        animation.add('tiles', [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], 0);
		setTile(tile_index - 1);
	}

	public function setTile(tile:Int = 0)
		this.animation.frameIndex = tile;
}
