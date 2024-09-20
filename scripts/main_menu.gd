extends Node2D

@onready var start_game_button = $Buttons/StartGameButton
@onready var settings_button = $Buttons/SettingsButton
@onready var exit_button = $Buttons/ExitButton

@onready var animated_sprite_2d = $AnimatedSprite2D

var loopCounter : int = 0
var currentAnimation : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.flip_h
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loopCounter == 2:
		loopCounter = 0
		if currentAnimation == 3:
			currentAnimation = 1
		else:
			currentAnimation+=1
		
	animated_sprite_2d.play("PixelP"+str(currentAnimation))

#signal der activeres ved tryk på startgame button
func _on_start_game_button_button_up():
	Engine.time_scale=1
	get_tree().change_scene_to_file("res://scener/spil.tscn")

#signal der activeres ved tryk på settings button
func _on_settings_button_button_up():
	pass # Replace with function body.
	
#signal der activeres ved tryk på exit button
func _on_exit_button_button_up():
	get_tree().quit()

	
func _on_animated_sprite_2d_animation_looped():
	loopCounter += 1
