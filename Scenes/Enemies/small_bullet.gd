extends AnimatedSprite2D

var stationary: bool = false

func _physics_process(delta):
	if !stationary:
		position.x -= delta * 50
