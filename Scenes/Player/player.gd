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
@onready var _exhaust_particles_heavy: GPUParticles2D = $ExhaustAnimGroup/HeavyExhaustParticles
@onready var _exhaust_particles_light: GPUParticles2D = $ExhaustAnimGroup/LightExhaustParticles
@onready var _shield_sprites: AnimatedSprite2D = $Shield

"""
Resources
"""

var _shoot_sfx: AudioStream = preload("res://Sound/Shoot.wav")
var _missile_fire_sfx: AudioStream = preload("res://Sound/Missile_Fire.wav")
var _hit_sfx: AudioStream = preload("res://Sound/Hit.wav")

"""
Packed Scenes
"""
const _BASIC_BULLET_SCENE: PackedScene = preload("res://Scenes/Player/basic_player_bullet.tscn")
const _MISSILE_SCENE: PackedScene = preload("res://Scenes/Player/missile_projectile.tscn")
const _BOOST_RING_SCENE: PackedScene = preload("res://Scenes/Player/boost_ring.tscn")

"""
Variables
"""
var player_input: bool = false
var _speed: float = 100.0
var _previous_velocity: Vector2
var _firing: bool = false
var _focused: bool = false
#Internal pointers so we dont have to constantly investigate global dicts
var _vulkan_amount: int = Globals.vulkan_dict["Amount"] + Globals.vulkan_dict["Unlock"]
var _vulkan_firerate: int = Globals.vulkan_dict["FireRate"]
var _missile_amount: int = Globals.missile_dict["Amount"] + Globals.missile_dict["Unlock"]
var _missile_firerate: int = Globals.missile_dict["FireRate"]
var _plasma_unlocked: bool = bool(Globals.plasma_dict["Unlock"])
var _can_focus: bool = bool(Globals.system_dict["Unlock"])
var _shields: int = Globals.system_dict["Shield"]

signal player_died


"""
Functions
"""

func _ready():
	pass

func start() -> void:
	_anims.play("Intro")
	await _anims.animation_finished
	if _shields > 0:
		_shield_sprites.visible = true
		_match_shields()
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
		_backblast_sprites.stop()
	
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
		_exhaust_particles_heavy.emitting = true
		_exhaust_particles_light.emitting = false
	else:
		_exhaust_sprites.play("Idle")
		_exhaust_particles_heavy.emitting = false
		_exhaust_particles_light.emitting = true
	if direction_vertical < 0:
		_player_sprites.frame = 1
	elif direction_vertical > 0:
		_player_sprites.frame = 2
	else:
		_player_sprites.frame = 0
	
	velocity = new_velocity

func _fire_projectiles() -> void:
	if _vulkan_recover_timer.is_stopped():
		_vulkan_recover_timer.start(0.54 - (_vulkan_firerate * 0.05))
		_sfx_player.play_sfx_rand_pitch(_shoot_sfx, 0.0, .1)
		for i in (_vulkan_amount):
			var bullet_instance = _BASIC_BULLET_SCENE.instantiate()
			match i:
				0:
					bullet_instance.global_position = _bullet_spawn_marker.global_position
				1:
					bullet_instance.global_position = _bullet_spawn_marker.global_position + Vector2(-3, 4)
				2:
					bullet_instance.global_position = _bullet_spawn_marker.global_position + Vector2(-3, -4)
				3:
					bullet_instance.global_position = _bullet_spawn_marker.global_position + Vector2(-6, 8)
				4:
					bullet_instance.global_position = _bullet_spawn_marker.global_position + Vector2(-6, -8)
			get_parent().add_child(bullet_instance)
	if _missile_recover_timer.is_stopped() and _missile_amount != 0:
		_missile_recover_timer.start(1 - (_missile_firerate * 0.085))
		_sfx_player.play_sfx_rand_pitch(_missile_fire_sfx, 0.0, .1)
		for i in (_missile_amount):
			var missile_instance = _MISSILE_SCENE.instantiate()
			match i:
				0:
					missile_instance.global_position = global_position + Vector2(5,0)
					missile_instance.y_movement = -15
				1:
					missile_instance.global_position = global_position + Vector2(5,0)
					missile_instance.y_movement = 15
				2:
					missile_instance.global_position = global_position
					missile_instance.y_movement = -25
				3:
					missile_instance.global_position = global_position
					missile_instance.y_movement = 25
			get_parent().add_child(missile_instance)

func _match_shields() -> void:
	match _shields:
		0:
			_shield_sprites.play("break")
		1:
			_shield_sprites.play("level1")
		2:
			_shield_sprites.play("level2")
		3:
			_shield_sprites.play("level3")

func get_hit() -> void:
	if _shields <= 0:
		_die()
	else:
		_shields -= 1
		_match_shields()
	_sfx_player.play_sfx(_hit_sfx, 0.0)

func _die() -> void:
	_hurt_collider.set_deferred("disabled", true)
	change_player_control_to(false)
	_exhaust_particles_heavy.emitting = false
	_exhaust_particles_light.emitting = false
	_backblast_sprites.stop()
	_backblast_sprites.visible = false
	_exhaust_sprites.stop()
	_exhaust_sprites.visible = false
	velocity = Vector2.ZERO
	_firing = false
	_anims.play("Die")
	await _anims.animation_finished
	emit_signal("player_died")

func create_boost_ring() -> void:
	var instance = _BOOST_RING_SCENE.instantiate()
	instance.position = $ExhaustAnimGroup.position
	add_child(instance)


func _on_shield_animation_finished():
	_shield_sprites.visible = false
