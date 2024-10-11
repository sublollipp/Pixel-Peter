extends Node2D



func _on_normal_level_button_up():
	Globals.nextLevel("res://scener/level_easy.tscn")
	Globals.startNewRun("res://scener/level_easy.tscn", "Normal")



func _on_boss_level_button_up():
	Globals.nextLevel("res://scener/level_elmer.tscn")
	Globals.startNewRun("res://scener/level_elmer.tscn", "Boss")



func _on_turtorial_level_button_up():
	Globals.nextLevel("res://scener/level_tutorial.tscn")
	Globals.startNewRun("res://scener/level_tutorial.tscn", "Tutorial")



func _on_return_button_up():
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")
