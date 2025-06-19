extends Node2D

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _minion_scene: PackedScene;

func _ready():
	var pos_offset: float = 4.0;
	for i in _upgrade_stats.minion_amount:
		var minion: Minion = _minion_scene.instantiate();
		minion.position = _player.position;
		minion.position += Vector2(1,-1) * pos_offset;
		minion._player = _player;
		pos_offset+= 4.0;
		add_child(minion);
