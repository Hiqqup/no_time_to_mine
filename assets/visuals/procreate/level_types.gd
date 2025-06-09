class_name LevelTypes
extends Resource
var i: Level;

@export var map: Dictionary[LevelTypes.types, Level];
@export var sprite_map: Dictionary[LevelTypes.types, Texture];
@export var tileset_map: Dictionary[LevelTypes.types, Texture];
@export var color_duo_map: Dictionary[LevelTypes.types, Array];#array has 2 color entries

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
		
		var color_1 =image_texure.get_image().get_pixel(41,3);
		var color_2 =image_texure.get_image().get_pixel(42,3);
		color_duo_map[key] = [Color.WHITE,Color.WHITE];
		color_duo_map[key][0] = color_1
		color_duo_map[key][1] = color_2;
