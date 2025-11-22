package;

import flixel.FlxSprite;
import lime.app.Application;
import sphis.trijam347.PlayState;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		#if web
		// pixel perfect render fix!
		Application.current.window.element.style.setProperty("image-rendering", "pixelated");
		#end
	}
}
