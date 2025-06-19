extends Node2D

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _minion_scene: PackedScene;

func _ready():
	var y_pos: float = 0;
	print( _upgrade_stats.minion_amount);
	for i in _upgrade_stats.minion_amount:
		var minion: Minion = _minion_scene.instantiate();
		minion.position = _player.position;
		minion.position.y += y_pos;
		y_pos+= 15.0;
		add_child(minion);
