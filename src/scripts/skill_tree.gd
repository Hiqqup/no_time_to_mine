extends Control

func _ready() -> void:
	var upgrade_stats: PlayerUpgradeStats = get_tree().get_first_node_in_group("upgrade_stats")
	$Damage.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
	$Damage.cost  = ({ItemTypes.types.ORANGE_DROPS: 2 } as Dictionary[ItemTypes.types, int]);
	
