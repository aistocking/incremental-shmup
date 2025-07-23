class_name HealthComponent
extends Node

@export var base_health: int
var _current_health: int

signal died

func _ready():
	_current_health = base_health

func take_damage(damage: int) -> void:
	_current_health -= damage
	if _current_health <= 0:
		emit_signal("died")
