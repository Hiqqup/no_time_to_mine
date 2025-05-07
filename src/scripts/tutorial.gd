extends Node2D

var _movement_guide : Node2D;
var _targeting: Node2D;
var _player: Player;
var _mining_guide: Node2D;
var _forge_gudie: CanvasLayer;
var _mines: Node2D;

var _player_moved_once: bool = false;
var _player_mined_once: bool = false;
var _mining_guide_displaying: bool = false;
var _tutorial_section: TutorialSection = TutorialSection.MINES;

enum TutorialSection{
	MINES,
	FORGE,
	NONE
}

func _ready() -> void:
	var forge = get_tree().get_first_node_in_group("forge")
	call_deferred("_hide_forge");
	
	_movement_guide = $PlayerMovementGuide
	_mining_guide = $MiningGuide
	_player= $Mines/YSorted/Player
	_targeting = _player.get_node("Targeting");
	_forge_gudie = $ForgeGuide;
	_mines = $Mines;
	
	_player.do_lifetime_calculation = false;
	_targeting.visible = false;
	_movement_guide.visible = false;
	_mining_guide.visible = false;
	_forge_gudie.visible = false;
	
	Camera.zoom = Vector2.ONE * 4;
	Camera.location = Camera.CameraLocation.MINES;
	
	_movement_guide.reparent(_player);
	_mining_guide.reparent(_player);
	
	_timeout_callback(1.0,(func():
		if not _player_moved_once:
			_fade_in(_movement_guide)
		));


func _timeout_callback(wait_time: float, callback :Callable)->void:
	# executes set callback $wait_time seconds from now
	var timer: Timer = Timer.new();
	add_child(timer) 
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.timeout.connect(callback);
	timer.start()



func _fade_in(node):
	node.visible = true;
	node.modulate = Color(Color.WHITE, 0);
	create_tween().tween_property(node, "modulate", Color.WHITE,1);

func _hide_forge():
	get_tree().get_first_node_in_group("forge").visible = false;

func _hide_key_display_show_targeting():
	_timeout_callback(1.5, (func(): _fade_in(_targeting)));
	if  not _player_mined_once:
		_timeout_callback(2, func(): 
			_fade_in(_mining_guide)
			_mining_guide_displaying = true;
			);
	_fade_out(_movement_guide)

func _fade_out(node):
	create_tween().tween_property(node, "modulate", Color(Color.WHITE, 0 ),1);

func _check_player_storage_empty():
	var storage = _player.get_node("Storage")
	return not storage.is_empty();
	
func _check_for_new_forge():
	return (not is_instance_valid(_mines) 
		and is_instance_valid(get_tree().get_first_node_in_group("current_mines")))



func  _process(delta: float) -> void:
	#print(_player_mined_once)
	if _tutorial_section == TutorialSection.MINES:
		var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
		if not _player_moved_once and direction != Vector2.ZERO:
			_player_moved_once = true;
			_hide_key_display_show_targeting();
		if (_player.currently_mining != null 
		and _mining_guide_displaying
		and not _player_mined_once 
		and _player_moved_once):
			_player_mined_once = true;
			_fade_out(_mining_guide);
		if (_player_mined_once and _player_moved_once
			and _check_player_storage_empty()):
			_player.do_lifetime_calculation = true;
			_mines.reparent(get_parent()); # add to root
			_tutorial_section = TutorialSection.NONE;
			_player.died.connect(func(): 
				_tutorial_section = TutorialSection.FORGE
				_forge_gudie.visible = true;
				)
	if _tutorial_section == TutorialSection.FORGE:
		if _check_for_new_forge():
			queue_free();
