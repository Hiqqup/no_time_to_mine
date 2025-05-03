extends Control

@export var _mine_scene: PackedScene


func _ready() -> void:
	visibility_changed.connect(func(): $CameraIndependent.visible = visible)
	
	_hide_all_nodes($SkillTree/Damage)

func _hide_all_nodes(node):
	for child in node.get_children():
		if child is UpgradeButtonBase:
			_hide_all_nodes(child);
			child.visible = false;


func _on_try_button_pressed() -> void:
	
	visible = false;
	Camera.location = Camera.CameraLocation.MINES;
	var mines = _mine_scene.instantiate();
	get_parent().add_child(mines);
