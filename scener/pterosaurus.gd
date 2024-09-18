extends Path2D

@export var speed: int = 10 ## Pterosaurens hastighed i pixels pr. sekund

@onready var pathLength := curve.get_baked_length()
@onready var follower := $PathFollow2D
@onready var sprite = follower.get_child(0)
@onready var previousX = sprite.get_global_position().x

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
