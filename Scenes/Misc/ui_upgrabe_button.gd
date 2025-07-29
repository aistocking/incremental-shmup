extends Sprite2D

@export var unlock_limit: int
@export var upgrade_name: String
@export var upgrade_category: String
@export var upgrade_global_pointer: int
@export var cost: int
@export var title: String
@export var description: String

func upgrade_stat(upgrade_global_pointer) -> void:
	if Globals.current_exp >= cost:
		pass
