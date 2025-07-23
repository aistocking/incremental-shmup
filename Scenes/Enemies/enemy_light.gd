extends Node2D

"""
Node References
"""
@onready var _health_comp: Node = $HealthComponent
@onready var _flash: ColorRect = $Sprite2D/Flash
@onready var _flash_timer: Timer = $FlashTimer
@onready var _flash_recover: Timer = $FlashRecover
@onready var _bullet_spawn: Marker2D = $BulletSpawnPos

"""
Prepacked Scenes
"""
var _SMALL_BULLET_SCENE: PackedScene = preload("res://Scenes/Enemies/small_bullet.tscn")

func _ready():
	_health_comp.connect("died", _die)

func _physics_process(delta):
	position.x -= delta * 15

func _start_flash() -> void:
	if _flash_timer.is_stopped() and _flash_recover.is_stopped():
		_flash.visible = true
		_flash_timer.start(0.1)

func _die() -> void:
	queue_free()

func take_damage(damage: int) -> void:
	_health_comp.take_damage(damage)
	_start_flash()

func _on_flash_timer_timeout():
	_flash.visible = false
	_flash_recover.start(0.1)

func _on_attack_timer_timeout():
	var instance = _SMALL_BULLET_SCENE.instantiate()
	instance.global_position = _bullet_spawn.global_position
	get_parent().add_child(instance)
