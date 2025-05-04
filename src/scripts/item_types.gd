class_name ItemTypes
extends Node

@export var item_sprites: Dictionary[types, Sprite2D];
enum types{
	BASE_DROP,
	ORANGE_DROP,
	BLACK_DROP,
}

func get_copy(type : types) ->Sprite2D:
	var sprite = item_sprites[type].duplicate();
	sprite.visible = true;
	return sprite;

func get_copy_texture_rect(type : types) ->TextureRect:
	var copy_from: Sprite2D = item_sprites[type];
	var base: TextureRect =  $TextureRect.duplicate();
	var atlas_texture := AtlasTexture.new();
	atlas_texture.region = copy_from.region_rect;
	atlas_texture.atlas =  copy_from.texture;
	base.texture = atlas_texture; 
	return base;
