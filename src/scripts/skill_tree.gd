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
@onready var damage_4: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4
@onready var damage_5: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4/Damage5
@onready var damage_6: UpgradeButtonBase = $Damage1/Damage2/Damage3/Damage4/Damage5/Damage6
@onready var minion_amount_3: UpgradeButtonBase = $Damage1/MinionAmount1/MinionAmount2/MinionAmount3
@onready var minion_scaling_1: UpgradeButtonBase = $Damage1/MinionAmount1/MinionScaling1
@onready var collector_amount_1: UpgradeButtonBase = $Damage1/Damage2/Damage3/CollectorAmount1
@onready var mining_speed_4: UpgradeButtonBase = $Damage1/MiningSpeed1/MiningSpeed2/MiningSpeed3/MiningSpeed4
@onready var minion_damage_3: UpgradeButtonBase = $Damage1/MinionAmount1/MinionDamage1/MinionDamage2/MinionDamage3
@onready var minion_scaling_2: UpgradeButtonBase = $Damage1/MinionAmount1/MinionScaling1/MinionScaling2
@onready var orb_scaling_1: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbScaling1
@onready var collector_scaling_1: UpgradeButtonBase = $Damage1/Damage2/Damage3/CollectorAmount1/CollectorScaling1
@onready var mining_speed_6: UpgradeButtonBase = $Damage1/MiningSpeed1/MiningSpeed2/MiningSpeed3/MiningSpeed4/MiningSpeed5/MiningSpeed6
@onready var orb_scaling_3: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbScaling1/OrbScaling2/OrbScaling3
@onready var collector_scaling_2: UpgradeButtonBase = $Damage1/Damage2/Damage3/CollectorAmount1/CollectorScaling1/CollectorScaling2
@onready var minion_amount_5: UpgradeButtonBase = $Damage1/MinionAmount1/MinionAmount2/MinionAmount3/MinionAmount4/MinionAmount5
@onready var minion_scaling_4: UpgradeButtonBase = $Damage1/MinionAmount1/MinionScaling1/MinionScaling2/MinionScaling3/MinionScaling4
@onready var mining_speed_5: UpgradeButtonBase = $Damage1/MiningSpeed1/MiningSpeed2/MiningSpeed3/MiningSpeed4/MiningSpeed5
@onready var orb_scaling_2: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbScaling1/OrbScaling2
@onready var minion_amount_4: UpgradeButtonBase = $Damage1/MinionAmount1/MinionAmount2/MinionAmount3/MinionAmount4
@onready var minion_scaling_3: UpgradeButtonBase = $Damage1/MinionAmount1/MinionScaling1/MinionScaling2/MinionScaling3
@onready var minion_damage_5: UpgradeButtonBase = $Damage1/MinionAmount1/MinionDamage1/MinionDamage2/MinionDamage3/MinionDamage4/MinionDamage5
@onready var minion_damage_4: UpgradeButtonBase = $Damage1/MinionAmount1/MinionDamage1/MinionDamage2/MinionDamage3/MinionDamage4
@onready var orb_damage_1: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbDamage1
@onready var orb_damage_2: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbDamage1/OrbDamage2
@onready var orb_damage_3: UpgradeButtonBase = $Damage1/Damage2/OrbAmount1/OrbDamage1/OrbDamage2/OrbDamage3


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
	LevelTypes.types.FOURTH: mining_speed_4,
	LevelTypes.types.FIFTH: mining_speed_5,
	LevelTypes.types.SIXTH: mining_speed_6,
}
@onready var minion_amount_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.SECOND: minion_amount_1,
	LevelTypes.types.THIRD: minion_amount_2,
	LevelTypes.types.FOURTH: minion_amount_3,
	LevelTypes.types.FIFTH: minion_amount_4,
	LevelTypes.types.SIXTH: minion_amount_5,
}
@onready var minion_damage_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.SECOND: minion_damage_1,
	LevelTypes.types.THIRD: minion_damage_2,
	LevelTypes.types.FOURTH: minion_damage_3,
	LevelTypes.types.FIFTH: minion_damage_4,
	LevelTypes.types.SIXTH: minion_damage_5,
}

@onready var minion_scaling_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.THIRD: minion_scaling_1,
	LevelTypes.types.FOURTH: minion_scaling_2,
	LevelTypes.types.FIFTH: minion_scaling_3,
	LevelTypes.types.SIXTH: minion_scaling_4,
}
@onready var collector_amount_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FOURTH: collector_amount_1,
}
@onready var orb_scaling_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FOURTH: orb_scaling_1,
	LevelTypes.types.FIFTH: orb_scaling_2,
	LevelTypes.types.SIXTH: orb_scaling_3,
}
@onready var orb_damage_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FOURTH: orb_damage_1,
	LevelTypes.types.FIFTH: orb_damage_2,
	LevelTypes.types.SIXTH: orb_damage_3,
}
@onready var collector_scaling_node_map: Dictionary[LevelTypes.types, UpgradeButtonBase] = {
	LevelTypes.types.FIFTH: collector_scaling_1,
	LevelTypes.types.SIXTH: collector_scaling_2,
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
	LevelTypes.types.FOURTH: ItemTypes.types.MALACHITE_ORE,
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
	if level_unlocked == LevelTypes.types.FIRST:
		u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
			return {
			ItemTypes.types.RED_CAP_STONE:floor(0.5 * level) +1 , 
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
	u.upgrade_type = UpgradeTypes.types.get("MINION_AMOUNT_" + str(level_unlocked-1));
	u.max_level = 1
	u.apply_upgrade = (func():upgrade_stats.minion_amount +=  1);
	u.cost_func  = (func (_level:int) -> Dictionary[ItemTypes.types, int]:
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
	u.upgrade_type = UpgradeTypes.types.get("MINION_DAMAGE_" + str(level_unlocked-1));
	u.max_level = 10
	u.apply_upgrade = (func():upgrade_stats.minion_mining_damage +=  float(level_unlocked));
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			ore_map[level_unlocked -1]: 2, 
			stone_map[level_unlocked]: 1 + level,
		});
	u.level_unlocked = level_unlocked;
	minion_damage_node_map[level_unlocked].upgrade_properties = u;
func minion_scaling(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Minion Scaling"
	u.upgrade_type = UpgradeTypes.types.get("MINION_SCALING_" + str(level_unlocked-2));
	u.max_level = 3
	u.apply_upgrade = (func():upgrade_stats.minion_scaling +=  0.05);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			stone_map[level_unlocked -1]: 5 + level , 
			ore_map[level_unlocked]: 1 + level,
		});
	u.level_unlocked = level_unlocked;
	minion_scaling_node_map[level_unlocked].upgrade_properties = u;
func collector_amount(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Collector Amount"
	u.upgrade_type = UpgradeTypes.types.get("COLLECTOR_AMOUNT_" + str(level_unlocked-3));
	u.max_level = 1
	u.apply_upgrade = (func():upgrade_stats.collector_amount +=  1);
	u.cost_func  = (func (_level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			ore_map[level_unlocked]: 1+ _level, 
			ore_map[level_unlocked-1]: 2 + _level,
		});
	u.level_unlocked = level_unlocked;
	collector_amount_node_map[level_unlocked].upgrade_properties = u;
func orb_scaling(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Orb Scaling"
	u.upgrade_type = UpgradeTypes.types.get("ORB_SCALING_" + str(level_unlocked-3));
	u.max_level = 3
	u.apply_upgrade = (func():upgrade_stats.orb_scaling +=  2.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			stone_map[level_unlocked -1]: 3 + level , 
			ore_map[level_unlocked]: 1 + level,
		});
	u.level_unlocked = level_unlocked;
	orb_scaling_node_map[level_unlocked].upgrade_properties = u;

func collector_scaling(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Collector Scaling"
	u.upgrade_type = UpgradeTypes.types.get("COLLECTOR_SCALING_" + str(level_unlocked-4));
	u.max_level = 10
	u.apply_upgrade = (func():upgrade_stats.collector_scaling +=  2.0);
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
			stone_map[level_unlocked -1]: 1 + 2* level , 
			stone_map[level_unlocked]: 1 + 2* level,
		});
	u.level_unlocked = level_unlocked;
	collector_scaling_node_map[level_unlocked].upgrade_properties = u;

func orb_damage(level_unlocked: LevelTypes.types):
	var u: UpgradeProperties;
	u = UpgradeProperties.new();
	u.skill_name = "Orb Damage";
	u.upgrade_type = UpgradeTypes.types.get("ORB_DAMAGE_" + str(level_unlocked - 3));
	u.max_level = 10;
	u.apply_upgrade = (func():upgrade_stats.orb_damage += float(level_unlocked));
	u.cost_func  = (func (level:int) -> Dictionary[ItemTypes.types, int]:
		return {
		stone_map[level_unlocked]: 1+ floor(2* level), 
		ore_map[level_unlocked-1]: 2 + floor(0.25 *  level),
		});
	u.level_unlocked = level_unlocked;
	orb_damage_node_map[level_unlocked].upgrade_properties = u;

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
	mining_speed(lu);
	minion_amount(lu);
	minion_damage(lu);
	minion_scaling(lu);
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
	mining_speed(lu);
	minion_amount(lu);
	minion_damage(lu);
	minion_scaling(lu);
	collector_amount(lu);
	orb_scaling(lu)
	orb_damage(lu);
	#MINION_AUTO_TARGET_1,
	lu =LevelTypes.types.FIFTH
	damage(lu);
	mining_speed(lu);
	minion_amount(lu);
	minion_damage(lu);
	minion_scaling(lu);
	orb_scaling(lu)
	collector_scaling(lu);
	orb_damage(lu);
	lu =LevelTypes.types.SIXTH
	damage(lu);
	mining_speed(lu);
	minion_amount(lu);
	minion_damage(lu);
	minion_scaling(lu);
	orb_scaling(lu)
	collector_scaling(lu);
	orb_damage(lu);
	
