class_name MineFloor
extends TileMapLayer

const _INVISIBLE_COLLIDER_ATLAS_COORIDNATES := Vector2i(7,0);
const _INVISIBLE_NAVIGATION_ATLAS_COORDINATES:= Vector2i(0,1);
const _WHITE_FLOOR_ATLAS_COORIDNATES:= Vector2i(3,0);
const _ISO_TILESET_SOURCE = 0;
var _STONE_FLOOR_SOURCE = 1;
@export var _level_types: LevelTypes;
@onready var _navigation: TileMapLayer = $Navigation


var platform_radius: int;
var used: Dictionary[Vector2i, bool]
var _forge: Forge;

const offsets = [
	Vector2i(1,1),
	Vector2i(-1,1),
	Vector2i(1,-1),
	Vector2i(-1,-1),
];

func _ready() -> void:
	_forge =get_tree().get_first_node_in_group("forge");



func setup(radius: int):
	tile_set.get_source(1).texture = _level_types.tileset_map[_forge.selected_level];
	

	platform_radius = radius
	for i in radius:
		for j in radius:
			for offset in offsets:
				var atlas_cords = Vector2i.ZERO;
				if randf() < 0.1:
					atlas_cords = [Vector2i(2,0) ,Vector2i(3,0)].pick_random()
					pass
				if j == radius-1 :
					atlas_cords = Vector2i(1,0)
				set_cell(Vector2i(i,j) * offset, _STONE_FLOOR_SOURCE, atlas_cords)
				used[Vector2i(i,j) * offset] = false
	used[Vector2i.ZERO ] =true; # the player is there
	_place_boundries();


func get_random_free_spot():
	var random_pos = used.keys()[randi_range(0, used.size()-1)]
	if used[random_pos] :
		return get_random_free_spot();
	return random_pos;


func _place_boundries()->void:
	var _used = get_used_cells();
	for spot in _used:
		for offset in offsets:
			var current_spot = spot+offset;
			if get_cell_source_id(current_spot) == -1:
				set_cell(current_spot,_ISO_TILESET_SOURCE,_INVISIBLE_COLLIDER_ATLAS_COORIDNATES);
				

func set_navigation_cell(pos):
	_navigation.set_cell(pos,_ISO_TILESET_SOURCE,_INVISIBLE_NAVIGATION_ATLAS_COORDINATES);

func generate_navigation_layer():
	set_navigation_cell(Vector2.ZERO);
	for i in platform_radius:
		for j in platform_radius:
			for offset in offsets:
				var pos = Vector2i(i,j) * offset;
				if not used[pos]:
					set_navigation_cell(pos)
			
		
