extends Node2D

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _collector_scene: PackedScene;
@export var _level_types: LevelTypes;


func _ready():
	
	var pos_offset: float = 4.0;
	for i in _upgrade_stats.collector_amount:
		var collector: Collector = _collector_scene.instantiate();
		collector.position = _player.position;
		
		collector.position += Vector2(-1,-1) * pos_offset;
		add_child(collector);
		pos_offset+= 4.0;
