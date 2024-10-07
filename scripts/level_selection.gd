extends Node2D



func _on_normal_level_button_up():
	get_tree().change_scene_to_file("res://scener/level_easy.tscn")



func _on_boss_level_button_up():
	get_tree().change_scene_to_file("res://scener/level_elmer.tscn")



func _on_turtorial_level_button_up():
	get_tree().change_scene_to_file("res://scener/level_tutorial.tscn")



func _on_return_button_up():
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")
