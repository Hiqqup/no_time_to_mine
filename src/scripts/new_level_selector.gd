extends Control

@onready var level_list: HBoxContainer = $Scale/PanelContainer/MarginContainer/LevelList
@export var level_types: LevelTypes;


var _already_displaying: Dictionary[LevelTypes.types, bool];
var _forge: Forge ; 

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge");
	for key in LevelTypes.types.size():
		_already_displaying[key] = false;
	update();

func _generate_button(key: int):
	var new_button: TextureButton = TextureButton.new();
	new_button.pressed.connect(func(): _forge._try_level(key));
	new_button.texture_normal = level_types.sprite_map[key];
	level_list.add_child(new_button);
	_already_displaying[key] = true;
	

func update():
	for key in LevelTypes.types.size():
		if (not (key == LevelTypes.types.TUTORIAL 
			or key > _forge._save_state.max_unlocked_level) 
			and not _already_displaying[key] ):
			_generate_button(key)
	
