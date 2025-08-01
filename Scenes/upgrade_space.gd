extends Node2D

"""
Node References
"""
@onready var _camera: Camera2D = $Camera2D
@onready var _hud: CanvasLayer = $HUD
@onready var _cursor: AnimatedSprite2D = $Cursor
@onready var _text_box_group: Control = $TextBoxGroup
@onready var _upgrade_title: Label = $TextBoxGroup/TextBox/MarginContainer/UpgradeTitle
@onready var _upgrade_text: Label = $TextBoxGroup/TextBox/MarginContainer/UpgradeText
@onready var _upgrade_cost: Label = $TextBoxGroup/TextBox/MarginContainer/UpgradeCost
@onready var _upgrade_level: Label = $TextBoxGroup/TextBox/MarginContainer/UpgradeLevel
@onready var _sfx_player: SFXPlayer = $SfxPlayer
@onready var _anims: AnimationPlayer = $Anims


"""
Variables
"""
var _focus_target
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
	player_input = true
	$MainCPU/SortieButton.grab_focus()



func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	if event.is_action_pressed("Confirm"):
		if _focus_target == $MainCPU:
			return
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
	_text_box_group.position = _focus_target.position + Vector2(-200, -110)
	_upgrade_title.text = _focus_target.title
	_upgrade_text.text = _focus_target.description
	_upgrade_cost.text = str(_focus_target.cost[_focus_target.current_level])
	_upgrade_level.text = str(_focus_target.current_level) + " / " + str(_focus_target.unlock_limit)
	_camera.position = _focus_target.position
	_sfx_player.play_sfx(_ui_move_sfx, 0.0)
	_anims.play("TextBoxAppear")
	_hud.update_debug_stats()

func _reset_stats_on_upgrade() -> void:
	_upgrade_cost.text = str(_focus_target.cost[_focus_target.current_level])
	_upgrade_level.text = str(_focus_target.current_level) + " / " + str(_focus_target.unlock_limit)
	_hud.update_debug_stats()


func _on_sortie_button_pressed():
	_return_to_gamespace()

func _on_sortie_button_focus_entered():
	_focus_target = $MainCPU
	$TextBoxGroup.visible = false
	_cursor.position = _focus_target.position
	_camera.position = _focus_target.position
	_cursor.play("CPU")
	_focus_target.play("default")
	_sfx_player.play_sfx(_ui_move_sfx, 0.0)

func _on_sortie_button_focus_exited():
	$TextBoxGroup.visible = true
	$MainCPU.stop()
