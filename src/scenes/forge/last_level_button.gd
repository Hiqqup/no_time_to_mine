extends UpgradeButtonBase
class_name LastLevelButton
@onready var _visuals: Control = $WrapperButton/Visuals
@export var _gem_scene: PackedScene
@onready var _particles: CPUParticles2D = $WrapperButton/ButtonAnimationWrapperContainer/Wrapper/Explosion
@onready var _animation_wrapper: Control = $WrapperButton/ButtonAnimationWrapperContainer/Wrapper
@onready var boss_unlocked:bool = false :
	set(value):
		boss_unlocked = value
		if value:
			_visuals.modulate = Color.WHITE;
		else:
			_visuals.modulate = Color.DARK_GRAY;


func unlock():
	TimeoutCallback.timeout_callback(4, func():
		boss_unlocked = true;
		)
	TimeoutCallback.timeout_callback(3.5, func():
		pan_camera_to_and_unlock()
		add_gem(LevelTypes.types.size() -1);
		)

func _ready() -> void:
	if false:
		_animation_wrapper = null;
	super();
	visible = true;
	_visuals.modulate = Color.DARK_GRAY;
	_info_label._skill_name.text = "Back to the source..."
	_info_label._skill_progress.visible = false;
	_info_label._cost_container.visible = false;
	_info_label._update_scale();
	_particles.scale = 2 * Vector2.ONE;
	
	_wrapper_button.pressed.disconnect(_on_wrapper_button_pressed);
	_wrapper_button.pressed.connect(_try_last_level);
	

	
	for i in LevelTypes.types.size():
		if (LevelTypes.is_higher(_forge._save_state.max_unlocked_level  , i) and 
			not i in LevelTypes.not_playable
		):
			add_gem(i, false);

func add_gem(lvl: LevelTypes.types , do_visual_feedback: bool = true):
	var gem: LastLevelButtonGem = _gem_scene.instantiate();
	_wrapper_button.add_child(gem);
	gem.setup(lvl, do_visual_feedback);
	

func pan_camera_to_and_unlock():
	create_tween().tween_property(Camera, "global_position", global_position+ size/2, 0.5);
	TimeoutCallback.timeout_callback(0.5, func():
		_animation_player.play("level_unlocked")
		)


func _try_last_level():
	if not boss_unlocked:
		_animation_player.play("denied")
		Camera.shake(6)
		return;
	Camera.shake(20);
	_forge._try_level(LevelTypes.types.BOSS);
	
