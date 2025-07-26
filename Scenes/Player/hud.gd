class_name HUD
extends CanvasLayer

@onready var _anims: AnimationPlayer = $Anims
@onready var _bits_value: Label = $MarginContainer/BitsContainer/BitsValue

signal outro_finished

func _ready():
	Globals.connect("exp_changed", _update_bit_counter)
	_update_bit_counter()

func gamespace_start() -> void:
	_anims.animation_set_next("Fade_In", "Intro")
	_anims.play("Fade_In")

func gamespace_end() -> void:
	_anims.animation_set_next("Outro", "Fade_Out")
	_anims.play("Outro")

func upgradespace_start() -> void:
	if Globals.previous_scene == "cutscenes.tscn":
		_anims.play("RESET")
	else:
		_anims.play("Fade_In")

func upgradespace_end() -> void:
	_anims.play("Fade_Out")
	await _anims.animation_finished
	emit_signal("outro_finished")

func _update_bit_counter() -> void:
	_bits_value.text = str(Globals.current_exp)
