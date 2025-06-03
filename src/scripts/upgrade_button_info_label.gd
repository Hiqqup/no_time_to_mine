extends MarginContainer
class_name UpgradeButtonInfoLabel

var upgrade_properties: UpgradeProperties;

@export_category("frame colors")
@export var _yellow: Color;
@export var _red: Color;
@export var _green: Color;


@onready var _skill_name: Label = $MarginContainer/VBoxContainer/SkillName;
@onready var _skill_progress: Label = $MarginContainer/VBoxContainer/Progress;
@onready var _gui_item_list_displayer: Node = $GuiItemListDisplayer;
@onready var _cost_container: BoxContainer = $MarginContainer/VBoxContainer/Cost;

func generate_cost_display(cost: Dictionary[ItemTypes.types, int]):
	_gui_item_list_displayer.generate_or_update(_cost_container, cost);

func remove_cost_display():
	_cost_container.queue_free();


func update_level(level: int):
	if not upgrade_properties:
		return;
	_skill_progress.text = str(level) + "/" + str(upgrade_properties.max_level)


func setup(level: int,upgrade_props: UpgradeProperties):
	upgrade_properties = upgrade_props;
	update_level(level)
	_skill_name.text = upgrade_properties.skill_name;
