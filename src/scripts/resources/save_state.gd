extends Resource
class_name SaveState


var purchased_upgrades: Dictionary[UpgradeTypes.types, int]
var storage: Dictionary[ItemTypes.types, int]

func _init() -> void:
	for i in UpgradeTypes.types.size():
		purchased_upgrades[i] = 0;
