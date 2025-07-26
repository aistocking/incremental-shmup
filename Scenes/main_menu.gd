extends Control

@onready var _start_button: TextureButton = $MarginContainer/VBoxContainer/StartButton
@onready var _exit_button: TextureButton = $MarginContainer/VBoxContainer/ExitButton
@onready var _cursor_left: AnimatedSprite2D = $CursorLeft
@onready var _cursor_right: AnimatedSprite2D = $CursorRight
@onready var _sfx_player: SFXPlayer = $SfxPlayer

var _move_sfx: AudioStream = preload("res://Sound/UI_Move.wav")

func _ready():
	_start_button.grab_focus()



func _on_start_button_focus_entered():
	_sfx_player.play_sfx(_move_sfx, 0.0)
	_cursor_left.global_position = _start_button.global_position + Vector2(-25, _start_button.size.y / 2)
	_cursor_right.global_position = _start_button.global_position + Vector2((_start_button.size.x * 2) + 25, _start_button.size.y / 2)


func _on_exit_button_focus_entered():
	_sfx_player.play_sfx(_move_sfx, 0.0)
	_cursor_left.global_position = _exit_button.global_position + Vector2(-25, _start_button.size.y / 2)
	_cursor_right.global_position = _exit_button.global_position + Vector2((_exit_button.size.x * 2) + 25, _start_button.size.y / 2)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_space.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
