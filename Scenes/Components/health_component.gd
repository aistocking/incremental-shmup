class_name HealthComponent
extends Node

@export var max_health: int
var current_health: int

signal died

func _ready():
	current_health = max_health

func take_damage(damage: int) -> void:
	current_health -= damage
	if current_health <= 0:
		emit_signal("died")
