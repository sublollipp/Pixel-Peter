extends Node2D

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider


func _ready():
	if AudioServer.get_bus_volume_db(1)>-40:
		music_slider.value=AudioServer.get_bus_volume_db(1)
	else: music_slider.value=-40
	
	if AudioServer.get_bus_volume_db(2)>-40:
		sfx_slider.value=AudioServer.get_bus_volume_db(2)
	else: sfx_slider.value=-40

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	
	
func _on_return_button_button_up():
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")
