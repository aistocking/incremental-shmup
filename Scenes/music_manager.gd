extends AudioStreamPlayer

var title_theme: AudioStream = load("res://Sound/Music/12 - Drad.mp3")
var upgrade_theme: AudioStream = load("res://Sound/Music/18 - Lo-Fi Mix.mp3")
var act1_theme: AudioStream = load("res://Sound/Music/04 - Run of the Destiny.mp3")
var boss_theme: AudioStream = load("res://Sound/Music/18 - Lo-Fi Mix.mp3")

func change_music(song: AudioStream, time: float) -> void:
	await create_tween().tween_property(self, "volume_db", -30.0, 0.5).finished
	stream = song
	play(time)
	create_tween().tween_property(self, "volume_db", Globals.music_volume, 0.5).finished
