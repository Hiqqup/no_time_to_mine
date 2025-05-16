class_name UpgradeButtonBase
extends TextureButton


@export var upgrade_properties: UpgradeProperties:
	set(val):
		upgrade_properties = val;
		setup();

# set from outside
var max_level: int;
var skill_name: String;
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
var _forge: Forge;
var _children_visible: bool = false;

var level : int = 0:
	set(value):
		if value != 0:
			_show_all_children();
			modulate = Color.WHITE;
		level = value;
		$ChildGetter.skill_progress.text = str(level) + "/" + str(max_level)


func setup():
	if upgrade_properties == null:
		print("missing upgrade poperties")
		queue_free();
		return;
	
	level = _forge.upgrades_purchased[upgrade_properties.upgrade_type];
	
	cost_func = upgrade_properties.cost_func;
	apply_upgrade = upgrade_properties.apply_upgrade;
	skill_name = upgrade_properties.skill_name;
	max_level = upgrade_properties.max_level;
	
	
	$ChildGetter.skill_progress.text = str(level) + "/" + str(max_level);
	$ChildGetter.skill_name.text = skill_name;
	

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_forge_storage_contents = (_forge.get_node("Storage").contents);
	
	visible = false;
	
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
	_forge.update_and_generate_storage_display();
	_forge.purchase_upgrade(upgrade_properties.upgrade_type);
	level += 1;
	cost = cost_func.call(level);
	apply_upgrade.call();
	_show_all_children();


func _show_all_children():
	if _children_visible:
		return
	for child in get_children():
		if child is UpgradeButtonBase:
			child.visible = true;
	_children_visible = true;


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
