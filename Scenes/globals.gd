extends Node

signal exp_changed

"""
System Variables
"""
var master_volume: int = 80
var sfx_volume: float = -12.0 * (master_volume / 100)
var music_volume: float = -8.0 * (master_volume / 100)
enum SCENES {MAIN_MENU, OPTIONS, GAME, UPGRADE, CUTSCENE, CREDITS}
enum CUTSCENES {EYE, NO_CONTROL, CRACK, ABORT, FINALE}

"""
Misc Variables
"""
var current_exp: int = 0
var cutscene_trigger: bool = false
var cutscene_to_be_played: CUTSCENES = CUTSCENES.EYE
var previous_scene: String
var current_scene: String

"""
Upgrade Variables
"""
#Vulkan
var projectile_upgrade_vulkan_amount: int = 0
var projectile_upgrade_vulkan_firerate: int = 0
var projectile_upgrade_vulkan_speed: int = 0
var projectile_upgrade_vulkan_damage: int = 0
var projectile_upgrade_vulkan_peirce: int = 0
#Missile
var projectile_upgrade_missile_unlock: int = 0
var projectile_upgrade_missile_amount: int = 0
var projectile_upgrade_missile_firerate: int = 0
var projectile_upgrade_missile_speed: int = 0
var projectile_upgrade_missile_damage: int = 0
var projectile_upgrade_missile_size: int = 0
#Options
var option_upgrade_amount: int = 0
var option_upgrade_firerate: int = 0
var option_upgrade_speed: int = 0
var option_upgrade_damage: int = 0
#System
var system_shield_amount: int = 0

var enemy_exp_multiplier: int = 0

func gain_exp(amount: int) -> void:
	current_exp += amount
	emit_signal("exp_changed")

func change_scene(scene_path: String) -> void:
	var previous_scene = get_tree().get_current_scene() 
	get_tree().change_scene_to_file(scene_path)
	var current_scene = get_tree().get_current_scene() 

func set_cutscene_to_play(cutscene_name: CUTSCENES) -> void:
	cutscene_trigger = true
	cutscene_to_be_played = cutscene_name

func increment_upgrade_level(upgrade: int) -> void:
	upgrade = upgrade + 1

func save() -> void:
	pass
