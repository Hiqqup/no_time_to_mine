extends CanvasLayer


@export var _animation_player: AnimationPlayer;

func change_scene(callable: Callable):
	#print("transitioning...")
	if _animation_player.is_playing():
		return;
	_animation_player.play("dissolve");
	await _animation_player.animation_finished;
	callable.call();
	$MidTranisition.play();
	_animation_player.play("reverse_dissolve");
