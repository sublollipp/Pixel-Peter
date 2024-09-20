extends Path2D

@export var speed: int = 10 ## Pterosaurens hastighed i pixels pr. sekund

@onready var pathLength := curve.get_baked_length()
@onready var follower := $PathFollow2D
@onready var sprite = follower.get_node("AnimatedSprite2D")
@onready var previousX = sprite.get_global_position().x
@onready var timer = follower.get_node("Timer")
@onready var audioPlayer = follower.get_node("AudioStreamPlayer2D")

var direction = 1 # 1 er i kurvens retning, -1 er tilbage

func _process(delta: float) -> void:
	var spriteglobalpos = sprite.get_global_position().x
	sprite.flip_h = spriteglobalpos > previousX
	follower.progress += speed * delta * direction
	if follower.progress >= pathLength:
		direction = -1
	if follower.progress <= 0:
		direction = 1
	previousX = spriteglobalpos


func _on_timer_timeout() -> void:
	audioPlayer.play()
