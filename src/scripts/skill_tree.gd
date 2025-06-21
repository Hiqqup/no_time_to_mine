extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage1: UpgradeButtonBase = $Damage1
@onready var mining_speed1: UpgradeButtonBase = $Damage1/MiningSpeed1
@onready var damage_2: UpgradeButtonBase = $Damage1/Damage2
@onready var minion_amount_1: UpgradeButtonBase = $Damage1/MinionAmount1
@onready var orb_amount_1: UpgradeButtonBase = $Damage1/MinionAmount1/OrbAmount1


func _ready() -> void:
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Damage";
	u.upgrade_type = UpgradeTypes.types.DAMAGE_1;
	u.max_level = 15;
	u.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 1+ floor(0.5 * level), 
		});
	damage1.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Mining Speed"
	u.upgrade_type = UpgradeTypes.types.MINING_SPEED;
	u.max_level = 3
	u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration *= 0.9);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 2,
		ItemTypes.types.GOLD_ORE: 1+level,
		});
	mining_speed1.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Damage";
	u.upgrade_type = UpgradeTypes.types.DAMAGE_2;
	u.max_level = 15;
	u.apply_upgrade = (func():upgrade_stats.mining_damage += 3.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 1+ floor(0.25* level), 
		ItemTypes.types.GREEN_CAP_STONE: 1 + floor(0.5* level),
		});
	u.level_unlocked = LevelTypes.types.SECOND;
	damage_2.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Minions";
	u.upgrade_type = UpgradeTypes.types.MINION_AMOUNT_1;
	u.max_level = 3;
	u.apply_upgrade = (func():upgrade_stats.minion_amount += 1);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.GREEN_CAP_STONE: 5, 
		ItemTypes.types.SILVER_ORE: 3 + 2* level,
		});
	u.level_unlocked = LevelTypes.types.SECOND;
	minion_amount_1.upgrade_properties = u;
	
	u = UpgradeProperties.new();
	u.skill_name = "Orb";
	u.upgrade_type = UpgradeTypes.types.ORB_AMOUNT_1;
	u.max_level = 1;
	u.apply_upgrade = (func():upgrade_stats.orb_amount += 1);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.PURPLE_CAP_STONE: 5, 
		ItemTypes.types.PRISMARINE_ORE: 3 + 2* level,
		});
	u.level_unlocked = LevelTypes.types.THIRD;
	orb_amount_1.upgrade_properties = u;
