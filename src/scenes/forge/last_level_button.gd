extends UpgradeButtonBase
class_name LastLevelButton
@onready var _visuals: Control = $WrapperButton/Visuals
@export var _gem_scene: PackedScene
@onready var _particles: CPUParticles2D = $WrapperButton/ButtonAnimationWrapperContainer/Wrapper/Explosion
@onready var boss_unlocked:bool = false :
	set(value):
		if not value:
			return
		TimeoutCallback.timeout_callback(4.0, func():
			_visuals.modulate = Color.WHITE;
			_animation_player.play("level_unlocked_no_sound")
			)


func _ready() -> void:
	super();
	
	visible = true;
	_visuals.modulate = Color.DARK_GRAY;
	_info_label._skill_name.text = "Back to the source"
	_info_label._skill_progress.visible = false;
	_info_label._cost_container.visible = false;
	_info_label._update_scale();
	_particles.scale = 2 * Vector2.ONE;
	
	_wrapper_button.pressed.disconnect(_on_wrapper_button_pressed);
	_wrapper_button.pressed.connect(_try_last_level);
	
	for i in LevelTypes.types.size():
		if (LevelTypes.is_higher(_forge._save_state.max_unlocked_level  + 1, i) and 
			i != LevelTypes.types.TUTORIAL
		):
			add_gem(i, false);

func add_gem(lvl: LevelTypes.types , do_visual_feedback: bool = true):
	var gem: LastLevelButtonGem = _gem_scene.instantiate();
	_wrapper_button.add_child(gem);
	gem.setup(lvl, do_visual_feedback);
	

func _try_last_level():
	if boss_unlocked:
		_animation_player.play("denied")
		Camera.shake(6)
		return;
	
