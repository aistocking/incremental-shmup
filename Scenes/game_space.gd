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
@onready var _spawn_marker_top: Marker2D = $Spawners/Top
@onready var _spawn_marker_mid: Marker2D = $Spawners/Mid
@onready var _spawn_marker_bottom: Marker2D = $Spawners/Bottom

func _ready():
	MusicManager.change_music(MusicManager.act1_theme, 0.0)
	_player.connect("player_died", _hud.end)
	_hud.connect("outro_finished", _return_to_upgrade_space)
	_hud.start()
	await get_tree().create_timer(0.2).timeout
	_player.start()

func _spawn_random_enemy() -> void:
	var instance = _LIGHT_ENEMY_SCENE.instantiate()
	var random_y = randf_range(_spawn_marker_top.global_position.y, _spawn_marker_bottom.global_position.y)
	var spawn_pos: Vector2 = Vector2(_spawn_marker_top.global_position.x, random_y)

	instance.global_position = spawn_pos
	add_child(instance)

func _return_to_upgrade_space() -> void:
	get_tree().change_scene_to_file("res://Scenes/upgrade_space.tscn")

func _on_spawn_timer_timeout():
	_spawn_random_enemy()
