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
	FOURTH,
	FIFTH,
	SIXTH,
}

static func is_higher( higher, than):
	return higher > than ;


func increase_size(level_type: LevelTypes.types):
	var level: Level = map[level_type];
	level.platform_radius += 1;
	var givable = level.platform_radius * 4;
	var sum = 0;
	for key in level.harvestables.keys():
		sum += level.harvestables[key];
	for key in level.harvestables.keys():
		level.harvestables[key] += int (float(level.harvestables[key])/ float(sum)
		 * givable  * 0.5)
	
	map[level_type] = level;
	


func setup():
	for key in tileset_map.keys():
		var atlas := AtlasTexture.new();
		atlas.atlas = tileset_map[key];
		atlas.region = Rect2(66,33,32,32);
		sprite_map[key] = atlas;
		
		
		var image_texure:=ImageTexture.create_from_image(
			 (tileset_map[key] as CompressedTexture2D).get_image());
		
		var color_0 =image_texure.get_image().get_pixel(41,3); #yellow
		var color_1 =image_texure.get_image().get_pixel(42,3); #redcap
		var color_2 =image_texure.get_image().get_pixel(33,9); #brown
		var color_3 =image_texure.get_image().get_pixel(40,4); #beige
		color_map[key] = [];
		color_map[key].push_back(color_0)# color 0: for background
		color_map[key].push_back(color_1)# color 1: for background
		color_map[key].push_back(color_2)# color 2: walking particle modulate
		color_map[key].push_back(color_3)# color 3: upgrade frame
