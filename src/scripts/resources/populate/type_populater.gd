extends Node

@export_category("Items")
@export var items: ItemTypes
@export var orange_drop: Texture;
@export var black_drop: Texture;

@export_category("Harvestables")
@export var harvestables: HarvestableTypes
@export var orange_harvestable: PackedScene
@export var black_harvestable: PackedScene

@export_category("Levels")
@export var levels: LevelTypes;



func _ready() -> void:
		# Items
	items.map[ItemTypes.types.RED_CAP_STONE] = orange_drop;
	
	#print(items.map)
	items.map[ItemTypes.types.GOLD_ORE] = black_drop;
	
	# Harvestables
	harvestables.map[HarvestableTypes.types.RED_CAP_STONE] = orange_harvestable;
	harvestables.map[HarvestableTypes.types.GOLD_ORE] = black_harvestable;
	
	
	# DropTables

	harvestables.drop_tables[HarvestableTypes.types.RED_CAP_STONE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.RED_CAP_STONE].table = {
		ItemTypes.types.RED_CAP_STONE: 1
	}
	
	harvestables.drop_tables[HarvestableTypes.types.GOLD_ORE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.GOLD_ORE].table = {
		ItemTypes.types.GOLD_ORE: 1
	}
	
	# Levels
	var l : Level
	
	# FIRST
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 4,
		HarvestableTypes.types.GOLD_ORE: 1,
	}
	levels.map[Level.levels.FIRST] = l;
	
	# TUTORIAL
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 8,
		HarvestableTypes.types.GOLD_ORE: 0,
	}
	levels.map[Level.levels.TUTORIAL] = l;
	
	# SECOND
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 1,
		HarvestableTypes.types.GOLD_ORE: 5,
	}
	levels.map[Level.levels.SECOND] = l;
	
	
