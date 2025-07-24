extends AnimatedSprite2D

@export var value: int

var _player_ref: Player

func _ready():
	_player_ref = get_tree().get_first_node_in_group("Player")
