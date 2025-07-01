extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage: UpgradeButtonBase = $Damage

var stone_map: Dictionary[LevelTypes.types, ItemTypes.types] = {
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

func damage_pattern(_l:int, _lt: LevelTypes.types, upgrades_per_level:int) ->Dictionary[ItemTypes.types, int]:
		_l -= upgrades_per_level * (_lt -1 )
		return {
				stone_map[_lt- 1]: floor(2 *_l), 
				stone_map[_lt]: 1+ floor(0.5*_l), 
				}

func level1():
	var u: UpgradeProperties;
	var upgrades_per_level: int;
	u = UpgradeProperties.new();
	upgrades_per_level = 10
	u.skill_name = "Damage";
	u.upgrade_type = UpgradeTypes.types.DAMAGE_1;
	u.max_level = 		(func(_l: LevelTypes.types) -> int: return _l * upgrades_per_level);
	u.get_level = 		(func(_l: int)-> LevelTypes.types:
		if _l == 0: return LevelTypes.types.FIRST
		return (ceil(_l / float(upgrades_per_level)) as LevelTypes.types) )
	u.apply_upgrade = 	(func(_l: int):upgrade_stats.mining_damage += 1.0);
	u.cost_func  = 		(func(_l: int) -> Dictionary[ItemTypes.types, int]:
		var _lt =  u.get_level.call(_l)
		match _lt:
			LevelTypes.types.FIRST:
				return {ItemTypes.types.RED_CAP_STONE: 1+ floor(0.5 * _l)}
			_:
				return damage_pattern(_l, _lt, upgrades_per_level);
		);
	damage.upgrade_properties = u;
	


func _ready() -> void:
	level1();
