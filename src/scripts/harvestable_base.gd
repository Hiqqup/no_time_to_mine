class_name HarvestableBase
extends Node2D

signal harvested;

@export var health: float;
@export var drop_table: Dictionary[ItemTypes.types, float];

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _drop_base_scene: PackedScene;

var player_in_range: bool = false;
var mines;


func get_destroyed():
	_spawn_drop(_drop_table_float_to_int(drop_table));
	harvested.emit();
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


func _drop_table_float_to_int(dt: Dictionary[ItemTypes.types, float]):
	var item_drops : Dictionary[ItemTypes.types, int];
	for type in dt.keys():
		var i = dt[type];
		item_drops[type] = int(floor(i));
		if randf() <= (i - floor(i)):
			item_drops[type] += 1;
	return item_drops;


func _spawn_drop(item_drops: Dictionary[ItemTypes.types, int]):
	var drop: ItemDropBase= _drop_base_scene.instantiate();
	drop.item_drops = item_drops;
	drop.get_node("GridVectorToPositionConverter").set_grid_vector($GridVectorToPositionConverter.grid_vector)
	mines.get_node("YSorted/Drops").add_child(drop)


func _handle_clicked_on():
	var player: Player =  get_tree().get_first_node_in_group("current_mines").player;
	if player_in_range :
		player.currently_mining = self;


func _ready() -> void:
	mines = get_tree().get_first_node_in_group("current_mines");
	
	# setup a colison body with the same shape as click detection for player
	# targeting ray to collide with
	var player_targeting_colision_body := StaticBody2D.new();
	player_targeting_colision_body.collision_layer = 2; # targeting colision layer
	player_targeting_colision_body.add_child($ClickDetection/ClickDetectionShape.duplicate());
	add_child(player_targeting_colision_body)



func _enter_tree() -> void:
	$MiningRange/MiningRangeShape.scale*= _upgrade_stats.mining_range


func _on_click_detection_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_clicked_on();



func _on_mining_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range =true;


func _on_mining_range_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false;
