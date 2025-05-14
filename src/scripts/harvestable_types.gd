class_name  HarvestableTypes
extends Resource

@export var map: Dictionary[types, PackedScene]
@export var drop_tables: Dictionary[types, DropTable];

class DropTable extends Resource:
	@export var table: Dictionary[ItemTypes.types, float];


enum types{
	ORANGE,
	BLACK,
}

func get_copy(type : types) ->HarvestableBase:
	var base = map[type].instantiate();
	base.drop_table = drop_tables[type].table;
	return base;
