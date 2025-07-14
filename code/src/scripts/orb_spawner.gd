extends Node2D

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _orb_scene: PackedScene;

func _ready():
	
	for i in _upgrade_stats.orb_amount:
		var orb: Orb = _orb_scene.instantiate();
		orb.position = _player.position;
		#orb._player = _player;
		add_child(orb);
