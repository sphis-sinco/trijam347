package sphis.trijam347;

import lime.app.Application;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

class GameOver extends FlxState
{
	public var slide:Int = 1;

	var chebys:FlxSprite;
	var player:Player;
	var yener:FlxSprite;

	var proceed:FlxText;

	override function create()
	{
		super.create();

		slide = 1;

		player = new Player();
		player.scale.set(4, 4);
		player.updateHitbox();
		player.screenCenter();
		player.x -= player.width * 2;
		add(player);

		proceed = new FlxText();
		proceed.size = 16;
		proceed.text = "proceed. (space)";
		add(proceed);
		proceed.visible = false;
		proceed.scrollFactor.set();
		proceed.y = FlxG.height - proceed.height;

		changeSlide();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE && proceed.visible)
		{
			slide++;
			changeSlide();
		}
	}

	public function changeSlide()
	{
		remove(proceed);
		proceed.visible = false;
		switch (slide)
		{
			case 1:
				chebys = new FlxSprite();
				chebys.loadGraphic('assets/images/gameoverslide/chebys.png');

				chebys.scale.set(4, 4);
				chebys.updateHitbox();
				chebys.screenCenter();

				chebys.scale.set(8, 8);
				chebys.updateHitbox();
				chebys.screenCenter(X);
				chebys.x += chebys.width / 4;

				add(chebys);
				FlxG.camera.flash(FlxColor.BLACK);
				proceed.visible = true;
			case 2:
				proceed.text = "proceed.";
				FlxG.sound.play('assets/sounds/open-door.wav', 1.0);
				chebys.loadGraphic('assets/images/gameoverslide/chebys-open.png');
				FlxTween.tween(chebys, {y: FlxG.height * 2}, 4, {
					onComplete: t ->
					{
						chebys.visible = false;
						proceed.visible = true;
					},
					ease: FlxEase.sineInOut,
					startDelay: 1,
					onStart: t ->
					{
						player.animation.play('walk');
						FlxG.sound.play('assets/sounds/footsteps.wav', 1.0, false, null, true, () ->
						{
							player.animation.pause();
							player.animation.frameIndex = 0;
						});
					}
				});
			case 3:
				proceed.text = "do it.";
				yener = new FlxSprite();
				yener.loadGraphic('assets/images/gameoverslide/yener.png');
				add(yener);
				yener.setPosition(player.x, player.y - (player.height * 4));
				yener.scale.set(player.scale.x, player.scale.y);
				yener.updateHitbox();

				FlxTween.tween(yener, {y: yener.y + (yener.height * 2)}, 4, {
					ease: FlxEase.sineInOut,
				});
				FlxTween.tween(player, {y: player.y + (player.height * 2)}, 4, {
					ease: FlxEase.sineInOut,
					onComplete: t ->
					{
						proceed.visible = true;
					}
				});
			case 4:
				proceed.text = "run.";
				player.visible = false;
				yener.visible = false;
				FlxG.camera.flash(FlxColor.RED, 1, () -> {});
				FlxG.sound.play('assets/sounds/death.wav', 1.0, false, null, true, () ->
				{
					proceed.visible = true;
				});
			case 5:
				Application.current.window.close();
		}

		add(proceed);
		trace(slide);
	}
}
