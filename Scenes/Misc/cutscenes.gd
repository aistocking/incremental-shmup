extends Node2D

@onready var _abort_sprites: AnimatedSprite2D = $AbortGroup/Abort
@onready var _bg_rect: ColorRect = $Camera2D/BG

func _ready():
	MusicManager.stop()
	Globals.previous_scene = "cutscenes.tscn"
	$Anims.play("Abort")

func _abort_scene_multiply() -> void:
	for i in 28:
		var spawn_x = randf_range(120, -120)
		var spawn_y = randf_range(90, -90)
		var duplicated_instance = _abort_sprites.duplicate()
		duplicated_instance.global_position = Vector2(spawn_x, spawn_y)
		$AbortGroup.add_child(duplicated_instance)
		await get_tree().create_timer(.75 / (i+1)).timeout

func _on_anims_animation_finished(anim_name):
	if anim_name == "Abort":
		get_tree().quit()
	if anim_name == "Eye_Opening":
		get_tree().change_scene_to_file("res://Scenes/upgrade_space.tscn")
