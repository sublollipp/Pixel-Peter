extends Node2D
@onready var timer = $Timer

var BounceIncrement
var StartY

var TimeToNextBounce
var bouncing : bool = false

func _ready():
	TimeToNextBounce = randi_range(5,10)
	timer.wait_time = TimeToNextBounce
	timer.start()
	
	
	StartY=position.y
	BounceIncrement = -10
	pass


func _process(delta):
	if bouncing:
		position.y += BounceIncrement*delta
		if position.y>=StartY:
			bouncing=false
			BounceIncrement = -BounceIncrement
		if position.y+5<=StartY:
			BounceIncrement = -BounceIncrement
	pass
	
func _on_area_2d_area_entered(area):
	queue_free()

func _on_timer_timeout():
	bouncing = true
	TimeToNextBounce = randi_range(5,10)
	timer.wait_time = TimeToNextBounce
	timer.start()
	
