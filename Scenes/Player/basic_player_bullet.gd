extends AnimatedSprite2D

var _speed: float = 250.0 + (Globals.vulkan_dict["Speed"] * 25)
var _damage: int = 1 + (Globals.vulkan_dict["Damage"] * 1)
var _peirce_amount: int = 0 + Globals.vulkan_dict["Pierce"]
var _moving: bool = true

func _physics_process(delta):
	if _moving:
		position.x += _speed * delta

func _die(just_despawn: bool) -> void:
	if just_despawn:
		queue_free()
	else:
		_moving = false
		position.x += 6
		play("hit")
		await animation_finished
		queue_free()

func _on_player_bullet_hit_box_area_entered(area):
	if area.is_in_group("BulletDeSpawner"):
		_die(true)
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().take_damage(_damage)
		if _peirce_amount > 0:
			_peirce_amount -= 1
		else:
			_die(false)
