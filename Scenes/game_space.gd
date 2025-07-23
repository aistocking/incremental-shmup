extends Node2D

"""
Node References
"""
@onready var _player: CharacterBody2D = $Player
@onready var _hud: CanvasLayer = $HUD
@onready var _anims: AnimationPlayer = $Anims
@onready var _spawn_timer: Timer = $SpawnTimer

"""
Packed Scenes
"""
var _LIGHT_ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemies/enemy_light.tscn")

"""
Spawn Markers
"""
@onready var _spawn_marker_topmost: Marker2D = $Spawners/TopMost
@onready var _spawn_marker_top: Marker2D = $Spawners/Top
@onready var _spawn_marker_midtop: Marker2D = $Spawners/MidTop
@onready var _spawn_marker_mid: Marker2D = $Spawners/Mid
@onready var _spawn_marker_midbottom: Marker2D = $Spawners/MidBottom
@onready var _spawn_marker_bottom: Marker2D = $Spawners/Bottom
@onready var _spawn_marker_bottommost: Marker2D = $Spawners/BottomMost

func _ready():
	MusicManager.change_music(MusicManager.act1_theme, 0.0)
	_anims.play("Fade_In")
	await get_tree().create_timer(0.2).timeout
	_hud.start()
	await get_tree().create_timer(0.2).timeout
	_player.start()

func _spawn_random_enemy() -> void:
	var instance = _LIGHT_ENEMY_SCENE.instantiate()
	var random_spawn_picker = randi_range(1, 7)
	var spawn_pos: Vector2
	match random_spawn_picker:
		1:
			spawn_pos = _spawn_marker_topmost.global_position
		2:
			spawn_pos = _spawn_marker_top.global_position
		3:
			spawn_pos = _spawn_marker_midtop.global_position
		4:
			spawn_pos = _spawn_marker_mid.global_position
		5:
			spawn_pos = _spawn_marker_midbottom.global_position
		6:
			spawn_pos = _spawn_marker_bottom.global_position
		7:
			spawn_pos = _spawn_marker_bottommost.global_position
	instance.global_position = spawn_pos
	add_child(instance)


func _on_spawn_timer_timeout():
	_spawn_random_enemy()
