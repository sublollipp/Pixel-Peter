extends Node2D

@onready var camLimits := $CameraLimits
@onready var player := $Player

func _ready() -> void:
	var mainCam: Camera2D = Camera2D.new()
	mainCam.zoom = Vector2(camLimits.zoom, camLimits.zoom)
	mainCam.offset = camLimits.offset
	if camLimits.camera_mode == 0:
		if(camLimits.size != Vector2.ZERO):
			mainCam.limit_left == camLimits.position.x
			mainCam.limit_right == camLimits.position.x + camLimits.size.x
			mainCam.limit_top == camLimits.position.y
			mainCam.limit_bottom == camLimits.position.y + camLimits.size.y
		player.add_child(mainCam)
	else:
		add_child(mainCam)
