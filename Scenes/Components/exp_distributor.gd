extends Node

@export var exp_amount: int

var _big_bits: int = 0
var _medium_bits: int = 0
var _small_bits: int = 0

const _EXP_SCENE = preload("res://Scenes/Misc/exp_bit.tscn")

func _ready():
	exp_amount * Globals.enemy_exp_multiplier
	_big_bits = floor(exp_amount / 100)
	exp_amount %= 100
	_medium_bits = floor(exp_amount / 10)
	exp_amount %= 10
	_small_bits = exp_amount
	get_parent().connect("enemy_died", _spread_exp)

func _spread_exp() -> void:
	for i in _big_bits:
		var big_inst = _EXP_SCENE.instantiate()
		big_inst.make_large()
		big_inst.global_position = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		get_parent().add_child(big_inst)
	for i in _medium_bits:
		var medium_inst = _EXP_SCENE.instantiate()
		medium_inst.make_medium()
		medium_inst.global_position = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		get_parent().add_child(medium_inst)
	for i in _small_bits:
		var small_inst = _EXP_SCENE.instantiate()
		small_inst.make_small()
		small_inst.global_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		get_parent().add_child(small_inst)
