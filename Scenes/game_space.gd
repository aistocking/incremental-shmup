extends Node2D

@onready var _player: CharacterBody2D = $Player
@onready var _hud: CanvasLayer = $HUD
@onready var _anims: AnimationPlayer = $Anims

func _ready():
	MusicManager.change_music(MusicManager.act1_theme, 0.0)
	_anims.play("Fade_In")
	await get_tree().create_timer(0.2).timeout
	_hud.start()
	await get_tree().create_timer(0.2).timeout
	_player.start()
