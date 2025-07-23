extends AnimatedSprite2D

var _base_speed: float = 25.0

func _ready():
	move_local_x(Globals.projectile_upgrade_vulkan_speed * _base_speed)

func _die() -> void:
	queue_free()

func _on_player_bullet_hit_box_area_entered(area):
	if area.is_in_group("BulletDeSpawner"):
		_die()
	if area.is_in_group("Enemy"):
		pass
