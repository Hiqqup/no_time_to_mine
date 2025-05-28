extends Control
class_name Forge;

signal upgrade_purchased

@export var _mine_scene: PackedScene
@export var _vcontainer: VBoxContainer;
@export var _save_state: SaveState;

var _skill_tree_root:UpgradeButtonBase;

var upgrades_purchased: Dictionary[UpgradeTypes.types, int];
var selected_level: LevelTypes.types = LevelTypes.types.FIRST;



func _enter_tree() -> void:
	_load_save_state();

func _ready() -> void:
	visibility_changed.connect(func(): $CameraIndependent.visible = visible)
	
	_skill_tree_root = $SkillTree/Damage;
	_skill_tree_root.visible = true;
	
	update_and_generate_storage_display()





func purchase_upgrade(type : UpgradeTypes.types):
	upgrades_purchased[type] += 1;
	save_game();
	upgrade_purchased.emit();

func increment_level():
	if selected_level != _save_state.max_unlocked_level:
		return;
	if (LevelTypes.types.find_key(_save_state.max_unlocked_level + 1) != null 
		and _save_state.max_unlocked_level != LevelTypes.types.TUTORIAL):
		_save_state.max_unlocked_level = ((_save_state.max_unlocked_level +1) as LevelTypes.types)

func update_and_generate_storage_display():
	$GuiItemListDisplayer.generate_or_update(_vcontainer, $Storage.contents)

func save_game():
	ResourceSaver.save(_save_state, _save_state.resource_path);

func switch_from_mines():
		visible = true;
		$CameraIndependent/LevelSelector.update();
		update_and_generate_storage_display();
		save_game();
		Camera.location = Camera.CameraLocation.FORGE;


func _load_save_state():
	if (_save_state.forge_storage == {}):
		_save_state.forge_storage = $Storage.contents;
	else:
		$Storage.contents = _save_state.forge_storage;
	if (_save_state.upgrades_purchased == {}):
		for key in UpgradeTypes.types.size():
			upgrades_purchased[key] = 0;
			_save_state.upgrades_purchased = upgrades_purchased;
	else:
		upgrades_purchased = _save_state.upgrades_purchased;


func _try_level(level: LevelTypes.types):
	get_tree().get_first_node_in_group("screen_transition").change_scene(
	func():
		selected_level = level;
		visible = false;
		Camera.location = Camera.CameraLocation.MINES;
		Camera.reset_zoom();
		var mines = _mine_scene.instantiate();
		get_parent().add_child(mines);
	)
