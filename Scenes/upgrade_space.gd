extends Node2D

"""
Node References
"""
@onready var _camera: Camera2D = $Camera2D
@onready var _hud: CanvasLayer = $HUD
@onready var _cursor: AnimatedSprite2D = $Cursor
@onready var _text_box: NinePatchRect = $TextBox
@onready var _upgrade_title: Label = $TextBox/MarginContainer/UpgradeTitle
@onready var _upgrade_text: Label = $TextBox/MarginContainer/UpgradeText
@onready var _upgrade_cost: Label = $TextBox/MarginContainer/UpgradeCost
@onready var _upgrade_level: Label = $TextBox/MarginContainer/UpgradeLevel
@onready var _sfx_player: SFXPlayer = $SfxPlayer


"""
Variables
"""
var _focus_target: Sprite2D
var _upgrade_success_state: bool
var player_input: bool

"""
Resources
"""
var _ui_move_sfx: AudioStream = preload("res://Sound/UI_Move.wav")
var _ui_upgrade_sfx: AudioStream = preload("res://Sound/UI_Upgrade.wav")
var _ui_cancel_sfx: AudioStream = preload("res://Sound/UI_Cancel.wav")

func _ready():
	_hud.upgradespace_start()
	_hud.connect("outro_finished", _return_to_gamespace)
	MusicManager.change_music(MusicManager.upgrade_theme, 0.0)
	set_ui_elements($VulkanUpgrades/VulkanUnlock)
	player_input = true
	$VulkanUpgrades/VulkanUnlock/ActualButton.grab_focus()



func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	if event.is_action_pressed("Confirm"):
		if _focus_target.get_child(0).disabled:
			if _focus_target.unlock_upgrade():
				_sfx_player.play_sfx(_ui_upgrade_sfx, 0.0)
				_reset_stats_on_upgrade()
			else:
				_sfx_player.play_sfx(_ui_cancel_sfx, 0.0)
		else:
			_focus_target.connect("upgrade_success_state", _upgrade_success_check)
			await _focus_target.upgrade_success_state
			if _upgrade_success_state:
				_sfx_player.play_sfx(_ui_upgrade_sfx, 0.0)
			else:
				_sfx_player.play_sfx(_ui_cancel_sfx, 0.0)
			_focus_target.disconnect("upgrade_success_state", _upgrade_success_check)
			
	
	if event.is_action_pressed("Cancel"):
		_hud.upgradespace_end()
	
	if event.is_action_pressed("Pause"):
		player_input = false
		pass

func _upgrade_success_check(state: bool) -> void:
	_upgrade_success_state = state
	if state == true:
		_reset_stats_on_upgrade()

func _return_to_gamespace() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_space.tscn")

func set_ui_elements(target: Sprite2D) -> void:
	_focus_target = target
	if target.upgrade_type == "Unlock":
		_cursor.play("Large")
	else:
		_cursor.play("Normal")
	_cursor.position = _focus_target.position
	_text_box.position = _focus_target.position + Vector2(-200, -110)
	_upgrade_title.text = _focus_target.title
	_upgrade_text.text = _focus_target.description
	_upgrade_cost.text = str(_focus_target.cost[_focus_target.current_level])
	_upgrade_level.text = str(_focus_target.current_level) + " / " + str(_focus_target.unlock_limit)
	_camera.position = _focus_target.position
	_sfx_player.play_sfx(_ui_move_sfx, 0.0)
	_hud.update_debug_stats()

func _reset_stats_on_upgrade() -> void:
	_upgrade_cost.text = str(_focus_target.cost[_focus_target.current_level])
	_upgrade_level.text = str(_focus_target.current_level) + " / " + str(_focus_target.unlock_limit)
	_hud.update_debug_stats()


func _on_v_speed_button_focus_entered():
	set_ui_elements($VulkanUpgrades/VulkanSpeed)

func _on_v_fire_rate_button_focus_entered():
	set_ui_elements($VulkanUpgrades/VulkanFireRate)

func _on_v_amount_button_focus_entered():
	set_ui_elements($VulkanUpgrades/VulkanAmount)


func _on_sortie_button_pressed():
	_return_to_gamespace()


func _on_v_speed_button_pressed():
	Globals.projectile_upgrade_vulkan_speed += 1
	_hud.update_debug_stats()


func _on_v_fire_rate_button_pressed():
	Globals.projectile_upgrade_vulkan_firerate += 1
	_hud.update_debug_stats()


func _on_v_amount_button_pressed():
	Globals.projectile_upgrade_vulkan_amount += 1
	_hud.update_debug_stats()
