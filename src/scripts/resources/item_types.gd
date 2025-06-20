class_name ItemTypes
extends Resource

@export var map: Dictionary[types, Texture2D];


enum types{
	RED_CAP_STONE,
	GOLD_ORE,
	
	GREEN_CAP_STONE,
	SILVER_ORE,
	
	PURPLE_CAP_STONE,
	PRISMARINE_ORE,
}



func get_copy_texture_rect(type: ItemTypes.types) -> TextureRect:
	var rect := TextureRect.new();
	rect.texture = map[type];
	
	
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL;
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	#rect.modulate = Color(Color.WHITE , 0.4)
	
	return rect;
