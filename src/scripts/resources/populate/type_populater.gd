extends Node
@export var tmp: Texture;

@export_category("Items")
@export var items: ItemTypes

@export_category("Harvestables")
@export var harvestables: HarvestableTypes


@export_category("LevelTextures")
@export var levels: LevelTypes;
@export var first_level_tileset: Texture;
@export var second_level_tileset: Texture;
@export var third_level_tileset: Texture;
@export var fourth_level_tileset: Texture;
@export var fifth_level_tileset: Texture;
@export var sixth_level_tileset: Texture;

const outlined_item_stone_region := Rect2(265.0,13.0,18.0,16.0);
const outlined_item_ore_region := Rect2(297.0,14.0,17.0,14.0);
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

func _map_item(item_type: ItemTypes.types, level_tileset: Texture):
	var str_sp = (ItemTypes.types.keys()[item_type] as String).split("_")
	var region: Rect2
	var outlined_region: Rect2
	if str_sp[str_sp.size() - 1] == "STONE":
		region = item_stone_region
		outlined_region = outlined_item_stone_region
	elif  str_sp[str_sp.size() - 1] == "ORE":
		region = item_ore_region;
		outlined_region = outlined_item_ore_region
	items.map[item_type] = _tileset_get_region(level_tileset,region);
	items.outlined_map[item_type] = _tileset_get_region(level_tileset,outlined_region);
	
func _classic_level(level: LevelTypes.types, stone:HarvestableTypes.types, ore: HarvestableTypes.types ):
	var l := Level.new()
	l.platform_radius = 5
	l. harvestables = {
		stone: 4,
		ore: 1,
	}
	levels.map[level] = l;


func _ready() -> void:
		# Items
	_map_item(ItemTypes.types.RED_CAP_STONE, first_level_tileset);
	_map_item(ItemTypes.types.GOLD_ORE, first_level_tileset);
	_map_item(ItemTypes.types.YELLOW_CAP_STONE, second_level_tileset);
	_map_item(ItemTypes.types.PLATINUM_ORE, second_level_tileset);
	_map_item(ItemTypes.types.GREEN_CAP_STONE, third_level_tileset);
	_map_item(ItemTypes.types.SULPHUR_ORE, third_level_tileset);
	_map_item(ItemTypes.types.MAGENTA_CAP_STONE, fourth_level_tileset);
	_map_item(ItemTypes.types.MALACHITE_ORE, fourth_level_tileset);
	_map_item(ItemTypes.types.CYAN_CAP_STONE, fifth_level_tileset);
	_map_item(ItemTypes.types.AMETHYST_ORE, fifth_level_tileset);
	_map_item(ItemTypes.types.PURPLE_CAP_STONE, sixth_level_tileset);
	_map_item(ItemTypes.types.RUBY_ORE, sixth_level_tileset);
	
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
			36.0,
		ItemTypes.types.YELLOW_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.PLATINUM_ORE,  
		_tileset_get_region(second_level_tileset,harvestable_ore_region),
		180.0,
		ItemTypes.types.PLATINUM_ORE,
		);
	
	_setup_harvestable(
		HarvestableTypes.types.GREEN_CAP_STONE,  
		_tileset_get_region(third_level_tileset,harvestable_stone_region),
		120.0,
		ItemTypes.types.GREEN_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.SULPHUR_ORE,  
		_tileset_get_region(third_level_tileset,harvestable_ore_region),
		600.0,
		ItemTypes.types.SULPHUR_ORE,
		);
	
	_setup_harvestable(
		HarvestableTypes.types.MAGENTA_CAP_STONE,  
		_tileset_get_region(fourth_level_tileset,harvestable_stone_region),
		340,
		ItemTypes.types.MAGENTA_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.MALACHITE_ORE,  
		_tileset_get_region(fourth_level_tileset,harvestable_ore_region),
		1700,
		ItemTypes.types.MALACHITE_ORE,
		);
	
	_setup_harvestable(
		HarvestableTypes.types.CYAN_CAP_STONE,  
		_tileset_get_region(fifth_level_tileset,harvestable_stone_region),
		500,
		ItemTypes.types.CYAN_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.AMETHYST_ORE,  
		_tileset_get_region(fifth_level_tileset,harvestable_ore_region),
		3000,
		ItemTypes.types.AMETHYST_ORE,
		);
		
	_setup_harvestable(
		HarvestableTypes.types.PURPLE_CAP_STONE,  
		_tileset_get_region(sixth_level_tileset,harvestable_stone_region),
		1000,
		ItemTypes.types.PURPLE_CAP_STONE,
		);
	_setup_harvestable(
		HarvestableTypes.types.RUBY_ORE,  
		_tileset_get_region(sixth_level_tileset,harvestable_ore_region),
		5000,
		ItemTypes.types.RUBY_ORE,
		);
	
	
	# Level Sprites
	levels.tileset_map[LevelTypes.types.TUTORIAL] = first_level_tileset;
	levels.tileset_map[LevelTypes.types.FIRST] = first_level_tileset;
	levels.tileset_map[LevelTypes.types.SECOND] = second_level_tileset;
	levels.tileset_map[LevelTypes.types.THIRD] = third_level_tileset;
	levels.tileset_map[LevelTypes.types.FOURTH] = fourth_level_tileset;
	levels.tileset_map[LevelTypes.types.FIFTH] = fifth_level_tileset;
	levels.tileset_map[LevelTypes.types.SIXTH] = sixth_level_tileset;
	levels.tileset_map[LevelTypes.types.BOSS] = first_level_tileset;
	
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
	
	_classic_level(LevelTypes.types.FIRST, HarvestableTypes.types.RED_CAP_STONE, HarvestableTypes.types.GOLD_ORE);
	_classic_level(LevelTypes.types.SECOND, HarvestableTypes.types.YELLOW_CAP_STONE, HarvestableTypes.types.PLATINUM_ORE);
	_classic_level(LevelTypes.types.THIRD, HarvestableTypes.types.GREEN_CAP_STONE, HarvestableTypes.types.SULPHUR_ORE);
	_classic_level(LevelTypes.types.FOURTH, HarvestableTypes.types.MAGENTA_CAP_STONE, HarvestableTypes.types.MALACHITE_ORE);
	_classic_level(LevelTypes.types.FIFTH, HarvestableTypes.types.CYAN_CAP_STONE, HarvestableTypes.types.AMETHYST_ORE);
	_classic_level(LevelTypes.types.SIXTH, HarvestableTypes.types.PURPLE_CAP_STONE, HarvestableTypes.types.RUBY_ORE);
	
	
	
	l = Level.new()
	l.platform_radius = 6
	l. harvestables = {}
	levels.map[LevelTypes.types.BOSS] = l;
