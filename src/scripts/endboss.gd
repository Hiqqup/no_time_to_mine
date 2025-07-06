extends Node2D
class_name  EndbossScene
@onready var endboss_harvestable: HarvestableBase = $EndbossHarvestable
@onready var invisible_player: Player = $InvisiblePlayer


var _mines: Mines
@export var _level_types: LevelTypes
func _enter_tree() -> void:
	_mines = get_parent()
	_mines.player.position.y = (
		(_level_types.map[LevelTypes.types.BOSS].platform_radius -2) * -16)

func _ready():
	
	$Placeholder.queue_free();

	invisible_player.visible = true;
	invisible_player._visuals.visible = false;
	invisible_player.get_node("CameraIndependet").visible = false;
	invisible_player.position.y = 2000;
	invisible_player.do_lifetime_calculation = false;
	invisible_player.get_node("Targeting").visible = false;
	invisible_player.modulate = _mines.player._particles.modulate
	
	endboss_harvestable.reparent(_mines.harvestable_layer);
	_mines.get_node("YSorted/CollectorSpawner").queue_free()
