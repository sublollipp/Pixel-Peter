extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

var TimeToNextAnimation
# Called when the node enters the scene tree for the first time.
func _ready():
	TimeToNextAnimation = randi_range(2,7)
	timer.wait_time = TimeToNextAnimation
	timer.start()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	queue_free()
	


func _on_timer_timeout():
	animated_sprite_2d.play("Shine")
	TimeToNextAnimation = randi_range(2,7)
	timer.wait_time = TimeToNextAnimation
	timer.start()
	
