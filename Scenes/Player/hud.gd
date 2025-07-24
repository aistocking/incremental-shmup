class_name HUD
extends CanvasLayer

@onready var _anims: AnimationPlayer = $Anims

signal outro_finished

func start() -> void:
	_anims.animation_set_next("Fade_In", "Intro")
	_anims.play("Fade_In")

func end() -> void:
	_anims.animation_set_next("Outro", "Fade_Out")
	_anims.play("Outro")
