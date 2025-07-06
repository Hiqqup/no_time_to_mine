extends CharacterBody2D
class_name Minion

@export var _level_types: LevelTypes;
@export var _upgrade_stats: PlayerUpgradeStats;
var _player: Player;
var _forge : Forge
@onready var speed: float = _upgrade_stats.minion_walking_speed;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
var bounce: Vector2;
var _walking_time: float 
@onready var _visuals: Node2D = $Visuals
var following: CharacterBody2D;
var followed_by: Minion = null;
var currently_mining: HarvestableBase = null;

var _mine_cooldown: float;
@onready var _mining_cooldown_this_run: float = _upgrade_stats.minion_mining_cooldown_duration;

func set_mining(base: HarvestableBase):
	currently_mining = base;
	_mine_cooldown =  _upgrade_stats.minion_mining_cooldown_duration;
	if followed_by:
		followed_by.following = following;
	if following:
		following.followed_by = followed_by;
	followed_by = null;
	
	base.harvested.connect(func():
		_queue_back_up(_player);
		currently_mining = null;
		)


func _physics_process(delta: float) -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]
	
	var dir:Vector2 = _get_dir();
	
	_handle_walking_rotation(dir != Vector2.ZERO, delta)
	
	_handle_dir(dir)
	_mine_cooldown -= delta;
	_try_mine();



func _try_mine() -> void:
	if _mine_cooldown > 0:
		return;
	if currently_mining == null:
		return;
	if not currently_mining.minions_in_range.has(self):
		return;
	#speed *= _upgrade_stats.minion_scaling;
	_mining_cooldown_this_run *= 1/ _upgrade_stats.minion_scaling;
	currently_mining.health -= _upgrade_stats.minion_mining_damage;
	currently_mining.mine_visual_feedback();
	_mine_cooldown = _mining_cooldown_this_run;
	if(currently_mining.health <= 0):
		currently_mining.get_destroyed();
		currently_mining = null;
	mine_visual_feedback()

func _queue_back_up(root: CharacterBody2D):
	if root.followed_by:
		_queue_back_up(root.followed_by);
	else:
		root.followed_by = self;
		following = root;


func mine_visual_feedback():
		#temporary
	var tween =  get_tree().create_tween();
	var start_scale = Vector2.ONE;
	var middle_scale = Vector2.ONE * 0.7;
	(tween.tween_property($Visuals, "scale", middle_scale,0.1)
		.from(start_scale).set_trans(Tween.TRANS_BACK));
	(tween.tween_property($Visuals, "scale", start_scale,0.3)
		.from(middle_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT));



func _get_dir() ->Vector2:
	var dir:= Vector2.ZERO;
	if not following:
		currently_mining = null
		return dir;
	var target_position: Vector2= following.global_position;
	var stop_distance: float = 6.0;
	
	if currently_mining:
		target_position = currently_mining.global_position;
		if currently_mining.minions_in_range.has(self):
			return dir;
	
	if position.distance_to(target_position)>stop_distance:
		dir = position.direction_to(target_position);
		
	return dir


func _apply_bounce():
	bounce*= GlobalConstants.BOUNCE_DECAY;
	velocity += bounce;

func _handle_dir(dir:Vector2):
	velocity = dir* speed;
	_apply_bounce();
	move_and_slide() 
	for i in get_slide_collision_count():
		var collider:Node2D = get_slide_collision(i).get_collider()
		if collider.get_parent().get_parent() is HarvestableBase:
			bounce = collider.global_position.direction_to(global_position) * GlobalConstants.BOUNCE_IMPULSE;

func _handle_walking_rotation(walking: bool, delta: float):
	if walking:
		_walking_time += delta;
		_visuals.rotation = sin(_walking_time * 10)/12;
	else:
		_walking_time = 0;
		_visuals.rotation = lerp(rotation, 0.0, delta * 10);
