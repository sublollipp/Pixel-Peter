extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2

var TimeToNextAnimation
var TimeToNextBounce

var BounceIncrement
var StartY

var bouncing: bool = false


func _ready():
	TimeToNextAnimation = randi_range(2,7)
	timer.wait_time = TimeToNextAnimation
	timer.start()
	
	TimeToNextBounce = randi_range(2,5)
	timer_2.wait_time = TimeToNextBounce
	timer_2.start()
	
	
	StartY=position.y
	BounceIncrement = randf_range(-7,-10)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bouncing:
		position.y += BounceIncrement*delta
		if position.y>=StartY:
			bouncing = false
			BounceIncrement = -BounceIncrement
		if position.y+5<=StartY:
			BounceIncrement = -BounceIncrement
	


func _on_timer_timeout():
	animated_sprite_2d.play("Shine")
	TimeToNextAnimation = randi_range(2,7)
	timer.wait_time = TimeToNextAnimation
	timer.start()
	

	


func _on_timer_2_timeout():
	bouncing = true
	TimeToNextBounce = randi_range(2,5)
	timer_2.wait_time = TimeToNextBounce
	timer_2.start()
