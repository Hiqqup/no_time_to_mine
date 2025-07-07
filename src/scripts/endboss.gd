extends Node2D
class_name  EndbossScene
@onready var endboss_harvestable: EndbossHarvestable = $EndbossHarvestable
@onready var invisible_player: Player = $InvisiblePlayer
@onready var _paths: Node2D = $Paths

signal spirits_out;
var _mines: Mines
@export var _level_types: LevelTypes

func _enter_tree() -> void:
	
	_mines = get_parent()
	

func _ready():
	_mines.player.position.y = (
		(_level_types.map[LevelTypes.types.BOSS].platform_radius -2) * -16)
	
	$Placeholder.queue_free();

	invisible_player.visible = true;
	invisible_player._visuals.visible = false;
	invisible_player.get_node("CameraIndependet").visible = false;
	invisible_player.position.y = 2000;
	invisible_player.do_lifetime_calculation = false;
	invisible_player.get_node("Targeting").visible = false;
	invisible_player.modulate = _mines.player._particles.modulate
	#_paths.modulate = invisible_player.modulate
	
	_paths.global_position = endboss_harvestable.global_position;
	endboss_harvestable.reparent(_mines.harvestable_layer);
	_mines.get_node("YSorted/CollectorSpawner").queue_free()

func animate_spirits():
	for i in _paths.get_children().size():
		var path_follow: PathFollow2D = _paths.get_children()[i].get_node("PathFollow2D");
		var particle: CPUParticles2D = path_follow.get_node("SpiritParticles")
		TimeoutCallback.timeout_callback(1 + i*5, func():
			endboss_harvestable._animation_player.play("destroyed_no_sprite_gone")
			particle.emitting = true;
			create_tween().tween_property(path_follow, "progress", 450, 10);
				
			)
	TimeoutCallback.timeout_callback(5 + 2 * 5, func():
		spirits_out.emit()
		)
		
