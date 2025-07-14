class_name ItemTypes
extends Resource

@export var map: Dictionary[types, Texture2D];
@export var outlined_map :  Dictionary[types, Texture2D];


enum types{
	RED_CAP_STONE,
	GOLD_ORE,
	
	YELLOW_CAP_STONE,
	PLATINUM_ORE,
	
	GREEN_CAP_STONE,
	SULPHUR_ORE,
	
	MAGENTA_CAP_STONE,
	MALACHITE_ORE,
	
	CYAN_CAP_STONE,
	AMETHYST_ORE,
	
	PURPLE_CAP_STONE,
	RUBY_ORE,
}



func get_copy_texture_rect(type: ItemTypes.types, outlined:bool = false) -> TextureRect:
	var rect := TextureRect.new();
	if not outlined:
		rect.texture = map[type];
	else:
		rect.texture = outlined_map[type];
	
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL;
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	#rect.modulate = Color(Color.WHITE , 0.4)
	
	return rect;
