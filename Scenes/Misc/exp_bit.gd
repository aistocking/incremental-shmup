extends AnimatedSprite2D

var value: int = 1

var _player_ref: Player

@onready var _sfx_player: SFXPlayer = $SfxPlayer

const _pickup_sound: AudioStream = preload("res://Sound/PickupSound.wav")

func _ready():
	_player_ref = get_tree().get_first_node_in_group("Player")

func make_small() -> void:
	play("Small")
	frame = randi_range(0, 11)
	value = 1

func make_medium() -> void:
	play("Medium")
	frame = randi_range(0, 4)
	value = 10

func make_large() -> void:
	play("Large")
	frame = randi_range(0, 10)
	value = 100

func _on_area_2d_area_entered(area):
	Globals.gain_exp(value)
	await create_tween().tween_property(self, "global_position", _player_ref.global_position, 0.05).finished
	visible = false
	_sfx_player.play_sfx_rand_pitch(_pickup_sound, 0.0, .1)
	await _sfx_player.finished
	queue_free()
