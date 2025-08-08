extends Node2D

var labelOpacity : float = 1
var labelOpacityIncrement = -0.015
var color_white

var loopCounter : int = 0
var currentAnimation : int = 1

@onready var you_died_label = $YouDiedLabel
@onready var animated_sprite_2d = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRichpresence.updateState("On Game Over Screen")
	if OS.has_feature("web"):
		%ExitButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pulse(1)
	color_white = Color(255,255,255,labelOpacity)
	you_died_label.set("theme_override_colors/font_color",color_white)
	
	if loopCounter == 2:
		loopCounter = 0
		if currentAnimation == 3:
			currentAnimation = 1
		else:
			currentAnimation+=1
	animated_sprite_2d.play("PixelP"+str(currentAnimation))
	
func pulse(delta):
	labelOpacity += labelOpacityIncrement*delta
	if labelOpacity>=1:
		labelOpacity = 1
		labelOpacityIncrement = -labelOpacityIncrement
	if labelOpacity<=0.4:
		labelOpacity = 0.4
		labelOpacityIncrement = -labelOpacityIncrement

func _on_start_again_button_up():
	Globals.start_game_over()


func _on_exit_button_button_up():
	get_tree().quit()

func _on_main_menu_button_button_up():
	Globals.setCoins(0)
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")
	
func _on_animated_sprite_2d_animation_looped():
	loopCounter += 1



	pass # Replace with function body.
