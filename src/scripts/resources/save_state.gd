extends Resource
class_name SaveState;

@export var forge_storage: Dictionary[ItemTypes.types, int];
@export var upgrades_purchased: Dictionary[UpgradeTypes.types, int];
@export var tutorial_completed: bool = false;
