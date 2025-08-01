extends Sprite2D

@onready var _button: TextureButton = $ActualButton


@export var upgrade_type: String
@export var upgrade_category: String
var unlock_limit: int
var cost = Array([], TYPE_INT, "", null)
var title: String
var description: String
var current_level: int

signal upgrade_success_state(b: bool)

func _ready():
	if upgrade_type == null or upgrade_category == null:
		push_error("Upgrade type and category must be filled")
	if upgrade_type == "Unlock":
		_button.texture_normal = load("res://Art/UI/Upgrade_Base_Major_Active.png")
		_button.texture_disabled = load("res://Art/UI/Upgrade_Base_Major_Inactive.png")
		_button.pivot_offset = Vector2(23, 23)
		_button.position = Vector2(-23, -23)
	set_stats_from_csv()
	grab_or_update_global_data(false)
	if current_level > 0:
		_button.disabled = false


func upgrade_stat() -> void:
	if current_level < unlock_limit and Globals.current_exp >= cost[current_level]:
		Globals.remove_exp(cost[current_level])
		current_level += 1
		grab_or_update_global_data(true)
		emit_signal("upgrade_success_state", true)
	else:
		emit_signal("upgrade_success_state", false)

func unlock_upgrade() -> bool:
	if current_level == 0 and Globals.current_exp >= cost[0]:
		_button.disabled = false
		upgrade_stat()
		return true
	else:
		return false

func grab_or_update_global_data(update: bool) -> void:
	match upgrade_category:
		"Vulkan":
			if update:
				Globals.vulkan_dict[upgrade_type] = current_level
			else:
				current_level = Globals.vulkan_dict[upgrade_type]
		"Missiles":
			if update:
				Globals.missile_dict[upgrade_type] = current_level
			else:
				current_level = Globals.missile_dict[upgrade_type]
		"Plasma":
			if update:
				Globals.plasma_dict[upgrade_type] = current_level
			else:
				current_level = Globals.plasma_dict[upgrade_type]
		"Option":
			if update:
				Globals.option_dict[upgrade_type] = current_level
			else:
				current_level = Globals.option_dict[upgrade_type]
		"System":
			if update:
				Globals.system_dict[upgrade_type] = current_level
			else:
				current_level = Globals.system_dict[upgrade_type]

func set_stats_from_csv():
	var found_category: bool = false
	var found_type: bool = false
	var data = []
	var file = FileAccess.open("res://Data/upgrade_table.csv", FileAccess.READ)
	var line_data
	while not found_category and not file.eof_reached():
		line_data = file.get_csv_line(",") # Use "," as delimiter for CSV
		if line_data.size() > 0 and line_data[0] != "": # Avoid empty lines
			if line_data[0] == upgrade_category:
				found_category = true
				break
			else:
				pass
	if not found_category:
		print("error, could not find upgrade category name")
	while not found_type and not file.eof_reached():
		line_data = file.get_csv_line(",") # Use "," as delimiter for CSV
		if line_data.size() > 0 and line_data[1] != "": # Avoid empty lines
			if line_data[1] == upgrade_type:
				found_type = true
				break
			else:
				pass
	if not found_type:
		print("error, could not find upgrade type name")
	while not file.eof_reached():
		line_data = file.get_csv_line(",") # Use "," as delimiter for CSV
		if line_data.size() > 0 and line_data[2] != "": # Avoid empty lines
			if line_data[2] == "UnlockLimit":
				unlock_limit  = int(line_data[3])
			if line_data[2] == "Cost":
				for i in line_data.size():
					if i <= 2:
						pass
					else:
						cost.append(int(line_data[i]))
			if line_data[2] == "Title":
				title = line_data[3]
			if line_data[2] == "Description":
				description = line_data[3]
				break
	file.close()


func _on_actual_button_focus_entered():
	get_tree().current_scene.set_ui_elements(self)

func _on_actual_button_pressed():
	upgrade_stat()
