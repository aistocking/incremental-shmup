extends Node2D

"""
Node References
"""
@onready var _camera: Camera2D = $Camera2D
@onready var _hud: HUD = $HUD

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
	_focus_target = $VulkanDamage
	player_input = true
	_camera.position = _focus_target.position

func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	if event.is_action_pressed("Confirm"):
		pass
	
	if event.is_action_pressed("Cancel"):
		_hud.upgradespace_end()
	
	if event.is_action_pressed("Pause"):
		player_input = false
		pass

func _return_to_gamespace() -> void:
	get_tree().change_scene_to_file("res://Scenes/upgrade_space.tscn")
