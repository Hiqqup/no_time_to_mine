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
	items.map[ItemTypes.types.ORANGE_DROP] = orange_drop;
	items.map[ItemTypes.types.BLACK_DROP] = black_drop;
	
	# Harvestables
	harvestables.map[HarvestableTypes.types.ORANGE] = orange_harvestable;
	harvestables.map[HarvestableTypes.types.BLACK] = black_harvestable;
	
	
	var l : Level
	
	# FIRST
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.ORANGE: 4,
		HarvestableTypes.types.BLACK: 1,
	}
	levels.map[Level.levels.FIRST] = l;
	
	# TUTORIAL
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.ORANGE: 8,
		HarvestableTypes.types.BLACK: 0,
	}
	levels.map[Level.levels.TUTORIAL] = l;
	
	# SECOND
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.ORANGE: 1,
		HarvestableTypes.types.BLACK: 5,
	}
	levels.map[Level.levels.SECOND] = l;
	
	
