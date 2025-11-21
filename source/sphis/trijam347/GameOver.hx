package sphis.trijam347;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class GameOver extends FlxState
{
	public var slide:Int = 1;

    var chebys:FlxSprite;

	override function create()
	{
		super.create();

		slide = 1;
        changeSlide();
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
		switch (slide) {
            case 1:
                chebys = new FlxSprite();
                chebys.loadGraphic('assets/images/gameoverslide/chebys.png');
                chebys.scale.set(4,4);
                chebys.updateHitbox();
                chebys.screenCenter();
                add(chebys);
                FlxG.camera.flash(FlxColor.BLACK);
        }
	}
}
