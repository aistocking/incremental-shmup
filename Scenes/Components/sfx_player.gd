class_name SFXPlayer
extends AudioStreamPlayer

func _ready():
	volume_db = Globals.sfx_volume

func play_sfx(sound: AudioStream, time: float) -> void:
	stream = sound
	play(time)

func play_sfx_rand_pitch(sound: AudioStream, time: float, pitchRange: float) -> void:
	stream = sound
	pitch_scale = 1 + randf() * pitchRange * rand_sign()
	play(time)

func rand_sign() -> int:
	if randf() > .5:
		return 1
	else:
		return -1
