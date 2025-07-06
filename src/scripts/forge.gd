extends Control
class_name Forge;

signal upgrade_purchased

@export var _mine_scene: PackedScene
@export var _vcontainer: VBoxContainer;
@export var _save_state: SaveState;
@export var _level_types: LevelTypes;

var _skill_tree_root:UpgradeButtonBase;

var upgrades_purchased: Dictionary[UpgradeTypes.types, int];
var selected_level: LevelTypes.types = LevelTypes.types.FIRST;
@onready var _new_level_selector: Control = $CameraIndependent/NewLevelSelector
@onready var _last_level_button: LastLevelButton = $SkillTree/LastLevelButton
var doing_tutorial: bool = false;


func _enter_tree() -> void:
	_load_save_state();

func _ready() -> void:
	_resize_levels();

	visibility_changed.connect(func(): 
		$CameraIndependent.visible = visible
		$BackgourndLayer.visible = visible;
		)
	
	_skill_tree_root = $SkillTree/Damage1;
	_skill_tree_root.visible = true;
	
	update_and_generate_storage_display()
	
	if _save_state.times_level_completed[LevelTypes.types.size()-1]>0:
		_last_level_button.boss_unlocked = true;
		_last_level_button.add_gem(LevelTypes.types.size() -1, false);
	



func _process(_delta: float) -> void:
	#print(LevelTypes.types.SIXTH == LevelTypes.types.size()-1)
	if Input.is_action_just_pressed("forge_try_again") and visible:
		_try_level(selected_level);

func _resize_levels():
	for key in _save_state.times_level_completed.keys():
			for i in _save_state.times_level_completed[key]:
				_level_types.increase_size(key);

func update_all_upgrades():
	var buttons = get_tree().get_nodes_in_group("upgrade_button");
	for button in buttons:
		(button as UpgradeButtonBase).update_frame_sprite();


func purchase_upgrade(type : UpgradeTypes.types):
	upgrades_purchased[type] += 1;
	save_game();
	upgrade_purchased.emit();

func increment_level():
	if doing_tutorial:
		return;
	_level_types.increase_size(selected_level);
	_save_state.times_level_completed[selected_level] +=1;
	if selected_level != _save_state.max_unlocked_level:
		return;
	if selected_level == LevelTypes.types.size() - 1 and _save_state.times_level_completed[LevelTypes.types.size() - 1] == 1 :
		_last_level_button.unlock();
	if (LevelTypes.types.find_key(_save_state.max_unlocked_level + 1) != null):
		_save_state.max_unlocked_level = ((_save_state.max_unlocked_level +1) as LevelTypes.types)
		_new_level_selector.new_level_unlocked = true;


func update_and_generate_storage_display():
	$GuiItemListDisplayer.generate_or_update(_vcontainer, $Storage.contents,true);

func save_game():
	ResourceSaver.save(_save_state, _save_state.resource_path);
	#print(_save_state.resource_path);

func switch_from_mines():
	(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0) as AudioEffectLowPassFilter).cutoff_hz = GlobalConstants.LOW_PASS_FILTER_HZ
	visible = true;
	_new_level_selector.update();
	update_and_generate_storage_display();
	save_game();
	Camera.location = Camera.CameraLocation.FORGE;


func _load_save_state():
	if GlobalConstants.COMPILED():
		if FileAccess.file_exists(GlobalConstants.USER_PATH):
			_save_state = load(GlobalConstants.USER_PATH);
		_save_state.take_over_path(GlobalConstants.USER_PATH);
	
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
	
	if (_save_state.times_level_completed == {}):
		for key in LevelTypes.types.size():
			_save_state.times_level_completed[key] = 0;
	



func _tween_music_up():
	var tween: Tween = create_tween();
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(
		(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0) as AudioEffectLowPassFilter),
		"cutoff_hz",
		15000,
		0.5
		)
		

func _try_level(level: LevelTypes.types):
	var screen_transition = get_tree().get_first_node_in_group("screen_transition")
	_tween_music_up();
	screen_transition.change_scene(func():
		selected_level = level;
		visible = false;
		Camera.location = Camera.CameraLocation.MINES;
		Camera.reset_zoom();
		var mines = _mine_scene.instantiate();
		get_parent().add_child(mines);
	)
