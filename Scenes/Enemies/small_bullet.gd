extends AnimatedSprite2D

@onready var _hit_box: EnemyHitBox = $EnemyBulletHitbox

var stationary: bool = false

func _ready():
	_hit_box.connect("touched", queue_free)

func _physics_process(delta):
	if !stationary:
		position.x -= delta * 50
