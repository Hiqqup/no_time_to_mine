extends Node2D

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _minion_scene: PackedScene;

func _ready():
	var pos_offset: float = 4.0;
	
	var following = _player;
	for i in _upgrade_stats.minion_amount:
		var minion: Minion = _minion_scene.instantiate();
		minion.position = _player.position;
		minion.position += Vector2(1,-1) * pos_offset;
		minion._player = _player;
		minion.following = following
		following.followed_by = minion;
		following = minion;
		
		
		pos_offset+= 4.0;
		add_child(minion);
		
		if minion._upgrade_stats.minion_auto_targeting:
			var forge : Forge = get_tree().get_first_node_in_group("forge")
			(minion as Minion).auto_target_ray.target_position = Vector2(forge._level_types.map[forge.selected_level].platform_radius * 32.0 , 0);
		else:
			minion.auto_target_ray.queue_free();
