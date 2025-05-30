extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage: UpgradeButtonBase = $Damage
@onready var mining_speed: UpgradeButtonBase = $Damage/MiningSpeed

func _ready() -> void:
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Damage";
	u.upgrade_type = UpgradeTypes.types.DAMAGE;
	u.max_level = 20;
	u.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 1+ floor(0.5 * level), 
		});
	damage.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Mining Speed"
	u.upgrade_type = UpgradeTypes.types.MINING_SPEED;
	u.max_level = 20
	u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration *= 0.9);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 2,
		ItemTypes.types.GOLD_ORE: 1+level,
		});
	mining_speed.upgrade_properties = u;
