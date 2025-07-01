extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage_1: UpgradeButtonBase = $Damage1
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
@onready var minion_amount_3: UpgradeButtonBase = $Damage1/MinionAmount1/MinionAmount2/MinionAmount3


@onready var damage_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FIRST: damage_1,
	LevelTypes.types.SECOND: damage_2,
	LevelTypes.types.THIRD: damage_3,
	LevelTypes.types.FOURTH: damage_4,
	LevelTypes.types.FIFTH: damage_5,
	LevelTypes.types.SIXTH: damage_6,
}
@onready var mining_speed_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FIRST: mining_speed_1,
	LevelTypes.types.SECOND: mining_speed_2,
	LevelTypes.types.THIRD: mining_speed_3,
	#LevelTypes.types.FOURTH: mining_speed_4,
	#LevelTypes.types.FIFTH: mining_speed_5,
	#LevelTypes.types.SIXTH: mining_speed_6,
}
@onready var minion_amount_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.SECOND: minion_amount_1,
	LevelTypes.types.THIRD: minion_amount_2,
	LevelTypes.types.FOURTH: minion_amount_3,
	#LevelTypes.types.FIFTH: minion_amount_4,
	#LevelTypes.types.SIXTH: minion_amount_5,
}
@onready var minion_damage_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.SECOND: minion_damage_1,
	LevelTypes.types.THIRD: minion_damage_2,
	#LevelTypes.types.FOURTH: minion_damage_3,
	#LevelTypes.types.FIFTH: minion_damage_4,
	#LevelTypes.types.SIXTH: minion_damage_5,
}


var stone_map: Dictionary[LevelTypes.types, ItemTypes.types] = {
	LevelTypes.types.TUTORIAL: ItemTypes.types.RED_CAP_STONE,
	LevelTypes.types.FIRST: ItemTypes.types.RED_CAP_STONE,
	LevelTypes.types.SECOND: ItemTypes.types.YELLOW_CAP_STONE,
	LevelTypes.types.THIRD: ItemTypes.types.GREEN_CAP_STONE,
	LevelTypes.types.FOURTH: ItemTypes.types.MAGENTA_CAP_STONE,
	LevelTypes.types.FIFTH: ItemTypes.types.CYAN_CAP_STONE,
	LevelTypes.types.SIXTH: ItemTypes.types.PURPLE_CAP_STONE,
}

var ore_map: Dictionary[LevelTypes.types, ItemTypes.types] = {
	LevelTypes.types.FIRST: ItemTypes.types.GOLD_ORE,
	LevelTypes.types.SECOND: ItemTypes.types.PLATINUM_ORE,
	LevelTypes.types.THIRD: ItemTypes.types.SULPHUR_ORE,
	LevelTypes.types.FOURTH: ItemTypes.types.MAGENTA_CAP_STONE,
	LevelTypes.types.FIFTH: ItemTypes.types.AMETHYST_ORE,
	LevelTypes.types.SIXTH: ItemTypes.types.RUBY_ORE,
}


func damage(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Damage";
	u.upgrade_type = UpgradeTypes.types.get("DAMAGE_" + str(level_unlocked));
	u.max_level = 10;
	u.apply_upgrade = (func():upgrade_stats.mining_damage += float(level_unlocked));
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		stone_map[level_unlocked-1]: 1+ floor(2* level), 
		stone_map[level_unlocked]: 2 + floor(0.25 *  level),
		});
	u.level_unlocked = level_unlocked;
	damage_node_map[level_unlocked].upgrade_properties = u;
func mining_speed(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Mining Speed"
	u.upgrade_type = UpgradeTypes.types.get("MINING_SPEED_" + str(level_unlocked));
	u.max_level = 3
	u.apply_upgrade = (func():upgrade_stats.mining_cooldown_duration -= 0.05);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			stone_map[level_unlocked]: 2,
			ore_map[level_unlocked]: 1+level,
		});
	u.level_unlocked = level_unlocked;
	mining_speed_node_map[level_unlocked].upgrade_properties = u;
func minion_amount(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Minion Amount"
	u.upgrade_type = UpgradeTypes.types.get("MINION_AMOUNT_" + str(level_unlocked));
	u.max_level = 1
	u.apply_upgrade = (func():upgrade_stats.minion_amount +=  1);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			ore_map[level_unlocked -1]: 2, 
			ore_map[level_unlocked]: 1,
		});
	u.level_unlocked = level_unlocked;
	minion_amount_node_map[level_unlocked].upgrade_properties = u;

func minion_damage(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Minion Damage"
	u.upgrade_type = UpgradeTypes.types.get("MINION_DAMAGE_" + str(level_unlocked));
	u.max_level = 10
	u.apply_upgrade = (func():upgrade_stats.minion_mining_damage +=  float(level_unlocked));
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			ore_map[level_unlocked -1]: 2, 
			stone_map[level_unlocked]: 1 + level,
		});
	u.level_unlocked = level_unlocked;
	minion_damage_node_map[level_unlocked].upgrade_properties = u;

func _ready() -> void:
	var u: UpgradeProperties;
	

	var lu = LevelTypes.types.FIRST
	damage(lu);
	mining_speed(lu);
	lu = LevelTypes.types.SECOND
	damage(lu);
	mining_speed(lu);
	minion_amount(lu)
	minion_damage(lu);
	lu = LevelTypes.types.THIRD
	damage(lu);
	minion_amount(lu);
	mining_speed(lu);
	minion_damage(lu);
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
	lu = LevelTypes.types.FOURTH
	damage(lu);
	minion_amount(lu);
	lu =LevelTypes.types.FIFTH
	damage(lu);
	lu =LevelTypes.types.SIXTH
	damage(lu);
	
	
	damage_1.upgrade_properties.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		ItemTypes.types.RED_CAP_STONE: 1+ floor(0.5 * level), 
		});
