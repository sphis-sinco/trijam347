package sphis.trijam347;

import flixel.FlxG;
import flixel.FlxState;

class GameOver extends FlxState
{
	public var slide:Int = 1;

	override function create()
	{
		super.create();

		slide = 1;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE)
		{
			slide++;
			changeSlide();
		}
	}

	public function changeSlide()
	{
		switch (slide) {}
	}
}
