extends Node2D

#@onready var PauseMenu = $CanvasLayer2

@export_file("*.tscn") var next_level

#var paused : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("hej2")
	pass
	#PauseMenu.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	#if event.is_action_pressed("Menu_Pause"):
#		print("hej")
#		pause()
	pass

func pause():
	pass
	#paused = !paused
	
	#if paused:
	#	PauseMenu.show()
	#	Engine.time_scale = 0
	#if !paused:
	#	PauseMenu.hide()
#		Engine.time_scale = 1
	


func _on_exit_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(next_level)
