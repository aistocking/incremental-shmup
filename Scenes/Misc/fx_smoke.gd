extends AnimatedSprite2D

var _self_hurt_box: Area2D
var _box_ref: Rect2
var _top_left: Vector2
var _bottom_right: Vector2
var _spawn_x: float
var _spawn_y: float

func _ready():
	_self_hurt_box = get_parent().find_child("EnemyHurtBox")
	_box_ref = _self_hurt_box.get_child(0).shape.get_rect()
	_top_left = _box_ref.position + Vector2(2, 2)
	_bottom_right = _box_ref.end + Vector2(-2, -2)

func start(speed: float) -> void:
	play("default", speed)

func _on_animation_looped():
	_spawn_x = randf_range(_top_left.x, _bottom_right.x)
	_spawn_y = randf_range(_top_left.y, _bottom_right.y)
	position = Vector2(_spawn_x, _spawn_y)
