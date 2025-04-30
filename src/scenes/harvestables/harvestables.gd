extends TileMapLayer

@export var _harvestable_base_scene: PackedScene;

func _ready() -> void:
	var used = get_used_cells();
	for spot in used:
		var texture: Texture2D = _get_cell_texture(spot);
		var colision_points: PackedVector2Array = get_cell_tile_data(spot).get_collision_polygon_points(0,0);
		var click_detection_points: PackedVector2Array = get_cell_tile_data(spot).get_collision_polygon_points(1,0);
		var h : HarvestableBase = _harvestable_base_scene.instantiate();
		
		h.setup(spot, texture, colision_points, click_detection_points);
		add_child(h);
		erase_cell(spot);
		


func _get_cell_colison_shape(coord: Vector2i) :#-> CollisionPolygon2D:
	var ret = CollisionPolygon2D.new();
	ret.polygon = get_cell_tile_data(coord).get_collision_polygon_points(0,0)
	return ret


func _get_cell_texture(coord:Vector2i) -> Texture:
	var source_id := get_cell_source_id(coord)
	var source:TileSetAtlasSource = tile_set.get_source(source_id) as TileSetAtlasSource
	var altas_coord := get_cell_atlas_coords(coord)
	var rect := source.get_tile_texture_region(altas_coord)
	var image:Image = source.texture.get_image()
	var tile_image := image.get_region(rect)
	return ImageTexture.create_from_image(tile_image)
