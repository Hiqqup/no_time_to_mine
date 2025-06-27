class_name  HarvestableTypes
extends Resource

@export var sprite_map: Dictionary[types, Texture];
@export var health_map: Dictionary[types, float];
@export var drop_tables: Dictionary[types, DropTable];
@export var harvestable_base_scene: PackedScene;

class DropTable extends Resource:
	@export var table: Dictionary[ItemTypes.types, float];


enum types{
	RED_CAP_STONE,
	GOLD_ORE,
	
	YELLOW_CAP_STONE,
	PLATINUM_ORE,
	
	GREEN_CAP_STONE,
	SULPHUR_ORE,
	
	CYAN_CAP_STONE,
	EMERALD_ORE,
	
	BLUE_CAP_STONE,
	AQUAMARINE_ORE,
	
	MAGENTA_CAP_STONE,
	MALACHITE_ORE,
}

func get_copy(type : types) ->HarvestableBase:
	var base:HarvestableBase = harvestable_base_scene.instantiate();
	base.drop_table = drop_tables[type].table;
	base.sprite = sprite_map[type];
	base.health = health_map[type];
	return base;
