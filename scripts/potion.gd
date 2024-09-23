extends Node2D

# Kunne bruge nogle flere export-variabler

@onready var timer = $Timer

var BounceIncrement
var StartY

var TimeToNextBounce
var bouncing : bool = false

func _ready():
	# Randomizer tiden indtil næste kosmetiske "bounce" af potionen
	TimeToNextBounce = randi_range(5,10)
	timer.wait_time = TimeToNextBounce
	timer.start()
	
	
	StartY=position.y
	BounceIncrement = -10


func _process(delta):
	if bouncing:
		position.y += BounceIncrement*delta
		if position.y>=StartY:
			bouncing=false
			BounceIncrement = -BounceIncrement
		if position.y+5<=StartY:
			BounceIncrement = -BounceIncrement

func _on_timer_timeout():
	# Genstarter processen når et bounce er lavet
	bouncing = true
	TimeToNextBounce = randi_range(5,10)
	timer.wait_time = TimeToNextBounce
	timer.start()
	
