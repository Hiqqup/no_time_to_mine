class_name  ItemDropBase
extends Node2D

@export var upgrade_stats: PlayerUpgradeStats;

var item_drops :Dictionary[ItemTypes.types, int];

var _time_counter: float = 0.0;
var targeted_by :Collector= null;

func _ready() -> void:
	$Visuals/AnimationPreview.queue_free();
	$GuiItemListDisplayer.generate_or_update_mod_label(
		$Visuals/GreenToBlueWrapper/VBoxContainer,item_drops);
func _enter_tree() -> void:
	$CollectionRange/CollectionRangeShape.scale*= upgrade_stats.mining_range

func _process(delta: float) -> void:
	_time_counter += delta;
	$Visuals.position.y = sin(_time_counter*4) * 2.0;

func _collect_item(player: Player):
	var player_storage = player.get_node("Storage").contents;
	for type in item_drops.keys():
		player_storage[type] += item_drops[type]
	$AnimationPlayer.play("collect")
	if targeted_by:
		targeted_by.spawner._set_unbusy_colletor(targeted_by);
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_collection_range_body_entered(body: Node2D) -> void:
	if body is Player:
		var mines:Mines = get_tree().get_first_node_in_group("current_mines");
		mines.collector_spawner._untargeted_item.erase(self);
		_collect_item(body)
	if body is Collector:
		_collect_item(body.player);
		
		
