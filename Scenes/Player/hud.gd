class_name HUD
extends CanvasLayer

@onready var _anims: AnimationPlayer = $Anims
@onready var _gamespace_bits_value: Label = $FullScreenMargin/GameSpaceHUD/BitMargins/BitsContainer/BitsValue

signal outro_finished

func _ready():
	$MainBlackBar.visible = true
	Globals.connect("exp_changed", _update_bit_counter)
	_update_bit_counter()
	visible = true
	update_debug_stats()

func gamespace_start() -> void:
	$FullScreenMargin/GameSpaceHUD.visible = true
	$FullScreenMargin/UpgradeSpaceHUD.visible = false
	_anims.animation_set_next("Fade_In", "Intro")
	_anims.play("Fade_In")

func gamespace_end() -> void:
	_anims.animation_set_next("Outro", "Fade_Out")
	_anims.play("Outro")

func upgradespace_start() -> void:
	$FullScreenMargin/GameSpaceHUD.visible = false
	$FullScreenMargin/UpgradeSpaceHUD.visible = true
	if Globals.previous_scene == "cutscenes.tscn":
		_anims.play("RESET")
	else:
		_anims.play("Fade_In")

func upgradespace_end() -> void:
	_anims.play("Fade_Out")
	await _anims.animation_finished
	emit_signal("outro_finished")

func _update_bit_counter() -> void:
	_gamespace_bits_value.text = str(Globals.current_exp)

func update_debug_stats() -> void:
	$FullScreenMargin/UpgradeSpaceHUD/DebugStats.text = "VDamage:" + str(Globals.vulkan_dict["Damage"]) + "\n" + "VSpeed:" + str(Globals.vulkan_dict["Speed"]) + "\n" + "VFireRate:" + str(Globals.vulkan_dict["FireRate"]) + "\n" + "VAmount:" + str(Globals.vulkan_dict["Amount"])
	print(str(Globals.vulkan_dict["Damage"]))
	


func _on_button_pressed():
	Globals.set_cutscene_to_play(Globals.CUTSCENES.EYE)


func _on_button_2_pressed():
	Globals.set_cutscene_to_play(Globals.CUTSCENES.ABORT)

func _on_button_3_pressed():
	Globals.gain_exp(100000)
