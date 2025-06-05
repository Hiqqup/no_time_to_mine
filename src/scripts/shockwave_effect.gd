extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func at(shockwave_center: Vector2):
	if animation_player.is_playing():
		return;
	var new_center = shockwave_center/ Vector2(get_viewport().size);
	var shader_material: ShaderMaterial = color_rect.material
	shader_material.set_shader_parameter("center", new_center);
	animation_player.play("shockwave");
	
