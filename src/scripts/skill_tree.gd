extends Control

func _ready() -> void:
	var upgrade_stats: PlayerUpgradeStats = get_tree().get_first_node_in_group("upgrade_stats")
	$Damage.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
	$Damage.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {ItemTypes.types.ORANGE_DROP: 2+level });
	$Damage/MiningSpeed.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration *= 0.9);
	$Damage/MiningSpeed.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.ORANGE_DROP: 2,
		ItemTypes.types.BLACK_DROP: 1+level
		 });
	
