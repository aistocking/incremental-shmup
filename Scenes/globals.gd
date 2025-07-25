extends Node

"""
System Variables
"""
var master_volume: int = 80
var sfx_volume: float = -12.0 * (master_volume / 100)
var music_volume: float = -8.0 * (master_volume / 100)

"""
Misc Variables
"""
var current_exp: int = 0
var cutscene_trigger: bool = false
var previous_scene: String

"""
Upgrade Variables
"""
var projectile_upgrade_vulkan_amount: int = 1
var projectile_upgrade_vulkan_firerate: int = 1
var projectile_upgrade_vulkan_speed: int = 1
var projectile_upgrade_vulkan_damage: int = 1

var enemy_exp_multiplier: int = 1

func gain_exp(amount: int) -> void:
	current_exp += amount
