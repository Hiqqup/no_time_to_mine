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
@export var first_level: Texture;
@export var second_level: Texture;
@export var third_level: Texture;



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
	
	# Level Sprites
	
	levels.sprite_map[LevelTypes.types.FIRST] = first_level;
	levels.sprite_map[LevelTypes.types.SECOND] = second_level;
	levels.sprite_map[LevelTypes.types.THIRD] = third_level;
	
	# Levels
	var l : Level
	
	# FIRST
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 4,
		HarvestableTypes.types.GOLD_ORE: 1,
	}
	levels.map[LevelTypes.types.FIRST] = l;
	
	# TUTORIAL
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 8,
		HarvestableTypes.types.GOLD_ORE: 0,
	}
	levels.map[LevelTypes.types.TUTORIAL] = l;
	
	# SECOND
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 1,
		HarvestableTypes.types.GOLD_ORE: 5,
	}
	levels.map[LevelTypes.types.SECOND] = l;
	
	
