class_name HarvestableBase
extends Node2D


func setup(grid_vector: Vector2i,texture: Texture2D, colision_points: PackedVector2Array,  click_detection_points: PackedVector2Array):
	$GridVectorToPositionConverter.set_grid_vector(grid_vector);
	$Sprite2D.texture = texture;
	$PlayerCollider/CollisionPolygon2D.polygon = colision_points;
	$ClickDetection/CollisionPolygon2D.polygon = click_detection_points;


func _on_click_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
