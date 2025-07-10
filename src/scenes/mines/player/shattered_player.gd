extends Node2D
class_name StartingCutsceneShatteredPlayer

signal player_alive 

@export var _grid_vector_setter_scene : PackedScene
@onready var _shard_container: Node2D = $Shards
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow_2d: PathFollow2D = $Path2D3/PathFollow2D
@onready var spirit_particles: CPUParticles2D = $Path2D3/PathFollow2D/SpiritParticles
const  SPIRIT_HOLD_DURATION: float = 0.5;
const SPIRIT_SPEED_FACTOR:float = 7;
var _shard_positions: Dictionary[Node2D, Vector2];
var _shards : Array[Node2D]
func _ready() -> void:
	pass

func spread_shards(floor_layer: MineFloor):
	
	_animated_sprite_2d.visible = false;
	_shard_container.visible = true;
	for i in _shard_container.get_children():
		_shards.push_back(i);
		_shard_positions[i as Node2D] = (i.position);
	
	#print("shards:")
	for shard in _shards:
		var gvs: GridVectorConverter= _grid_vector_setter_scene.instantiate()
		shard.add_child(gvs);
		var pos : Vector2i = floor_layer.get_random_free_spot()
		shard.global_position = Vector2.ZERO;
		gvs.set_grid_vector(pos)
		shard.add_child($probe.duplicate());
		#print( shard.global_position);
		shard.global_position+= Vector2(0,5)
		floor_layer.used[pos] = true
	_spirit_collect_shards()

func _get_tween_duration(from: Vector2, to: Vector2):
	var distance:float = from.distance_to(to);
	var tween_duration:float = distance * SPIRIT_SPEED_FACTOR / 600
	return tween_duration

func _spirit_to_shard_recursive(shards_copy: Array[Node2D]):
	var shard: Node2D = shards_copy.pop_back();
	var tween_duration:float = _get_tween_duration(spirit_particles.global_position,shard.global_position);
	create_tween().tween_property(spirit_particles, "global_position", shard.global_position, tween_duration)
	TimeoutCallback.timeout_callback(tween_duration, func():
		$ShardReclaimed.play();
		var tween_duration_2 = _get_tween_duration(shard.position,_shard_positions[shard])
		create_tween().tween_property(shard, "position", _shard_positions[shard], tween_duration_2)
		)
	if not shards_copy.is_empty():
		TimeoutCallback.timeout_callback(tween_duration + SPIRIT_HOLD_DURATION, _spirit_to_shard_recursive.bind(shards_copy));
	else:
		TimeoutCallback.timeout_callback(tween_duration + SPIRIT_HOLD_DURATION, func():
			var tween_duration_2 = _get_tween_duration(spirit_particles.global_position,_animated_sprite_2d.global_position)
			create_tween().tween_property(spirit_particles, "global_position", _animated_sprite_2d.global_position, tween_duration_2)
			TimeoutCallback.timeout_callback(tween_duration_2 + SPIRIT_HOLD_DURATION, func():
				_shard_container.visible = false;
				_animated_sprite_2d.visible = true;
				_animated_sprite_2d.play("reverse_die")
				TimeoutCallback.timeout_callback(0.67, $ReverseDie.play)
				create_tween().tween_property(spirit_particles,"modulate",Color(Color.WHITE,0.0),1.2)
				TimeoutCallback.timeout_callback(1.0, func():
					_animated_sprite_2d.animation = "alive";
					player_alive.emit();
					)
				)
			);
	
	

func _spirit_collect_shards():
	spirit_particles.emitting = true
	create_tween().tween_property(path_follow_2d, "progress", 100, SPIRIT_SPEED_FACTOR);
	#speed ca 600/SPIRIT_SPEED_FACTOR
	var shards_copy: Array[Node2D] = _shards.duplicate()

	TimeoutCallback.timeout_callback(SPIRIT_SPEED_FACTOR + SPIRIT_HOLD_DURATION, _spirit_to_shard_recursive.bind(shards_copy));
