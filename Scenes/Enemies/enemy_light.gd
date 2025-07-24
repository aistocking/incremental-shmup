extends Node2D

"""
Node References
"""
@onready var _health_comp: Node = $HealthComponent
@onready var _ship_sprite: Sprite2D = $ShipSprite
@onready var _flash: ColorRect = $ShipSprite/Flash
@onready var _flash_timer: Timer = $FlashTimer
@onready var _attack_timer: Timer = $AttackTimer
@onready var _flash_recover: Timer = $FlashRecover
@onready var _bullet_spawn: Marker2D = $BulletSpawnPos
@onready var _explosion_sprites: AnimatedSprite2D = $ExplosionSprites
@onready var _smoke_sprites: AnimatedSprite2D = $Smoke
@onready var _sfx_player: SFXPlayer = $SfxPlayer
@onready var _hurt_box: CollisionShape2D = $EnemyHurtBox/CollisionShape2D
@onready var _hit_box: CollisionShape2D =  $EnemyHitBox/CollisionShape2D

"""
Prepacked Scenes
"""
var _SMALL_BULLET_SCENE: PackedScene = preload("res://Scenes/Enemies/small_bullet.tscn")

"""
Resources
"""
var _explosion_sfx: AudioStream = preload("res://Sound/Enemy Die (1).wav")

signal enemy_died

func _ready():
	_health_comp.connect("died", _die)

func _physics_process(delta):
	position.x -= delta * 15

func _start_flash() -> void:
	if _flash_timer.is_stopped() and _flash_recover.is_stopped():
		_flash.visible = true
		_flash_timer.start(0.1)

func _die() -> void:
	_explosion_sprites.visible = true
	_ship_sprite.visible = false
	_smoke_sprites.visible = false
	_smoke_sprites.stop()
	_hit_box.set_deferred("disabled", true)
	_hurt_box.set_deferred("disabled", true)
	_attack_timer.stop()
	_explosion_sprites.play("SmallExplosion")
	_sfx_player.play_sfx(_explosion_sfx, 0.1)
	emit_signal("enemy_died")

func take_damage(damage: int) -> void:
	_health_comp.take_damage(damage)
	_start_flash()
	if _health_comp.current_health <= (_health_comp.max_health / 3):
		_smoke_sprites.start(1.0)

func _on_flash_timer_timeout():
	_flash.visible = false
	_flash_recover.start(0.1)

func _on_attack_timer_timeout():
	var instance = _SMALL_BULLET_SCENE.instantiate()
	instance.global_position = _bullet_spawn.global_position
	get_parent().add_child(instance)

func _on_enemy_hurt_box_area_entered(area):
	if area.is_in_group("EnemyDeSpawner"):
		queue_free()
