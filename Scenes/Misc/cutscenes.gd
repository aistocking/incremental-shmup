extends Node2D

@onready var _anims: AnimationPlayer = $Anims
@onready var _abort_sprites: AnimatedSprite2D = $AbortGroup/Abort
@onready var _bg_rect: ColorRect = $Camera2D/BG


func _ready():
	MusicManager.stop()
	Globals.previous_scene = "cutscenes.tscn"
	match Globals.cutscene_to_be_played:
		Globals.CUTSCENES.EYE:
			_anims.play("Eye_Opening")
		Globals.CUTSCENES.ABORT:
			_anims.play("Abort")

func _abort_scene_multiply() -> void:
	for i in 34:
		var spawn_x = randf_range(120, -120)
		var spawn_y = randf_range(90, -90)
		var duplicated_instance = _abort_sprites.duplicate()
		duplicated_instance.global_position = Vector2(spawn_x, spawn_y)
		$AbortGroup.add_child(duplicated_instance)
		await get_tree().create_timer(.7 / (i+1)).timeout

func _stop_all_aborts() -> void:
	for i in $AbortGroup.get_child_count():
		$AbortGroup.get_child(i).pause()

func _on_anims_animation_finished(anim_name):
	if anim_name == "Abort":
		get_tree().quit()
	if anim_name == "Eye_Opening":
		get_tree().change_scene_to_file("res://Scenes/upgrade_space.tscn")
