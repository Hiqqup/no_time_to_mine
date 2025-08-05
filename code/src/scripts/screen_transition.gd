extends CanvasLayer
@export var level_types: LevelTypes;

@export var _animation_player: AnimationPlayer;
@onready var burn: ColorRect = $Burn

func change_scene(callable: Callable):
	var forge: Forge= get_tree().get_first_node_in_group("forge");
	if forge:
		var color: Color = level_types.color_map[forge._save_state.max_unlocked_level][1];
		
		(burn.material as ShaderMaterial).set_shader_parameter("burnColor", color);
		
	#print("transitioning...")
	if _animation_player.is_playing():
		return;
	_animation_player.play("dissolve");
	await _animation_player.animation_finished;
	callable.call();
	$MidTranisition.play();
	_animation_player.play("reverse_dissolve");
