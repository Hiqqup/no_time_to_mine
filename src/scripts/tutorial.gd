extends Node2D
@onready var _shattered_player: StartingCutsceneShatteredPlayer = $ShatteredPlayer

var _movement_guide : Node2D;
var _targeting: Node2D;
var _player: Player;
var _mining_guide: Node2D;
var _forge_guide: CanvasLayer;
var _retry_guide: Control;
var _purchase_guide: Control;
var _player_reset_button: Control;
var _forge_level_selector: Control;
var _mobile_guide: Node2D;

var _mines: Mines;
var _forge: Forge;
@onready var skip_starting_cutscene: Button = $CameraIndependet/SkipStartingCutscene

var _player_moved_once: bool = false;
var _player_mined_once: bool = false;
var _mining_guide_displaying: bool = false;
var _first_upgrade_bought: bool = false;
var _forge_camera_locked: bool = false;
var _tutorial_section: TutorialSection = TutorialSection.STARTING_CUTSCENE;
var _skipped_cutscene: bool = false


enum TutorialSection{
	STARTING_CUTSCENE,
	MINES_MOBILE,
	MINES,
	FORGE,
	NONE
}

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_mines = get_tree().get_first_node_in_group("current_mines");

	_movement_guide = $PlayerMovementGuide
	_mining_guide = $MiningGuide
	_mobile_guide = $MobileGuide
	_forge_guide = $ForgeGuide;
	_purchase_guide = $ForgeGuide/PurchaseGuide;
	_retry_guide = $ForgeGuide/RetryGuide;
	
	_movement_guide.visible = false;
	_mining_guide.visible = false;
	_forge_guide.visible = false;
	_purchase_guide.visible = false;
	_retry_guide.visible = false;
	_forge.visible = false;
	_mobile_guide.visible = false;
	_shattered_player.visible = false;
	
	if _forge._save_state.tutorial_completed:
		_mines.queue_free();
		_forge.switch_from_mines();
		queue_free();
		return
	
	
	_forge.selected_level = LevelTypes.types.BOSS;
	_mines.player.visible = false;
	_mines.player.get_node("CameraIndependet/ResetButton").visible = false;
	_mines.player._alive = false;
	_mines.player.position.x =  20000;
	_mines.player.do_lifetime_calculation = false;
	_mines.ready.connect(_setup_starting_cutscene)
	

func _setup_starting_cutscene():
	var endboss_scene: EndbossScene = _mines.get_node("Endboss");
	var ebhso : CanvasItem =  endboss_scene.endboss_harvestable.selected_outline
	Camera.global_position = ebhso.global_position
	ebhso.visible = false;
	ebhso.visibility_changed.connect(func():
		ebhso.visible = false;
		)
	endboss_scene.animate_spirits()
	endboss_scene.spirits_out.connect( func():
		if _skipped_cutscene:
			return
		_transition_from_boss_to_tutorial_level();
		
	)

func _transition_from_boss_to_tutorial_level():
	var screen_transition = get_tree().get_first_node_in_group("screen_transition")
	screen_transition.change_scene(func():
		_forge.selected_level = LevelTypes.types.TUTORIAL
		_mines.queue_free();
		_mines = _forge._mine_scene.instantiate();
		get_parent().add_child(_mines);
		for i in _mines.get_node("YSorted/HarvestabelsLayer").get_children():
			var base :HarvestableBase = i;
			base.mines = _mines;
			base._player = _mines.player;
		Camera.location = Camera.CameraLocation.MINES;
		Camera.reset_zoom();
		Camera.global_position = _mines.player.global_position
		if _skipped_cutscene:
			_start_tutorial()
		else:
			_shard_cutscene_tutorial()
	)
	

func _shard_cutscene_tutorial():
	
	_player= _mines.player
	_player.visible = false;
	_player._alive = false
	for i in _player.get_node("CameraIndependet").get_children():
		i.visible = false;
	
	#tmp
	#_player.go_back_to_forge = false;
	#_player._die_feedback()
	#tmp
	
	
	_shattered_player.reparent(_mines.harvestable_layer)
	_shattered_player.position = _player.position + Vector2(0,6)
	_shattered_player.spread_shards(_mines.floor_layer)
	_shattered_player.visible  = true;

	
	_shattered_player.player_alive.connect(func():
		_shattered_player.visible = false;
		_player.visible = true;
		_player._alive = true
		
		_start_tutorial();
		)

func _start_tutorial():
	_fade_out(skip_starting_cutscene);
	
	_player= _mines.player
	_tutorial_section = TutorialSection.MINES;
	_targeting = _player.get_node("Targeting");
	if not _skipped_cutscene:
		_player_reset_button = _player.get_node("CameraIndependet/ButtonAnimationWrapperContainer");
	else:
		_player_reset_button = _player.get_node("CameraIndependet/ResetButton");
	_forge_level_selector = _forge._new_level_selector;

	
	_player.do_lifetime_calculation = false;
	_player.lifetime_bar.visible = false;
	_player_reset_button.visible = false;
	_targeting.visible = false;
	_forge.visible = false;
	
	
	_forge_level_selector._latest_button_animation_wrapper._wrapper.visible = false;
	_forge._last_level_button._animation_wrapper.visible = false;
	
	_forge._last_level_button._info_label._skill_name.text = ("Destroy all rocks on a level
to go back to the source...")
	_forge._last_level_button._info_label._update_scale()
	
	#Camera.reset_zoom();
	#Camera.location = Camera.CameraLocation.MINES;
	
	_movement_guide.reparent(_player);
	_mining_guide.reparent(_player);
	_mobile_guide.reparent(_player);
	_purchase_guide.reparent(_forge._skill_tree_root);
	
	_forge.upgrade_purchased.connect(_handle_first_upgrade_bought);
	
	
	_forge.selected_level = LevelTypes.types.TUTORIAL;
	_tutorial_section = TutorialSection.MINES
	if GlobalConstants.MOBILE():
		_tutorial_section = TutorialSection.MINES_MOBILE;
	
	TimeoutCallback.timeout_callback(2.0,(func():
		if not _player_moved_once:
			if not GlobalConstants.MOBILE():
				_fade_in(_movement_guide)
			else:
				_fade_in(_mobile_guide)
				#print(_mobile_guide)
		));
	

func _handle_first_upgrade_bought():
	if not _first_upgrade_bought:
		TimeoutCallback.timeout_callback(2, func():
			_fade_in( _retry_guide);
			_forge_level_selector.unlock_level_feedback();
			_forge._last_level_button.pan_camera_to_and_unlock()
			);
		
		Camera.location = Camera.CameraLocation.FORGE;
		$ForgeGuide/NavigationGuide/Label.text = "wasd and drag to move around"
		_fade_out(_purchase_guide)
		TimeoutCallback.timeout_callback(1, func(): _purchase_guide.queue_free());
		_first_upgrade_bought = true;


func _fade_in(node):
	node.visible = true;
	node.modulate = Color(Color.WHITE, 0);
	create_tween().tween_property(node, "modulate", Color.WHITE,1);

func _hide_forge():
	_forge.visible = false;

func _hide_key_display_show_targeting():
	TimeoutCallback.timeout_callback(1.5, (func(): _fade_in(_targeting)));
	if  not _player_mined_once:
		TimeoutCallback.timeout_callback(2, func(): 
			_fade_in(_mining_guide)
			_mining_guide_displaying = true;
			);
	_fade_out(_movement_guide)

func _fade_out(node):
	create_tween().tween_property(node, "modulate", Color(Color.WHITE, 0 ),1);

func _check_player_storage_empty():
	var storage = _player.get_node("Storage")
	return storage.contents[GlobalConstants.FIRST_DROP] != 0;
	
func _check_for_new_forge():
	if not is_instance_valid(_mines) and not _forge_camera_locked:
		Camera.location = Camera.CameraLocation.LOCKED_FORGE; 
		_forge_camera_locked = true;
	return (not is_instance_valid(_mines) 
		and is_instance_valid(get_tree().get_first_node_in_group("current_mines")))


func _set_to_normal_mine():
	_player.do_lifetime_calculation = true;
	_fade_in(_player_reset_button);
	_fade_in(_player.lifetime_bar)
	_mines.reparent(get_parent()); # add to root
	_tutorial_section = TutorialSection.NONE;
	_forge.selected_level = LevelTypes.types.FIRST;
	_player.died.connect(_setup_forge_guide)

func _setup_forge_guide():	
	_tutorial_section = TutorialSection.FORGE
	_forge_guide.visible = true;
	_fade_in(_purchase_guide);
	

func  _process(_delta: float) -> void:
	
	if _tutorial_section == TutorialSection.STARTING_CUTSCENE and Input.is_action_just_pressed("forge_try_again") :
		_on_skip_starting_cutscene_pressed();
	
	#print(_player_mined_once)
	if _tutorial_section == TutorialSection.MINES_MOBILE:
		if _check_player_storage_empty():
			_set_to_normal_mine();
			_fade_out(_mobile_guide);
	
	if _tutorial_section == TutorialSection.MINES:
		var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
		if not _player_moved_once and direction != Vector2.ZERO:
			_player_moved_once = true;
			_hide_key_display_show_targeting();
		if ( is_instance_valid(_player)
		and _player.currently_mining != null 
		and _mining_guide_displaying
		and not _player_mined_once 
		and _player_moved_once):
			_player_mined_once = true;
			_fade_out(_mining_guide);
		if (_player_mined_once and _player_moved_once
			and _check_player_storage_empty()):
			_set_to_normal_mine();
	if _tutorial_section == TutorialSection.FORGE:
		if _check_for_new_forge():
			_forge._last_level_button._info_label._skill_name.text = "Back to the source..."
			_forge._last_level_button._info_label._update_scale()
			_forge._save_state.tutorial_completed = true;
			_forge.save_game();
			queue_free();


func _on_skip_starting_cutscene_pressed() -> void:
	if _skipped_cutscene:
		return;
	_skipped_cutscene=  true;
	_transition_from_boss_to_tutorial_level();
	
