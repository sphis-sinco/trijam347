package sphis.trijam347;

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
			case 2:
				FlxG.sound.play('assets/sounds/open-door.wav', 1.0);
				chebys.loadGraphic('assets/images/gameoverslide/chebys-open.png');
				FlxTween.tween(chebys, {y: FlxG.height * 2}, 4, {
					onComplete: t ->
					{
						chebys.visible = false;
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
                yener = new FlxSprite();
                yener.loadGraphic('assets/images/gameoverslide/yener.png');
                add(yener);
                yener.setPosition(player.x, player.y -= (player.height * 10));

				FlxTween.tween(player, {y: player.y += (player.height * 10)}, 4, {
					ease: FlxEase.sineInOut,
                });
				FlxTween.tween(yener, {y: yener.y += (yener.height * 10)}, 4, {
					ease: FlxEase.sineInOut,
                });
            case 4:
                player.visible = false;
                yener.visible = false;
				FlxG.camera.flash(FlxColor.RED);
		}

        trace(slide);
	}
}
