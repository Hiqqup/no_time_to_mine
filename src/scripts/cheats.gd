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
