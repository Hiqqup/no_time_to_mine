extends CharacterBody2D
class_name Minion

@export var _level_types: LevelTypes;
var _player: Player;
var _forge : Forge
var speed: float = 50;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var bounce: Vector2;
var _walking_time: float 
@onready var _visuals: Node2D = $Visuals

func _physics_process(delta: float) -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]
	
	var dir:= Vector2.ZERO;
	if position.distance_to(_navigation_agent_2d.target_position)>4.0:
		dir = position.direction_to(_player.global_position);
		
	_handle_walking_rotation(dir != Vector2.ZERO, delta)
	_apply_bounce_handle_dir(dir)

func _apply_bounce_handle_dir(dir:Vector2):
	dir += bounce;
	bounce*= 0.93
	velocity = dir* speed;
	move_and_slide() 
	for i in get_slide_collision_count():
		var collider:Node2D = get_slide_collision(i).get_collider()
		if collider is StaticBody2D:
			bounce = collider.global_position.direction_to(global_position) * 2.4;

func _handle_walking_rotation(walking: bool, delta: float):
	if walking:
		_walking_time += delta;
		_visuals.rotation = sin(_walking_time * 10)/12;
	else:
		_walking_time = 0;
		_visuals.rotation = lerp(rotation, 0.0, delta * 10);
