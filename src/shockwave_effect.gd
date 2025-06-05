extends CanvasLayer

@onready var tween: Tween = Tween.new();

func at(shockwave_center: Vector2):
	$ColorRect.set_instance_shader_parameter("Center", shockwave_center);
	$AnimationPlayer.play("shockwave");
