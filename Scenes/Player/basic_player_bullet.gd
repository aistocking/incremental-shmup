extends AnimatedSprite2D

var _speed: float = 250.0 * Globals.projectile_upgrade_vulkan_speed 
var _damage: int = 2 * Globals.projectile_upgrade_vulkan_damage

func _physics_process(delta):
	position.x += _speed * delta

func _die() -> void:
	queue_free()

func _on_player_bullet_hit_box_area_entered(area):
	if area.is_in_group("BulletDeSpawner"):
		_die()
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().take_damage(_damage)
		_die()
