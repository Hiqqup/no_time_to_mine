extends Node

@export_category("Items")
@export var items: ItemTypes
@export var red_cap_stone_drop: Texture;
@export var gold_ore_drop: Texture;
@export var green_cap_stone_drop: Texture;
@export var silver_ore_drop: Texture;

@export_category("Harvestables")
@export var harvestables: HarvestableTypes
@export var red_cap_stone_sprite: Texture
@export var gold_ore_sprite: Texture
@export var green_cap_stone_sprite: Texture
@export var silver_ore_sprite: Texture

@export_category("LevelTextures")
@export var levels: LevelTypes;
@export var first_level_tileset: Texture;
@export var second_level_tileset: Texture;
@export var third_level_tileset: Texture;


func _ready() -> void:
		# Items
	items.map[ItemTypes.types.RED_CAP_STONE] = red_cap_stone_drop;
	items.map[ItemTypes.types.GOLD_ORE] = gold_ore_drop;
	items.map[ItemTypes.types.GREEN_CAP_STONE] = green_cap_stone_drop;
	items.map[ItemTypes.types.SILVER_ORE] = silver_ore_drop;
	
	# Harvestables
	harvestables.sprite_map[HarvestableTypes.types.RED_CAP_STONE] = red_cap_stone_sprite;
	harvestables.health_map[HarvestableTypes.types.RED_CAP_STONE] = 10.0;
	harvestables.sprite_map[HarvestableTypes.types.GOLD_ORE] = gold_ore_sprite;
	harvestables.health_map[HarvestableTypes.types.GOLD_ORE] = 100.0;
	
	harvestables.sprite_map[HarvestableTypes.types.GREEN_CAP_STONE] = green_cap_stone_sprite;
	harvestables.health_map[HarvestableTypes.types.GREEN_CAP_STONE] = 50.0;
	harvestables.sprite_map[HarvestableTypes.types.SILVER_ORE] = silver_ore_sprite;
	harvestables.health_map[HarvestableTypes.types.SILVER_ORE] = 140.0;
	# DropTables

	harvestables.drop_tables[HarvestableTypes.types.RED_CAP_STONE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.RED_CAP_STONE].table = {
		ItemTypes.types.RED_CAP_STONE: 1
	}
	
	harvestables.drop_tables[HarvestableTypes.types.GOLD_ORE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.GOLD_ORE].table = {
		ItemTypes.types.GOLD_ORE: 1
	}
	
	
	harvestables.drop_tables[HarvestableTypes.types.GREEN_CAP_STONE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.GREEN_CAP_STONE].table = {
		ItemTypes.types.GREEN_CAP_STONE: 1
	}
	
	harvestables.drop_tables[HarvestableTypes.types.SILVER_ORE] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[HarvestableTypes.types.SILVER_ORE].table = {
		ItemTypes.types.SILVER_ORE: 1
	}
	
	# Level Sprites
	levels.tileset_map[LevelTypes.types.TUTORIAL] = first_level_tileset;
	levels.tileset_map[LevelTypes.types.FIRST] = first_level_tileset;
	levels.tileset_map[LevelTypes.types.SECOND] = second_level_tileset;
	levels.tileset_map[LevelTypes.types.THIRD] = third_level_tileset;
	
	levels.setup();
	# Levels
	var l : Level
	
	# TUTORIAL
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 8,
	}
	levels.map[LevelTypes.types.TUTORIAL] = l;
	
	# FIRST
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.RED_CAP_STONE: 4,
		HarvestableTypes.types.GOLD_ORE: 1,
	}
	levels.map[LevelTypes.types.FIRST] = l;
	

	
	# SECOND
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.GREEN_CAP_STONE: 4,
		HarvestableTypes.types.SILVER_ORE: 1,
	}
	levels.map[LevelTypes.types.SECOND] = l;
	
	
