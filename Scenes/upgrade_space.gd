extends Node2D

"""
Node References
"""
@onready var _camera: Camera2D = $Camera2D
@onready var _hud: CanvasLayer = $HUD
@onready var _cursor: AnimatedSprite2D = $Cursor
@onready var _text_box: NinePatchRect = $TextBox

"""
Variables
"""
var _focus_target: Sprite2D
var player_input: bool

"""
Resources
"""
const _bg_music: AudioStream = preload("res://Sound/Music/18 - Lo-Fi Mix.mp3")

func _ready():
	_hud.upgradespace_start()
	_hud.connect("outro_finished", _return_to_gamespace)
	MusicManager.change_music(_bg_music, 0.0)
	_set_ui_elements($VulkanUpgrades/VulkanUnlock)
	player_input = true
	$VulkanUpgrades/VulkanUnlock/VUnlockButton.grab_focus()
	if Globals.projectile_upgrade_vulkan_damage > 1:
		$VulkanUpgrades/VulkanDamage/VDamageButton.disabled = false
	if Globals.projectile_upgrade_vulkan_speed > 1:
		$VulkanUpgrades/VulkanSpeed/VSpeedButton.disabled = false
	if Globals.projectile_upgrade_vulkan_firerate > 1:
		$VulkanUpgrades/VulkanFireRate/VFireRateButton.disabled = false


func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	if event.is_action_pressed("Confirm"):
		if _focus_target.get_child(0).disabled:
			_focus_target.get_child(0).disabled = false
	
	if event.is_action_pressed("Cancel"):
		_hud.upgradespace_end()
	
	if event.is_action_pressed("Pause"):
		player_input = false
		pass

func _return_to_gamespace() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_space.tscn")

func _set_ui_elements(target: Sprite2D) -> void:
	_focus_target = target
	_cursor.position = _focus_target.position
	_text_box.position = _focus_target.position + Vector2(-200, -110)
	_camera.position = _focus_target.position


func _on_v_damage_button_focus_entered():
	_set_ui_elements($VulkanUpgrades/VulkanDamage)

func _on_v_unlock_button_focus_entered():
	_set_ui_elements($VulkanUpgrades/VulkanUnlock)

func _on_v_speed_button_focus_entered():
	_set_ui_elements($VulkanUpgrades/VulkanSpeed)

func _on_v_fire_rate_button_focus_entered():
	_set_ui_elements($VulkanUpgrades/VulkanFireRate)

func _on_sortie_button_pressed():
	_return_to_gamespace()


func _on_v_damage_button_pressed():
	Globals.projectile_upgrade_vulkan_damage += 1
	_hud.update_debug_stats()
	print(str(Globals.projectile_upgrade_vulkan_damage))


func _on_v_speed_button_pressed():
	Globals.projectile_upgrade_vulkan_speed += 1
	_hud.update_debug_stats()


func _on_v_fire_rate_button_pressed():
	Globals.projectile_upgrade_vulkan_firerate += 1
	_hud.update_debug_stats()
