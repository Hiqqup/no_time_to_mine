class_name UpgradeButtonBase
extends SkillTreeButtonBase


@export var upgrade_properties: UpgradeProperties:
	set(val):
		upgrade_properties = val;
		setup();

# set from outside


var cost: Dictionary[ItemTypes.types, int]:
	set(value):
		cost = value;
		_info_label.generate_cost_display(cost);
var _forge_storage_contents: Dictionary[ItemTypes.types, int];
var _forge: Forge;
var _children_visible: bool = false;

var level : int = 0:
	set(value):
		if value != 0:
			_show_all_children();
			modulate = Color.WHITE;
		level = value;
		_info_label.update_level(level);


# children:
var _info_label: UpgradeButtonInfoLabel;
var _gui_item_list_displayer: Node;

func setup():
	if upgrade_properties == null:
		#print("missing upgrade poperties")
		return;
	level = _forge.upgrades_purchased[upgrade_properties.upgrade_type];
	
	cost = upgrade_properties.cost_func.call(level);

	for i in level:
		upgrade_properties.apply_upgrade.call();
	
	_info_label.setup(level, upgrade_properties);

	

func _ready() -> void:
	super();
	_forge = get_tree().get_first_node_in_group("forge")
	_forge_storage_contents = (_forge.get_node("Storage").contents);

	# get children:
	_info_label = $InfoLabel;
	
	visible = false;
	
	_info_label.visible = false;


func _on_pressed() -> void:
	if not _check_affordable() or level == upgrade_properties.max_level:
		return;
	_appy_cost()
	_forge.update_and_generate_storage_display();
	_forge.purchase_upgrade(upgrade_properties.upgrade_type);
	level += 1;
	cost = upgrade_properties.cost_func.call(level);
	upgrade_properties.apply_upgrade.call();
	_show_all_children();


func _show_all_children():
	if _children_visible:
		return
	for child in get_children():
		if child is UpgradeButtonBase:
			child.visible = true;
	_children_visible = true;


func _on_mouse_entered() -> void:
	_info_label.visible = true;


func _on_mouse_exited() -> void:
	_info_label.visible = false;


func _check_affordable() ->bool:
	for key in cost.keys():
		if cost[key] > _forge_storage_contents[key]:
			return false;
	return true;


func _appy_cost():
	for key in cost.keys():
		_forge_storage_contents[key] -= cost[key]; 
