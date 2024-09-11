extends CharacterBody2D

# Hvor meget af ens vandrette hastighed bliver beholdt i et bounce
const bounceRetention: float = 0.55

# Den jump power, et hop starter på
const startingPower: int = 120

# Hvor meget, jump power går op pr. sekund man holder hop-knappen nede
const jumpChargeSpeed: int = 360

const maxJumpPower: int = 600

# Holder styr på, hvad spillerens hastighed var i sidste frame
var previousVelocity: Vector2 = Vector2.ZERO

# -1 er venstre- +1 er højre
var direction: int = 0

# Den opladte kraft i hoppet - stiger, når man holder hop-knappen inde
var chargedJumpPower: float = 0

# Siger egentlig bare, om hop-knappen er holdt inde
var charging: bool = false

func _process(delta: float) -> void:
	if charging:
		print(chargedJumpPower)
		if chargedJumpPower < maxJumpPower:
			chargedJumpPower += jumpChargeSpeed * delta
		elif chargedJumpPower > maxJumpPower:
			chargedJumpPower = maxJumpPower

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	
	if is_on_wall():
		velocity.x = previousVelocity.x * -bounceRetention
	
	if is_on_floor():
		velocity = Vector2.ZERO
	
	previousVelocity = velocity

func _input(event: InputEvent) -> void: # Denne funktion kører, når der sker noget som helst med inputsne
	if is_on_floor():
		if event.is_action_pressed("HØJRE"):
			direction = 1
			$Sprite2D.flip_h = true
			print("HØJRE")
		elif event.is_action_pressed("VENSTRE"):
			direction = -1
			$Sprite2D.flip_h = false
			print("VENSTRE")
		if event.is_action_pressed("HOP"):
			chargedJumpPower = startingPower
			charging = true
		elif event.is_action_released("HOP"):
			charging = false
			jump()

func jump() -> void:
	velocity.y = -chargedJumpPower
	velocity.x = chargedJumpPower * direction
	chargedJumpPower = 0
