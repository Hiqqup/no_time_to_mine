extends Resource
class_name UpgradeProperties

var skill_name: String
var max_level: Callable
var get_level: Callable
var apply_upgrade: Callable
var cost_func: Callable;
var upgrade_type: UpgradeTypes.types;
var level_unlocked: LevelTypes.types = LevelTypes.types.FIRST;
