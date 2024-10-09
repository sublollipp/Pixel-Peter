extends Level

var previousEasyMode

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	previousEasyMode = Globals.easyMode
	Globals.easyMode = true
	

func _on_exit_entered(body: Node2D) -> void:
	super._on_exit_entered(body)
	Globals.easyMode = previousEasyMode
	print("sucsess")
