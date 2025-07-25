extends Node2D

func _ready():
	MusicManager.stop()
	Globals.previous_scene = "cutscenes.tscn"
	$Anims.play("Eye_Opening")


func _on_anims_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/upgrade_space.tscn")
