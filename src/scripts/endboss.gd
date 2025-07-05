extends Node2D
class_name  EndbossScene
@onready var endboss_harvestable: HarvestableBase = $EndbossHarvestable

var _mines: Mines
@export var _level_types: LevelTypes
func _enter_tree() -> void:
	_mines = get_parent()
	_mines.player.position.y = (
		(_level_types.map[LevelTypes.types.BOSS].platform_radius -2) * -16)

func _ready():
	
	$Placeholder.queue_free();
	endboss_harvestable.reparent(_mines.harvestable_layer);
	_mines.get_node("YSorted/CollectorSpawner").queue_free()
