extends AnimatedSprite2D

@onready var diaCast = $DiagonalRaycast
@onready var hCast = $StraightRaycast
@onready var timer = $Timer
@onready var audioPlayer = $AudioStreamPlayer2D

@export var speed: int = 15 ## Psykologens hastighed i pixels pr. sekund

var direction = 1 # 1 er højre, -1 er venstre

func detectTurn() -> void: # Detekter kant af platform eller mur og vender sig om
	if !diaCast.is_colliding() || hCast.is_colliding():
		direction *= -1

func _physics_process(delta: float) -> void:
	diaCast.scale.x = direction * -1
	hCast.scale.x = direction * -1
	if direction > 0:
		flip_h = true
	else:
		flip_h = false
	$Area2D.scale.x = direction * -1
	detectTurn()
	position.x += speed * direction * delta


func _on_timer_timeout() -> void:
	audioPlayer.play()
