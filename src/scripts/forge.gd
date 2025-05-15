extends Control

signal upgrade_purchased

@export var _mine_scene: PackedScene
@export var _vcontainer: VBoxContainer;

var skill_tree_root:UpgradeButtonBase;

var selected_level: Level.levels = Level.levels.FIRST;


func _ready() -> void:
	visibility_changed.connect(func(): $CameraIndependent.visible = visible)
	
	skill_tree_root = $SkillTree/Damage;
	_hide_all_nodes(skill_tree_root)
	
	update_and_generate_storage_display()





func increment_level():
	if (Level.levels.find_key(selected_level + 1) != null 
		and selected_level != Level.levels.TUTORIAL):
		selected_level += 1

func update_and_generate_storage_display():
	$GuiItemListDisplayer.generate_or_update(_vcontainer, $Storage.contents)


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
