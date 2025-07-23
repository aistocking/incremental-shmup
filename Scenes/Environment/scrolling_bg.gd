extends SubViewport

@onready var _wall: MeshInstance3D = $Wall
@onready var _small_lines: MeshInstance3D = $SmallLines
@onready var _large_lines: MeshInstance3D = $LargeLines
@onready var _camera: Camera3D = $Camera3D

var _player: CharacterBody2D

func _ready():
	_player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	_wall.get_surface_override_material(0).uv1_offset.x += 0.1 * delta
	_small_lines.get_surface_override_material(0).uv1_offset.x += 0.6 * delta
	_large_lines.get_surface_override_material(0).uv1_offset.x += 1 * delta
	#_match_player_height()
"""
func _match_player_height() -> void:
	var normalized_pos = _player.position.y / 180
	_camera.rotation.x = 20 * normalized_pos
"""
