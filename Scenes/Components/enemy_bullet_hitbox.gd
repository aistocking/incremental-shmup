extends Area2D

signal touched

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.get_hit()
	emit_signal("touched")
