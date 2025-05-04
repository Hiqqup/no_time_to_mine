class_name UpgradeButtonBase
extends TextureButton

@export var max_level: int;
@export var skill_name: String;

# set from outside
var apply_upgrade: Callable;
var cost_func: Callable:
	set(call):
		cost_func = call;
		cost = cost_func.call(level);


var cost: Dictionary[ItemTypes.types, int]:
	set(value):
		cost = value;
		_generate_cost_display();
var _forge_storage_contents: Dictionary[ItemTypes.types, int];

var level : int = 0:
	set(value):
		if level == 0:
			modulate = Color.WHITE;
		level = value;
		$ChildGetter.skill_progress.text = str(level) + "/" + str(max_level)


func _ready() -> void:
	_forge_storage_contents = (
		get_tree()
		.get_first_node_in_group("forge")
		.get_node("Storage")
		.contents);
	
	$ChildGetter.skill_progress.text = str(level) + "/" + str(max_level);
	$ChildGetter.skill_name.text = skill_name;
	
	$ChildGetter.info_label.visible = false;
	var parent = get_parent();
	if parent is UpgradeButtonBase:
		$ChildGetter.connection_to_parent.add_point(global_position + size/2)
		$ChildGetter.connection_to_parent.add_point(parent.global_position + parent.size/2);


func _generate_cost_display():
	$GuiItemListDisplayer.generate_or_update($ChildGetter.skill_cost, cost);


func _on_pressed() -> void:
	if not _check_affordable() or level == max_level:
		return;
	_appy_cost()
	get_tree().get_first_node_in_group("forge").update_and_generate_storage_display();
	level += 1;
	cost = cost_func.call(level);
	apply_upgrade.call();
	for child in get_children():
		if child is UpgradeButtonBase:
			child.visible = true;


func _on_mouse_entered() -> void:
	$ChildGetter.info_label.visible = true;


func _on_mouse_exited() -> void:
	$ChildGetter.info_label.visible = false;


func _check_affordable() ->bool:
	for key in cost.keys():
		if cost[key] > _forge_storage_contents[key]:
			return false;
	return true;


func _appy_cost():
	for key in cost.keys():
		_forge_storage_contents[key] -= cost[key]; 
