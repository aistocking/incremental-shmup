extends Control

@onready var _start_button: TextureButton = $TextBox/MarginContainer/VBoxContainer/StartButton
@onready var _exit_button: TextureButton = $TextBox/MarginContainer/VBoxContainer/ExitButton
@onready var _cursor_left: AnimatedSprite2D = $CursorLeft
@onready var _cursor_right: AnimatedSprite2D = $CursorRight
@onready var _anims: AnimationPlayer = $Anims
@onready var _sfx_player: SFXPlayer = $SfxPlayer
var _intro_done: bool = false

var _move_sfx: AudioStream = preload("res://Sound/UI_Move.wav")

func _ready():
	MusicManager.change_music(MusicManager.title_theme, 0.0)
	_start_button.grab_focus()



func _on_start_button_focus_entered():
	if _intro_done:
		_sfx_player.play_sfx(_move_sfx, 0.0)
	_cursor_left.global_position = _start_button.global_position + Vector2(-25, _start_button.size.y / 2)
	_cursor_right.global_position = _start_button.global_position + Vector2((_start_button.size.x * 2) + 25, _start_button.size.y / 2)


func _on_exit_button_focus_entered():
	if _intro_done:
		_sfx_player.play_sfx(_move_sfx, 0.0)
	_cursor_left.global_position = _exit_button.global_position + Vector2(-25, _start_button.size.y / 2)
	_cursor_right.global_position = _exit_button.global_position + Vector2((_exit_button.size.x * 2) + 25, _start_button.size.y / 2)


func _on_start_button_pressed():
	_anims.play("Outro")
	await _anims.animation_finished
	get_tree().change_scene_to_file("res://Scenes/game_space.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_anims_animation_finished(anim_name):
	_intro_done = true
