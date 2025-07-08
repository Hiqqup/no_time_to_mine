extends CanvasLayer
@onready var get_resources: Button = $PanelContainer/HBoxContainer/GetResources
@onready var reset_upgrades: Button = $PanelContainer/HBoxContainer/ResetUpgrades
@onready var _forge: Forge= get_tree().get_first_node_in_group("forge");

func _ready() -> void:
	if GlobalConstants.COMPILED():
		visible = false;
		queue_free()
	else:
		get_resources.pressed.connect(func():
			for key in _forge._save_state.forge_storage.keys():
				_forge._save_state.forge_storage[key] = 9999;
			_forge.save_game();
			)
		reset_upgrades.pressed.connect(func():
			for key in _forge._save_state.upgrades_purchased.keys():
				_forge._save_state.upgrades_purchased[key] = 0;
			_forge.save_game();
			)


func _on_reset_levels_pressed() -> void:
	_forge._save_state.max_unlocked_level = LevelTypes.types.FIRST;
	for key in _forge._save_state.times_level_completed.keys():
		_forge._save_state.times_level_completed[key] = 0;
	_forge.save_game();


func _on_upgrades_and_levels_pressed() -> void:
	var s: SaveState = preload("res://src/resources/save_state_2.tres")
	_forge._save_state.upgrades_purchased = s.upgrades_purchased.duplicate();
	_forge._save_state.max_unlocked_level = s.max_unlocked_level;
	_forge.save_game()
