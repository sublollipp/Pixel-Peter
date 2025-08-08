extends CanvasLayer


#@onready var main = $"../"

var paused : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	if OS.has_feature("web"):
		%ExitButton.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Menu_Pause"):
		if not paused:
			pause()
		elif visible:
			pause()
		else:
			$Settings.visible = false
			show()

func _on_resume_button_button_up():
	pause()

func _on_settings_button_button_up() -> void:
	$Settings.visible = true
	hide()
	$Settings.makeOverlay()

func _on_main_button_button_up():
	# den stopper ikke med at være paused når man kommer tilbage i levelet fra main menu
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scener/main_menu.tscn")

func _on_exit_button_button_up():
	get_tree().quit()


func pause():
	
	paused = !paused
	
	if paused:
		show()
		Engine.time_scale = 0
	if !paused:
		hide()
		Engine.time_scale = 1
