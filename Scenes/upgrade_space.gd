extends Node2D

"""
Node References
"""
@onready var _camera: Camera2D = $Camera2D

"""
Variables
"""
var _focus_target: Sprite2D

"""
Resources
"""
const _bg_music: AudioStream = preload("res://Sound/Music/18 - Lo-Fi Mix.mp3")

func _ready():
	MusicManager.change_music(_bg_music, 0.0)
	_focus_target = $VulkanDamage
	_camera.position = _focus_target.position
