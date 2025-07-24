class_name EnemyHitBox
extends Area2D

signal touched


func _on_area_entered(area):
	if area.is_in_group("EnemyDeSpawner"):
		get_parent().queue_free()
	if area.get_parent().is_in_group("Player"):
		area.get_parent().get_hit()
	emit_signal("touched")
