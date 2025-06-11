extends Control

@onready var level_list: HBoxContainer = $Scale/PanelContainer/MarginContainer/LevelList
@export var level_types: LevelTypes;
@export var animation_wrapper_scene: PackedScene;
@onready var original_button: TextureButton = $OriginalButton

var _already_displaying: Dictionary[LevelTypes.types, bool];
var _forge: Forge ; 
var _latest_button_animation_player: AnimationPlayer;

var new_level_unlocked: bool = false;

func _ready() -> void:
	
	_forge = get_tree().get_first_node_in_group("forge");
	for key in LevelTypes.types.size():
		_already_displaying[key] = false;
	update();


func _init_button():
	original_button.reparent(level_list);
	original_button.visible  = true;
	var ret = original_button.duplicate()
	original_button.reparent(self);
	original_button.visible  = false;
	return ret;

func _generate_button(key: int):
	var new_button: TextureButton = _init_button();
	new_button.pressed.connect(func(): _forge._try_level(key));
	new_button.texture_normal = level_types.sprite_map[key];
	level_list.add_child(new_button);
	var animation_wrapper = animation_wrapper_scene.instantiate()
	new_button.add_child(animation_wrapper);
	_already_displaying[key] = true;
	_latest_button_animation_player = animation_wrapper.get_node("Wrapper/AnimationPlayer");
	print(new_level_unlocked)
	if new_level_unlocked:
		animation_wrapper.get_node("Wrapper").visible = false;
	
func unlock_level_feedback():
	_latest_button_animation_player.play("level_unlocked")

func update():
	for key in LevelTypes.types.size():
		if (not (key == LevelTypes.types.TUTORIAL 
			or key > _forge._save_state.max_unlocked_level) 
			and not _already_displaying[key] ):
			_generate_button(key)
	if new_level_unlocked:
		new_level_unlocked = false;
		$TimeoutCallback.timeout_callback(0.9, func():unlock_level_feedback());
