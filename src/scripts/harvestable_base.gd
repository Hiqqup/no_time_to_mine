class_name HarvestableBase
extends Node2D

@export var health: float;
@export var drop_scene: PackedScene;
var player_in_range: bool = false;


func get_destroyed():
	var mines = get_tree().get_first_node_in_group("current_mines");
	var drop = drop_scene.instantiate();
	drop.get_node("GridVectorToPositionConverter").set_grid_vector($GridVectorToPositionConverter.grid_vector)
	mines.get_node("YSorted/Drops").add_child(drop)
	queue_free();	


func mine_visual_feedback():
	#temporary
	var tween =  get_tree().create_tween();
	var start_scale = Vector2.ONE;
	var middle_scale = Vector2.ONE * 0.7;
	(tween.tween_property($Visuals, "scale", middle_scale,0.1)
		.from(start_scale).set_trans(Tween.TRANS_BACK));
	(tween.tween_property($Visuals, "scale", start_scale,0.3)
		.from(middle_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT));
	#temporary end


func _enter_tree() -> void:
	var upgrade_stats: PlayerUpgradeStats = get_tree().get_first_node_in_group("upgrade_stats")
	$MiningRange/MiningRangeShape.scale*= upgrade_stats.mining_range
	


func _on_click_detection_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_clicked_on();


func _handle_clicked_on():
	var player =  get_tree().get_first_node_in_group("controllable_player")
	if player_in_range :
		player.currently_mining = self;


func _on_mining_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range =true;


func _on_mining_range_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false;
