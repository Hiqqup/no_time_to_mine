extends Node2D

@export var item_type: ItemTypes.types;
@export var amount: float;
@export var drop_table: Dictionary;

func _enter_tree() -> void:
	var player = get_tree().get_first_node_in_group("controllable_player") as Player
	$CollectionRange/CollectionRangeShape.scale*= player.upgrade_stats.mining_range


func _on_collection_range_body_entered(body: Node2D) -> void:
	if body is Player:
		body.get_node("Storage").contents[item_type] += 1;
		queue_free()
		
