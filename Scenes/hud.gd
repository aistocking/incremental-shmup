class_name HUD
extends CanvasLayer

@onready var _anims: AnimationPlayer = $Anims

func start():
	_anims.play("Intro")
