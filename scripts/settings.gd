extends CanvasLayer

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider
@onready var check_button = $CheckButton

var is_overlay: bool = false

func _ready():
	music_slider.value=db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_slider.value=db_to_linear(AudioServer.get_bus_volume_db(2))
	check_button.button_pressed=Globals.easyMode
	if get_tree().current_scene == self:
		$Sky.visible = true
		visible = true
		print("He found out")
	else:
		$Sky.visible = false

func makeOverlay():
	is_overlay = true

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	
	
func _on_return_button_button_up():
	if not is_overlay:
		get_tree().change_scene_to_file("res://scener/main_menu.tscn")
	else:
		visible = false
		$Sky.visible = false
		get_parent().visible = true





func _on_check_button_toggled(toggled_on):
	if toggled_on:
		Globals.easyMode = true
	else:
		Globals.easyMode = false
