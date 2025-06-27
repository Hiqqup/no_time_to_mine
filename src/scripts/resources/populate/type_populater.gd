extends Node

@export_category("Items")
@export var items: ItemTypes

@export_category("Harvestables")
@export var harvestables: HarvestableTypes


@export_category("LevelTextures")
@export var levels: LevelTypes;
@export var first_level_tileset: Texture;
@export var second_level_tileset: Texture;
@export var third_level_tileset: Texture;

const item_stone_region := Rect2(204.0,14.0,16.0,14.0);
const item_ore_region := Rect2(236.0,15.0,15.0,12.0);
const harvestable_stone_region:= Rect2(132.0,11.0,31.0,20.0)
const harvestable_ore_region:=Rect2(165.0,12.0,31.0,19.0)

func _tileset_get_region(tileset: Texture, region:Rect2)->Texture:
	var atlas := AtlasTexture.new();
	atlas.atlas = tileset;
	atlas.region = region;
	return atlas;

func _setup_harvestable(harvestable: HarvestableTypes.types, sprite: Texture, health:float,drop_item : ItemTypes.types):
	pass
	harvestables.sprite_map[harvestable] = sprite;
	harvestables.health_map[harvestable] = health;
	harvestables.drop_tables[harvestable] = HarvestableTypes.DropTable.new();
	harvestables.drop_tables[harvestable].table = {
		drop_item: 1
	}

func _ready() -> void:
		# Items
	items.map[ItemTypes.types.RED_CAP_STONE] = _tileset_get_region(first_level_tileset,item_stone_region);
	items.map[ItemTypes.types.GOLD_ORE] = _tileset_get_region(first_level_tileset,item_ore_region);
	items.map[ItemTypes.types.YELLOW_CAP_STONE] = _tileset_get_region(second_level_tileset,item_stone_region);
	items.map[ItemTypes.types.PLATINUM_ORE] = _tileset_get_region(second_level_tileset,item_ore_region);
	items.map[ItemTypes.types.GREEN_CAP_STONE] = _tileset_get_region(third_level_tileset,item_stone_region);
	items.map[ItemTypes.types.SULPHUR_ORE] = _tileset_get_region(third_level_tileset,item_ore_region);
	
	# Harvestables
	_setup_harvestable(
		HarvestableTypes.types.RED_CAP_STONE,  
		_tileset_get_region(first_level_tileset,harvestable_stone_region),
		10.0,
		ItemTypes.types.RED_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.GOLD_ORE,  
		_tileset_get_region(first_level_tileset,harvestable_ore_region),
		50.0,
		ItemTypes.types.GOLD_ORE,
		);
	
	_setup_harvestable(
		HarvestableTypes.types.YELLOW_CAP_STONE,  
		_tileset_get_region(second_level_tileset,harvestable_stone_region),
		25.0,
		ItemTypes.types.YELLOW_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.PLATINUM_ORE,  
		_tileset_get_region(second_level_tileset,harvestable_ore_region),
		150.0,
		ItemTypes.types.PLATINUM_ORE,
		);
	
	_setup_harvestable(
		HarvestableTypes.types.GREEN_CAP_STONE,  
		_tileset_get_region(third_level_tileset,harvestable_stone_region),
		250.0,
		ItemTypes.types.GREEN_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.SULPHUR_ORE,  
		_tileset_get_region(third_level_tileset,harvestable_ore_region),
		400.0,
		ItemTypes.types.SULPHUR_ORE,
		);
	
	
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
		HarvestableTypes.types.YELLOW_CAP_STONE: 4,
		HarvestableTypes.types.PLATINUM_ORE: 1,
	}
	levels.map[LevelTypes.types.SECOND] = l;
	
	# THIRD
	
	l = Level.new()
	l.platform_radius = 5
	l. harvestables = {
		HarvestableTypes.types.GREEN_CAP_STONE: 4,
		HarvestableTypes.types.SULPHUR_ORE: 1,
	}
	levels.map[LevelTypes.types.THIRD] = l;
