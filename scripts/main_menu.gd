extends Node2D

@onready var start_game_button = $Buttons/StartGameButton
@onready var settings_button = $Buttons/SettingsButton
@onready var exit_button = $Buttons/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#signal der activeres ved tryk på startgame button
func _on_start_game_button_button_up():
	get_tree().change_scene_to_file("res://scener/spil.tscn")

#signal der activeres ved tryk på settings button
func _on_settings_button_button_up():
	pass # Replace with function body.
	
#signal der activeres ved tryk på exit button
func _on_exit_button_button_up():
	get_tree().quit()
	
