extends CharacterBody2D

@export var timeInvincible: float = 1 ## Antal sekunder Peter er uovervindelig efter han har taget skade
@export var invincible_pulse_speed: float = 10 ## Hvor hurtigt spilleren flasher hvidt, når den er invincible
@export var running_out_pulse_speed:float = 20 ## Hvor hurtigt spilleren flasher hvid 2 sekunder inden, den bliver dødelig igen

@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D

# Den jump power, et hop starter på
const startingPower: int = 120

# Hvor meget, jump power går op pr. sekund man holder hop-knappen nede
const jumpChargeSpeed: int = 360
const directionChangeSpeed: int = 600

# Den opladte kraft i hoppet - stiger, når man holder hop-knappen inde
var chargedJumpPower: float = 0
var chargedDirectionPower: float = 0

const maxJumpPower: int = 600
const maxDirectionPower: int = 600

# Siger egentlig bare, om hop-knappen er holdt inde
var charging: bool = false
var idle: bool = true


# Hvor meget af ens vandrette hastighed bliver beholdt i et bounce
const bounceRetention: float = 0.55

# Hvis denne er sand, kan Peter ikke tage skade
var invincibility: bool = false

# Holder styr på, hvad spillerens hastighed var i sidste frame
var previousVelocity: Vector2 = Vector2.ZERO
var previousX = position.x

# -1 er venstre- +1 er højre
var direction: float = 0

var health = 3
var died: bool = false

var coinsCollected = 0

var StartPos
func _ready():
	timer.wait_time = timeInvincible
	StartPos = position
	
func _process(delta: float) -> void:
	if invincibility:
		if timer.time_left <= 1:
			sprite.material.set_shader_parameter("pulse_speed", running_out_pulse_speed)
	
	if charging: # Kører, hvis man er på jorden, og hop-knappen er holdt nede
		#øger directionpower intil maxniveau er ramt
		chargedDirectionPower = clamp(chargedDirectionPower + Input.get_axis("VENSTRE", "HØJRE") * directionChangeSpeed * delta, -maxDirectionPower, maxDirectionPower)
		# Øger jump poweren, indtil man har nået max niveau
		chargedJumpPower = clamp(chargedJumpPower + jumpChargeSpeed * delta, 0, maxJumpPower)

		sprite.material.set_shader_parameter("charge", chargedJumpPower / maxJumpPower)

	if health <= 0:
		died = true
		#midlertidig øjebliklig død
		if died:
			get_tree().change_scene_to_file("res://scener/game_over.tscn")
		

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	#Bouncer, når spilleren er på væggen
	if is_on_wall():
		velocity.x = previousVelocity.x * -bounceRetention
	
	#Sørger for, at spilleren står stille, når den er på gulvet. Altså nul sliding osv.
	if is_on_floor():
		velocity = Vector2.ZERO
		if sprite.animation == "flying"+str(health) or idle:
			sprite.play("idle"+str(health))
			idle = true
		
	else:
		if position.x - previousX > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
	#Opdaterer previousVelocity
	previousVelocity = velocity
	
	#Opdaterer previousX (bruges i at regne ud, hvilken retning, man slider
	previousX = position.x
	
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

func _input(event: InputEvent) -> void: # Denne funktion kører, når der sker noget som helst med inputsne
	if is_on_floor(): # Hvis man er i luften, skal man være ude af kontrol. Hermed kører input-koden kun, når man er på jorden
		if event.is_action_pressed("HØJRE"):
			direction = 1
			sprite.flip_h = true
	#Opdaterer spriten ift hvor meget liv player har animationerne bliver kaldt bygget på hp
			
		elif event.is_action_pressed("VENSTRE"):
			direction = -1
			sprite.flip_h = false
		if event.is_action_pressed("HOP"):
			chargedJumpPower = startingPower
			charging = true
			idle = false
			
			sprite.play("charging"+str(health))
			
		elif event.is_action_released("HOP"):
			charging = false
			jump()
			sprite.play("flying"+str(health))
			
			
		if event.is_action_pressed("Take_damage"):
			health -= 1
			sprite.play("idle"+str(health))
	else:
		charging = false
		#$AnimatedSprite2D.play("flying"+str(health))
	if event.is_action_pressed("Menu_Pause"):
		#burde omskrives så games process og fysisk process pauses og main menu bare er et overlay således at progress ikke mistes
		get_tree().change_scene_to_file("res://scener/main_menu.tscn")
	if event.is_action_pressed("MousePressed"):
		#for at kunne teste level
		position = get_local_mouse_position()+position

func jump() -> void:
	velocity.y = -chargedJumpPower
	velocity.x = chargedDirectionPower
	sprite.material.set_shader_parameter("charge", 0)
	
	chargedDirectionPower = 0
	chargedJumpPower = 0


func _on_area_2d_area_entered(area):
	#Differentier mellem layersne/ areasne kan ikke få det til at virke uden en lang refferance til coins altså noget son $//coins blalbla
	
	#Fuck hvor er det her konge lavet. Du har cooket max
	if area.is_in_group("GroupEnemy"):
		if !invincibility:
			health -= 1
			invincibility = true
			timer.start()
			sprite.material.set_shader_parameter("invincible", true)
			$CPUParticles2D.emitting = true
		
	if area.is_in_group("GroupCoins"):
		coinsCollected += 1
		print(coinsCollected)
	
	if area.is_in_group("GroupPotion"):
		if health < 3:
			health += 1
		
		
	# Dette skal afspilles ved collision med enemy
	
	var AnimationUpdate = sprite.animation
	AnimationUpdate = AnimationUpdate.left(-1)
	AnimationUpdate += str(health)
	sprite.animation = AnimationUpdate



func _on_timer_timeout():
	invincibility = false
	sprite.material.set_shader_parameter("invincible", false)
	sprite.material.set_shader_parameter("pulse_speed", invincible_pulse_speed)
