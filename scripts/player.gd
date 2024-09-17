extends CharacterBody2D

# Hvor meget af ens vandrette hastighed bliver beholdt i et bounce
const bounceRetention: float = 0.55

# Den jump power, et hop starter på
const startingPower: int = 120

# Hvor meget, jump power går op pr. sekund man holder hop-knappen nede
const jumpChargeSpeed: int = 360

const maxJumpPower: int = 600
const maxDirectionPower: int = 600

const directionChangeSpeed = 10

var chargedDirectionPower: float = 0

var health = 3

# Holder styr på, hvad spillerens hastighed var i sidste frame
var previousVelocity: Vector2 = Vector2.ZERO

# -1 er venstre- +1 er højre
var direction: float = 0

# Den opladte kraft i hoppet - stiger, når man holder hop-knappen inde
var chargedJumpPower: float = 0

# Siger egentlig bare, om hop-knappen er holdt inde
var charging: bool = false

@onready var camera = $Camera2D

func _process(delta: float) -> void:
	if charging: # Kører, hvis man er på jorden, og hop-knappen er holdt nede
		
		#øger directionpower intil maxniveau er ramt
		chargedDirectionPower = clamp(chargedDirectionPower + Input.get_axis("VENSTRE", "HØJRE") * directionChangeSpeed, -maxDirectionPower, maxDirectionPower)
		
		#if chargedDirectionPower < maxDirectionPower and chargedDirectionPower > -maxDirectionPower:
			#chargedDirectionPower += Input.get_axis("VENSTRE", "HØJRE") * directionChangeSpeed
		#elif chargedDirectionPower > maxDirectionPower :
			#chargedDirectionPower = maxJumpPower
		#elif chargedDirectionPower < -maxDirectionPower :
			#chargedDirectionPower = -maxJumpPower
		
		# Øger jump poweren, indtil man har nået max niveau
		chargedJumpPower = clamp(chargedJumpPower + jumpChargeSpeed * delta, 0, maxJumpPower)
		
		#if chargedJumpPower < maxJumpPower:
			#chargedJumpPower += jumpChargeSpeed * delta
		#elif chargedJumpPower > maxJumpPower:
			#chargedJumpPower = maxJumpPower

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	
	#Bouncer, når spilleren er på væggen
	if is_on_wall():
		velocity.x = previousVelocity.x * -bounceRetention
	
	#Sørger for, at spilleren står stille, når den er på gulvet. Altså nul sliding osv.
	if is_on_floor():
		velocity = Vector2.ZERO
	if is_on_floor() and $AnimatedSprite2D.animation == "flying"+str(health):
		$AnimatedSprite2D.play("idle"+str(health))
		
	#Opdaterer previousVelocity
	previousVelocity = velocity

func _input(event: InputEvent) -> void: # Denne funktion kører, når der sker noget som helst med inputsne
	if is_on_floor(): # Hvis man er i luften, skal man være ude af kontrol. Hermed kører input-koden kun, når man er på jorden
		$AnimatedSprite2D.play("idle"+str(health))
		if event.is_action_pressed("HØJRE"):
			$AnimatedSprite2D.flip_h = true
	#Opdaterer spriten ift hvor meget liv player har animationerne bliver kaldt bygget på hp
			
		elif event.is_action_pressed("VENSTRE"):
			direction = -1
			$AnimatedSprite2D.flip_h = false
		if event.is_action_pressed("HOP"):
			chargedJumpPower = startingPower
			charging = true
			
			$AnimatedSprite2D.play("charging"+str(health))
			
		elif event.is_action_released("HOP"):
			charging = false
			jump()
			$AnimatedSprite2D.play("flying"+str(health))
			
			
		if event.is_action_pressed("Take_damege"):
			health -= 1
			$AnimatedSprite2D.play("idle"+str(health))
	else:
		pass
		#$AnimatedSprite2D.play("flying"+str(health))

func jump() -> void:
	velocity.y = -chargedJumpPower
	velocity.x = chargedDirectionPower
	
	chargedDirectionPower = 0
	chargedJumpPower = 0

func setCameraSettings(rectPos: Vector2, rectSize: Vector2, zoom: float, offset: Vector2) -> void:
	if rectSize != Vector2.ZERO:
		camera.limit_left = rectPos.x
		camera.limit_right = rectPos.x + rectSize.x
		camera.limit_top = rectPos.y
		camera.limit_bottom = rectPos.y + rectSize.y
		camera.zoom = Vector2(zoom, zoom)
	else:
		camera.enabled = false
