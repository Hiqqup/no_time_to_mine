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
}

func get_copy(type : types) ->HarvestableBase:
	var base:HarvestableBase = harvestable_base_scene.instantiate();
	base.drop_table = drop_tables[type].table;
	base.sprite = sprite_map[type];
	base.health = health_map[type];
	return base;
