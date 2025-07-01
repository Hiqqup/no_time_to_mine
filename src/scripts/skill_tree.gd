extends Control

@export var upgrade_stats: PlayerUpgradeStats;

@onready var damage: UpgradeButtonBase = $Damage
@onready var mining_speed: UpgradeButtonBase = $Damage/MiningSpeed
@onready var minion_amount: UpgradeButtonBase = $Damage/MinionAmount
@onready var minion_damage: UpgradeButtonBase = $Damage/MinionAmount/MinionDamage
@onready var orb_amount: UpgradeButtonBase = $Damage/OrbAmount


@onready var _forge :Forge = get_tree().get_first_node_in_group("forge");


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

func mining_speed_pattern(_l:int, _lt: LevelTypes.types, upgrades_per_level:int) ->Dictionary[ItemTypes.types, int]:
		_l -= upgrades_per_level * (_lt -1 )
		return {
				stone_map[_lt]: 2, 
				ore_map[_lt]: 1+ floor(2*_l), 
				}

func minion_amount_pattern(_l:int, upgrades_per_level:int, u: UpgradeProperties) ->Dictionary[ItemTypes.types, int]:
		var _lt :LevelTypes.types=  u.get_level.call(_l)
		_l -= upgrades_per_level * (_lt - u.level_unlocked )
		return {
				stone_map[_lt]: 2, 
				ore_map[_lt]: 1+ floor(2*_l), 
				}

func minion_damage_pattern(_l:int, upgrades_per_level:int, u: UpgradeProperties) ->Dictionary[ItemTypes.types, int]:
		var _lt :LevelTypes.types=  u.get_level.call(_l)
		_l -= upgrades_per_level * (_lt -1 )
		if   _lt < u.level_unlocked: return{};
		return {
				ore_map[_lt-1]: 1 + 2* _l, 
				stone_map[_lt]: 1, 
				}




func upgrade_property_pattern(
	skill_name: String,
		_upgrades_per_level: int,
		level_unlocked: LevelTypes.types,
		upgrade_type:  UpgradeTypes.types,
		apply_upgrade: Callable):
			
	var u := UpgradeProperties.new();
	var upgrades_per_level: int = _upgrades_per_level
	u.skill_name = skill_name;
	u.level_unlocked = level_unlocked;
	u.max_level = 		(func(_l: LevelTypes.types) -> int: return _l * upgrades_per_level);
	u.get_level = 		(func(_l: int)-> LevelTypes.types:
		if _l == 0: return u.level_unlocked;
		return (ceil(_l / float(upgrades_per_level)) as LevelTypes.types) )
	u.apply_upgrade = 	(func(_l: int) -> void : apply_upgrade.call());
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
	var upgrades_per_level: int;
	var u: UpgradeProperties;
	
	(func(): #damage
		u = UpgradeProperties.new();
		upgrades_per_level = 10
		u.skill_name = "Damage";
		u.level_unlocked = LevelTypes.types.FIRST;
		u.upgrade_type = UpgradeTypes.types.DAMAGE;
		u.max_level = 		(func(_l: LevelTypes.types) -> int: return _l * upgrades_per_level);
		u.get_level = 		(func(_l: int)-> LevelTypes.types:
			if _l == 0: return u.level_unlocked;
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
		).call();
	(func():  #miningspeed
		u = UpgradeProperties.new();
		upgrades_per_level = 3
		u.skill_name = "Mining Speed";
		u.level_unlocked = LevelTypes.types.FIRST;
		u.upgrade_type = UpgradeTypes.types.MINING_SPEED;
		u.max_level = 		(func(_l: LevelTypes.types) -> int: return _l * upgrades_per_level);
		u.get_level = 		(func(_l: int)-> LevelTypes.types:
			if _l == 0: return u.level_unlocked
			return (ceil(_l / float(upgrades_per_level)) as LevelTypes.types) )
		u.apply_upgrade = 	(func(_l: int):upgrade_stats.mining_cooldown_duration *= 0.9);
		u.cost_func  = 		(func(_l: int) -> Dictionary[ItemTypes.types, int]:
			var _lt =  u.get_level.call(_l)
			return mining_speed_pattern(_l, _lt, upgrades_per_level);
			);
		mining_speed.upgrade_properties = u;
		).call();
	
	(func():  #minion amount
		u = UpgradeProperties.new();
		upgrades_per_level = 1
		u.skill_name = "Minion Amount";
		u.upgrade_type = UpgradeTypes.types.MINION_AMOUNT;
		u.level_unlocked = LevelTypes.types.SECOND;
		u.max_level = 		(func(_l: LevelTypes.types) -> int: return (_l - u.level_unlocked + 1) * upgrades_per_level);
		u.get_level = 		(func(_l: int)-> LevelTypes.types:
			if _l == 0: return u.level_unlocked
			return ((ceil(_l / float(upgrades_per_level) )+ u.level_unlocked - 1) as LevelTypes.types) )
		u.apply_upgrade = 	(func(_l: int):upgrade_stats.minion_amount += 1);
		u.cost_func  = 		(func(_l: int) -> Dictionary[ItemTypes.types, int]:
			return minion_amount_pattern(_l, upgrades_per_level, u);
			);
		minion_amount.upgrade_properties = u;
		).call()
	(func(): #minon damage
		u = UpgradeProperties.new();
		upgrades_per_level = 10
		u.skill_name = "Minion Damage";
		u.upgrade_type = UpgradeTypes.types.MINION_AMOUNT;
		u.max_level = 		(func(_l: LevelTypes.types) -> int: return _l * upgrades_per_level);
		u.get_level = 		(func(_l: int)-> LevelTypes.types:
			if _l == 0: return LevelTypes.types.FIRST
			return (ceil(_l / float(upgrades_per_level)) as LevelTypes.types) )
		u.apply_upgrade = 	(func(_l: int):upgrade_stats.minion_mining_damage += 2);
		u.level_unlocked = LevelTypes.types.SECOND;
		u.cost_func  = 		(func(_l: int) -> Dictionary[ItemTypes.types, int]:
			return minion_amount_pattern(_l, upgrades_per_level, u);
			);
		minion_damage.upgrade_properties = u;
		).call()
	
	(func(): #orb_amout
		u = UpgradeProperties.new();
		upgrades_per_level = 1
		u.skill_name = "Orb Amount";
		u.upgrade_type = UpgradeTypes.types.ORB_AMOUNT;
		u.max_level = 		(func(_l: LevelTypes.types) -> int: return 1);
		u.get_level = 		(func(_l: int)-> LevelTypes.types:return _forge._save_state.max_unlocked_level )
		u.apply_upgrade = 	(func(_l: int):upgrade_stats.minion_mining_damage += 2);
		u.level_unlocked = LevelTypes.types.THIRD;
		u.cost_func  = 		(func(_l: int) -> Dictionary[ItemTypes.types, int]:
			return minion_amount_pattern(_l, upgrades_per_level, u);
			);
		orb_amount.upgrade_properties = u;
		).call()
	(func(): #le
		).call()
	(func(): #level5
		).call()
	(func(): #level6
		).call()
