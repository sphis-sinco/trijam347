package sphis.trijam347;

import flixel.FlxSprite;

class Player extends FlxSprite
{
	public var dir:Int = 0;

	override public function new()
	{
		super();

		loadGraphic('assets/images/player.png', true, 16, 18);
		animation.add('walk', [0, 1, 0, 2], 2);
	}
}
