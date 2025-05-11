extends Control

@export var upgrade_stats: PlayerUpgradeStats;


func _ready() -> void:
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Damage";
	u.max_level = 100;
	u.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.ORANGE_DROP: 1+ floor(0.5 * level), 
		});
	$Damage.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Mining Speed"
	u.max_level = 10
	u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration *= 0.9);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.ORANGE_DROP: 2,
		ItemTypes.types.BLACK_DROP: 1+level,
		});
	$Damage/MiningSpeed.upgrade_properties = u;
	
