extends Node2D

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider


func _ready():
	music_slider.value=db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_slider.value=db_to_linear(AudioServer.get_bus_volume_db(2))
	

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	
	
func _on_return_button_button_up():
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")
