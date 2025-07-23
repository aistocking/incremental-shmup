extends AudioStreamPlayer

func _ready():
	volume_db = Globals.sfx_volume

func play_sfx(sound: AudioStream, time: float) -> void:
	stream = sound
	play(time)
