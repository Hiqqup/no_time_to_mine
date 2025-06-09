class_name LevelTypes
extends Resource
var i: Level;

@export var map: Dictionary[LevelTypes.types, Level];
@export var sprite_map: Dictionary[LevelTypes.types, Texture];
@export var tileset_map: Dictionary[LevelTypes.types, Texture];
@export var color_map: Dictionary[LevelTypes.types, Array];


enum types{
	TUTORIAL,
	FIRST,
	SECOND,
	THIRD,
}

func setup():
	for key in tileset_map.keys():
		var atlas := AtlasTexture.new();
		atlas.atlas = tileset_map[key];
		atlas.region = Rect2(66,33,32,32);
		sprite_map[key] = atlas;
		
		
		var image_texure:=ImageTexture.create_from_image(
			 (tileset_map[key] as CompressedTexture2D).get_image());
		
		var color_0 =image_texure.get_image().get_pixel(41,3);
		var color_1 =image_texure.get_image().get_pixel(42,3);
		var color_2 =image_texure.get_image().get_pixel(33,9);
		color_map[key] = [];
		color_map[key].push_back(color_0)# color 0: for background
		color_map[key].push_back(color_1)# color 1: for background
		color_map[key].push_back(color_2)# color 2: walking particle modulate
