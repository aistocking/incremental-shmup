extends Node2D

@onready var _health_comp: Node = $HealthComponent
@onready var _flash: ColorRect = $Sprite2D/Flash
@onready var _flash_timer: Timer = $FlashTimer
@onready var _flash_recover: Timer = $FlashRecover

func _ready():
	_health_comp.connect("died", _die)

func _start_flash() -> void:
	if _flash_timer.is_stopped() and _flash_recover.is_stopped():
		_flash.visible = true
		_flash_timer.start(0.1)

func _die() -> void:
	queue_free()


func _on_flash_timer_timeout():
	_flash.visible = false
	_flash_recover.start(0.1)


func _on_enemy_hurt_box_area_entered(area):
	
	if area.is_in_group("Enemy"):
		pass
