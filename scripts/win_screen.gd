extends Node2D

@onready var info_label = $Labels/InfoLabel
@onready var animated_sprite_2d = $AnimatedSprite2D

var labelOpacity : float = 1
var labelOpacityIncrement = -0.02
var color_white

var loopCounter : int = 0
var currentAnimation : int = 1

func _ready() -> void:
	$Labels/CoinLabel.text = str(Globals.coins) + "/" + str(Globals.totalCoins)
	var timerText = Globals.runName() + " "
	if Globals.cheated():
		timerText += "(easy) "
	timerText += Globals.runTime()
	$Labels/RuntimeLabel.text = timerText
	DiscordRichpresence.updateState("On win screen")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pulse(1)
	color_white = Color(255,255,255,labelOpacity)
	info_label.set("theme_override_colors/font_color",color_white)
	
	if loopCounter == 2:
		loopCounter = 0
		if currentAnimation == 3:
			currentAnimation = 1
		else:
			currentAnimation+=1
	animated_sprite_2d.play("PixelP"+str(currentAnimation))
	
	
func _input(event):
	if (event is InputEventKey and event.is_pressed()) or event.is_action_pressed("MousePressed"):
		Globals.coins = 0
		get_tree().change_scene_to_file("res://scener/main_menu.tscn")

	

# A i font color er opacity'en, funktionen pulse varier var labelOpacity mellem 1 og 0.4
func pulse(delta):
	labelOpacity += labelOpacityIncrement*delta
	if labelOpacity>=1:
		labelOpacity = 1
		labelOpacityIncrement = -labelOpacityIncrement
	if labelOpacity<=0.4:
		labelOpacity = 0.4
		labelOpacityIncrement = -labelOpacityIncrement


func _on_animated_sprite_2d_animation_looped():
	loopCounter += 1
