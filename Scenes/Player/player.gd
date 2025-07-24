class_name Player
extends CharacterBody2D

"""
Node References
"""
@onready var _player_sprites: Sprite2D = $ShipSprite
@onready var _exhaust_sprites: AnimatedSprite2D = $ShipSprite/Exhaust
@onready var _backblast_sprites: AnimatedSprite2D = $BackBlast
@onready var _anims: AnimationPlayer = $Anims
@onready var _bullet_spawn_marker: Marker2D = $BulletSpawnPos
@onready var _vulkan_recover_timer: Timer = $VulkanRecoverTimer
@onready var _missile_recover_timer: Timer = $MissileRecoverTimer
@onready var _sfx_player: AudioStreamPlayer = $SfxPlayer
@onready var _hurt_collider: CollisionShape2D = $HurtBox/HurtCollision

"""
Packed Scenes
"""
var _BASIC_BULLET_SCENE: PackedScene = preload("res://Scenes/Player/basic_player_bullet.tscn")

"""
Variables
"""
var player_input: bool = false

var _speed: float = 100.0
var _previous_velocity: Vector2
var _firing: bool = false
var _focused: bool = false
var _shields: int = 0

signal player_died

func _ready():
	pass

func start() -> void:
	_anims.play("Intro")
	await _anims.animation_finished
	change_player_control_to(true)
	

func _physics_process(delta):
	if _firing:
		_fire_projectiles()
	
	if player_input == true:
		handle_movement()
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	if event.is_action_pressed("Fire"):
		_firing = true
		_backblast_sprites.visible = true
		_backblast_sprites.play("Light")
	if event.is_action_released("Fire"):
		_firing = false
		_backblast_sprites.visible = false
	
	if event.is_action_pressed("Focus"):
		_focused = true
	if event.is_action_released("Focus"):
		_focused = false
		
	if event.is_action_pressed("Bomb"):
		pass
	
	if event.is_action_pressed("Pause"):
		change_player_control_to(false)
		pass

func change_player_control_to(boo: bool):
	player_input = boo

func handle_movement() -> void:
	var direction_horizontal: float = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	var direction_vertical: float = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	var new_velocity = Vector2(direction_horizontal * _speed, direction_vertical * (_speed * 0.7))
	
	if new_velocity == _previous_velocity:
		return
	else:
		_previous_velocity = new_velocity
	
	if direction_horizontal > 0:
		_exhaust_sprites.play("Moving")
	else:
		_exhaust_sprites.play("Idle")
	if direction_vertical < 0:
		_player_sprites.frame = 1
	elif direction_vertical > 0:
		_player_sprites.frame = 2
	else:
		_player_sprites.frame = 0
	
	velocity = new_velocity

func _fire_projectiles() -> void:
	if _vulkan_recover_timer.is_stopped():
		_vulkan_recover_timer.start(0.3 / Globals.projectile_upgrade_vulkan_firerate)
		var bullet_instance = _BASIC_BULLET_SCENE.instantiate()
		bullet_instance.global_position = _bullet_spawn_marker.global_position
		get_parent().add_child(bullet_instance)

func get_hit() -> void:
	if _shields <= 0:
		_die()

func _die() -> void:
	_hurt_collider.set_deferred("disabled", true)
	change_player_control_to(false)
	velocity = Vector2.ZERO
	_firing = false
	_anims.play("Die")
	await _anims.animation_finished
	emit_signal("player_died")
