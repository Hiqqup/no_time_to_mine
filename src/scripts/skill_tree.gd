extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage1: UpgradeButtonBase = $Damage1
@onready var mining_speed_1: UpgradeButtonBase = $Damage1/MiningSpeed1
@onready var damage_2: UpgradeButtonBase = $Damage1/Damage2
@onready var minion_amount_1: UpgradeButtonBase = $Damage1/MinionAmount1
@onready var orb_amount_1: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1
@onready var mining_speed_2: UpgradeButtonBase = $Damage1/MiningSpeed1/MiningSpeed2
@onready var minion_damage_1: UpgradeButtonBase = $Damage1/MinionAmount1/MinionDamage1
@onready var damage_3: UpgradeButtonBase = $Damage1/Damage2/Damage3
@onready var mining_speed_3: UpgradeButtonBase = $Damage1/MiningSpeed1/MiningSpeed2/MiningSpeed3
@onready var minion_amount_2: UpgradeButtonBase = $Damage1/MinionAmount1/MinionAmount2
@onready var minion_damage_2: UpgradeButtonBase = $Damage1/MinionAmount1/MinionDamage1/MinionDamage2
@onready var minion_speed_1: UpgradeButtonBase = $Damage1/MinionAmount1/MinionSpeed1
@onready var damage_4: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4
@onready var damage_5: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4/Damage5
@onready var damage_6: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4/Damage5/Damage6


func _ready() -> void:
	var u: UpgradeProperties;
	

	#LEVEL 1
	if true: #DAMAGE 1
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_1;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 1.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.RED_CAP_STONE: 1+ floor(0.5 * level), 
			});
		damage1.upgrade_properties = u;
	if true: #MINING SPEED 1
		u = UpgradeProperties.new();
		u.skill_name = "Mining Speed"
		u.upgrade_type = UpgradeTypes.types.MINING_SPEED_1;
		u.max_level = 3
		u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration -= 0.05);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.RED_CAP_STONE: 2,
			ItemTypes.types.GOLD_ORE: 1+level,
			});
		mining_speed_1.upgrade_properties = u;
	#LEVEL 2
	if true: #DAMAGE 2
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_2;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 2.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.RED_CAP_STONE: 1+ floor( level), 
			ItemTypes.types.YELLOW_CAP_STONE: 2 + floor( level),
			});
		u.level_unlocked = LevelTypes.types.SECOND;
		damage_2.upgrade_properties = u;
	if true: #MINING SPEED 2
		u = UpgradeProperties.new();
		u.skill_name = "Mining Speed"
		u.upgrade_type = UpgradeTypes.types.MINING_SPEED_2;
		u.max_level = 1
		u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration -= 0.05);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.YELLOW_CAP_STONE: 5 + level,
			ItemTypes.types.PLATINUM_ORE: 3,
			});
		u.level_unlocked = LevelTypes.types.SECOND;
		mining_speed_2.upgrade_properties = u;
	if true: #MINION AMOUNT 1
		u = UpgradeProperties.new();
		u.skill_name = "Minion Amount";
		u.upgrade_type = UpgradeTypes.types.MINION_AMOUNT_1;
		u.max_level = 1;
		u.apply_upgrade = (func():upgrade_stats.minion_amount += 1);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GOLD_ORE: 2, 
			ItemTypes.types.PLATINUM_ORE: 1 + 2* level,
			});
		u.level_unlocked = LevelTypes.types.SECOND;
		minion_amount_1.upgrade_properties = u;
	if true: #MINION DAMAGE 1
		u = UpgradeProperties.new();
		u.skill_name = "Minion Damage";
		u.upgrade_type = UpgradeTypes.types.MINION_DAMAGE_1;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.minion_mining_damage += 2);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GOLD_ORE: 1, 
			ItemTypes.types.YELLOW_CAP_STONE: 1 + floor(1* level),
			});
		u.level_unlocked = LevelTypes.types.SECOND;
		minion_damage_1.upgrade_properties = u;
	#LEVEL 3
	if true: #DAMAGE 3
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_3;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 3.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.YELLOW_CAP_STONE: 1+ floor( level), 
			ItemTypes.types.GREEN_CAP_STONE: 2 + floor(2* level),
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		damage_3.upgrade_properties = u;
	if true: #MINION AMOUNT 2
		u = UpgradeProperties.new();
		u.skill_name = "Minion Amount";
		u.upgrade_type = UpgradeTypes.types.MINION_AMOUNT_2;
		u.max_level = 1;
		u.apply_upgrade = (func():upgrade_stats.minion_amount += 1);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GREEN_CAP_STONE: 2, 
			ItemTypes.types.SULPHUR_ORE: 1 + 2* level,
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		minion_amount_2.upgrade_properties = u;
	if true: #MINING SPEED 3
		u = UpgradeProperties.new();
		u.skill_name = "Mining Speed"
		u.upgrade_type = UpgradeTypes.types.MINING_SPEED_3;
		u.max_level = 1
		u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration -= 0.05);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GREEN_CAP_STONE: 5 + level,
			ItemTypes.types.SULPHUR_ORE: 3,
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		mining_speed_3.upgrade_properties = u;
	if true: #MINION DAMAGE 2
		u = UpgradeProperties.new();
		u.skill_name = "Minion Damage";
		u.upgrade_type = UpgradeTypes.types.MINION_DAMAGE_2;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.minion_mining_damage += 3);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.SULPHUR_ORE: 1, 
			ItemTypes.types.GREEN_CAP_STONE: 1 + floor(1* level),
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		minion_damage_2.upgrade_properties = u;
	if true: #MINION SCALING 1
		u = UpgradeProperties.new();
		u.skill_name = "Minion Scaling"
		u.upgrade_type = UpgradeTypes.types.MINION_SCALING_1;
		u.max_level = 3
		u.apply_upgrade = (func():upgrade_stats.minion_scaling += 0.05);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GREEN_CAP_STONE: 5 + level,
			ItemTypes.types.SULPHUR_ORE: 3 + level,
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		minion_speed_1.upgrade_properties = u;
	if true: #ORB AMOUNT 1
		u = UpgradeProperties.new();
		u.skill_name = "Orb";
		u.upgrade_type = UpgradeTypes.types.ORB_AMOUNT_1;
		u.max_level = 1;
		u.apply_upgrade = (func():upgrade_stats.orb_amount += 1);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GREEN_CAP_STONE: 1, 
			ItemTypes.types.SULPHUR_ORE: 1 + 2* level,
			});
		u.level_unlocked = LevelTypes.types.THIRD;
		orb_amount_1.upgrade_properties = u;
	#LEVEL 4
	if true: #DAMAGE 4
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_4;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 4.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.GREEN_CAP_STONE: 1+ floor( level), 
			ItemTypes.types.MAGENTA_CAP_STONE: 2 + floor(2* level),
			});
		u.level_unlocked = LevelTypes.types.FOURTH;
		damage_4.upgrade_properties = u;
	#LEVEL 5
	if true: #DAMAGE 5
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_5;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 5.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.MAGENTA_CAP_STONE: 1+ floor( level), 
			ItemTypes.types.CYAN_CAP_STONE: 2 + floor(2* level),
			});
		u.level_unlocked = LevelTypes.types.FIFTH;
		damage_5.upgrade_properties = u;
	#LEVEL 6
	if true: #DAMAGE 6
		u = UpgradeProperties.new();
		u.skill_name = "Damage";
		u.upgrade_type = UpgradeTypes.types.DAMAGE_6;
		u.max_level = 10;
		u.apply_upgrade = (func():upgrade_stats.mining_damage += 6.0);
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.CYAN_CAP_STONE: 1+ floor( level), 
			ItemTypes.types.PURPLE_CAP_STONE: 2 + floor(2* level),
			});
		u.level_unlocked = LevelTypes.types.SIXTH;
		damage_6.upgrade_properties = u;
