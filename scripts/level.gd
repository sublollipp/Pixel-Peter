extends Node2D
class_name Level

#@onready var PauseMenu = $CanvasLayer2

@export_file("*.tscn") var next_level

signal coinsUpdated # Sender info om level coins ud hver gang, det er relevant

@onready var player = $Player



var total_coins: int = -1 # Hvor mange coins der er på banen. Den i GUI'en skal ikke tælle med
var coins_collected: int = 0: # Hvor mange coins på banen spilleren har samlet op
	set(value):
		coinsUpdated.emit(value, total_coins)
		coins_collected = value

#var paused : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_tree().get_nodes_in_group("GroupCoins"): # Finder mængden af coins i levellet
		total_coins += 1
	coins_collected = 0
	Globals.totalCoins += total_coins
	
	

func exit() -> void:
	$CanvasAnimations.play("fadeout")

func coinCollected() -> void: # Vi er gode programmører. Vi bruger setters.
	coins_collected += 1

func _on_exit_entered(body: Node2D) -> void:
	player.set_process(false)
	player.set_physics_process(false)
	Globals.nextLevel(next_level)
