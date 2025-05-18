extends Control

@export var level_list: VBoxContainer;
@export var original_button: Button;


var _already_displaying: Dictionary[LevelTypes.types, bool];
var _forge: Forge ; 

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge");
	for key in LevelTypes.types.size():
		_already_displaying[key] = false;
	update();

func _generate_button(key: int):
	var new_button: Button = original_button.duplicate();
	new_button.pressed.connect(func(): _forge._try_level(key));
	new_button.visible = true;
	new_button.text = LevelTypes.types.keys()[key];
	level_list.add_child(new_button);
	_already_displaying[key] = true;
	

func update():
	for key in LevelTypes.types.size():
		if (not (key == LevelTypes.types.TUTORIAL 
			or key > _forge._save_state.max_unlocked_level) 
			and not _already_displaying[key] ):
			_generate_button(key)
	
