extends AnimatedSprite2D

@onready var _sfx_player: SFXPlayer = $SfxPlayer

var _damage: float = 5 + (Globals.missile_dict["Damage"] * 5)

const _explosion_sfx: AudioStream = preload("res://Sound/Missile_Explosion.wav")

func _ready():
	_sfx_player.play_sfx_rand_pitch(_explosion_sfx, 0.0, .1)

func _on_player_bullet_hit_box_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().take_damage(_damage)


func _on_animation_finished():
	queue_free()
