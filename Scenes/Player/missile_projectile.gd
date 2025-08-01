extends AnimatedSprite2D

var _speed: float = 0
var y_movement: int

const _EXPLOSION_SCENE: PackedScene = preload("res://Scenes/Player/missile_explosion.tscn")

func _ready():
	var _tween_y: Tween = create_tween()
	var _tween_x: Tween = create_tween()
	_tween_y.tween_property(self, "position:y", (global_position.y + y_movement), 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween_x.tween_property(self, "_speed", 200.0 + (Globals.vulkan_dict["Speed"] * 25), 1.5).set_trans(Tween.TRANS_CUBIC)

func _physics_process(delta):
	position.x += _speed * delta

func _explode(just_despawn: bool) -> void:
	if just_despawn:
		queue_free()
	else:
		var instance = _EXPLOSION_SCENE.instantiate()
		instance.global_position = global_position
		get_parent().add_child(instance)
		queue_free()

func _on_player_bullet_hit_box_area_entered(area):
	if area.is_in_group("BulletDeSpawner"):
		_explode(true)
	if area.get_parent().is_in_group("Enemy"):
		_explode(false)
