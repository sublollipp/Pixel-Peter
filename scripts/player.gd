extends CharacterBody2D

@export_category("Invincibility")
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var timeInvincible: float = 1 ## Antal sekunder Peter er uovervindelig efter han har taget skade
@export var invincible_pulse_speed: float = 10 ## Hvor hurtigt spilleren flasher hvidt, når den er invincible
@export var running_out_pulse_speed:float = 20 ## Hvor hurtigt spilleren flasher hvid 2 sekunder inden, den bliver dødelig igen

@export_category("Sound changes")

## Ændring i lydstyrken af coin-pickup-effekten
@export_custom(PROPERTY_HINT_NONE, "suffix:db") var coin_volume: float = 0

## Ændring i lydstyrken af avs-effekten
@export_custom(PROPERTY_HINT_NONE, "suffix:db") var hurt_volume: float = 0

## Ændring i lydstyrken af nammenam-effekten
@export_custom(PROPERTY_HINT_NONE, "suffix:db") var heal_volume: float = 0

## Ændring i lydstyrken af hoppe-effekten
@export_custom(PROPERTY_HINT_NONE, "suffix:db") var jump_volume: float = 0

## Ændring i lydstyrken af mur-bonk-effekten
@export_custom(PROPERTY_HINT_NONE, "suffix:db") var bonk_volume: float = 0

# Gemmer vigtige nodes som variabler for nemmere tilgang
@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D
@onready var audioPlayer = $AudioStreamPlayer

# Preloader sfx
var coinSound = preload("res://sounds/pickupCoin.wav")
var hurtSound = preload("res://sounds/hitHurt.wav")
var jumpSound = preload("res://sounds/jump.wav")
var healthSound = preload("res://sounds/1up.wav")
var bonkSound = preload("res://sounds/hitWall.wav")

# Den jump power, et hop starter på
const startingPower: int = 120

# Hvor meget, jump power går op pr. sekund man holder hop-knappen nede
const jumpChargeSpeed: int = 360
const directionChangeSpeed: int = 600

# Den opladte kraft i hoppet - stiger, når man holder hop-knappen inde
var chargedJumpPower: float = 0
var chargedDirectionPower: float = 0

# Maximum højde- og retningskraft
const maxJumpPower: int = 500
const maxDirectionPower: int = 500

# Siger egentlig bare, om hop-knappen er holdt inde
var charging: bool = false

# Står man og laver ingenting? Brug i styring af animationer
var idle: bool = true

# Er man i gang med at slide på en skråning? Bruges i styring af bonk-lyden
var sliding: bool = false

# Hvor meget af ens vandrette hastighed bliver beholdt i et bounce
const bounceRetention: float = 0.55

# Hvis denne er sand, kan Peter ikke tage skade
var invincibility: bool = false

# Holder styr på, hvad spillerens hastighed var i sidste frame
var previousVelocity: Vector2 = Vector2.ZERO
var previousX = position.x

# Spillerens orienteringsretning. -1 er venstre- +1 er højre
var direction: float = 0

# Spillerens liv
var health = 3

# Gemmer spillerens startposition. Kan være praktisk, hvis spillet udvides med f.eks. respawns
var StartPos

func _ready():
	timer.wait_time = timeInvincible
	StartPos = position
	
func _process(delta: float) -> void:
	if invincibility:
		if timer.time_left <= 1:
			# Her kunne man have brugt sprites "modulate" param. Glemte, den fandtes. Upsi
			sprite.material.set_shader_parameter("pulse_speed", running_out_pulse_speed)
	
	if charging: # Kører, hvis man er på jorden, og hop-knappen er holdt nede
		#øger directionpower intil maxniveau er ramt
		chargedDirectionPower = clamp(chargedDirectionPower + Input.get_axis("VENSTRE", "HØJRE") * directionChangeSpeed * delta, -maxDirectionPower, maxDirectionPower)
		# Øger jump poweren, indtil man har nået max niveau
		chargedJumpPower = clamp(chargedJumpPower + jumpChargeSpeed * delta, 0, maxJumpPower)

		sprite.material.set_shader_parameter("charge", chargedJumpPower / maxJumpPower)
		

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	#Bouncer, når spilleren er på væggen
	if is_on_wall():
		velocity.x = previousVelocity.x * -bounceRetention
		if get_wall_normal().x > 0.8: # Kører kun bonk, hvis spilleren ikke slider. Ellers ville den køre hver frame (earrape)
			audioPlayer.volume_db = bonk_volume
			audioPlayer.stream = bonkSound
			audioPlayer.play()
			sliding = false
		else:
			if !sliding: # Når man rammer en skråning første gang, må den gerne bonke
				audioPlayer.volume_db = bonk_volume
				audioPlayer.stream = bonkSound
				audioPlayer.play()
				sliding = true
	else:
		# Sørger for at resette sliding
		sliding = false
	
	#Sørger for, at spilleren står stille, når den er på gulvet. Altså nul sliding osv.
	if is_on_floor():
		velocity = Vector2.ZERO
		if sprite.animation == "flying"+str(health) or idle:
			sprite.play("idle"+str(health))
			idle = true
		
	else:
		# Sørger for, at spriten er flippet rigtigt, når den bouncer i luften
		if position.x - previousX > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
	#Opdaterer previousVelocity
	previousVelocity = velocity
	
	#Opdaterer previousX (bruges i at regne ud, hvilken retning, man slider
	previousX = position.x
	
	# Tyngdekraft
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

func _input(event: InputEvent) -> void: # Denne funktion kører, når der sker noget som helst med inputsne
	if is_on_floor(): # Hvis man er i luften, skal man være ude af kontrol. Hermed kører det meste af input-koden kun, når man er på jorden
		
		# Styrer den retning, man vender
		if event.is_action_pressed("HØJRE"):
			direction = 1
			sprite.flip_h = true
		
		elif event.is_action_pressed("VENSTRE"):
			direction = -1
			sprite.flip_h = false
		
		# Påbegynder opladning til et hop, når man begynder at holde knappen inde
		if event.is_action_pressed("HOP"):
			chargedJumpPower = startingPower
			charging = true
			idle = false
			
			sprite.play("charging"+str(health))
		
		# Udfører hoppet, når man slipper hop-knappen
		elif event.is_action_released("HOP"):
			charging = false
			jump()
			sprite.play("flying"+str(health))
			
		# Debug-kode
		#if event.is_action_pressed("Take_damage"):
		#	health -= 1
		#	sprite.play("idle"+str(health))
	else:
		# Når man er i luften, oplader man jo for helvede ikke et hop
		charging = false
	
	# Debug funktionalitet
	if Globals.debug_mode:
		if event.is_action_pressed("MousePressed"):
			#for at kunne teste level
			position = get_local_mouse_position()+position
		if event.is_action_pressed("ui_down"):
			Globals.nextLevel(Globals.current_level().next_level)

# Funktionen for at hoppe
func jump() -> void:
	velocity.y = -chargedJumpPower
	velocity.x = chargedDirectionPower
	# Shaderen der gør ens øje rødt slås fra
	sprite.material.set_shader_parameter("charge", 0)
	
	audioPlayer.volume_db = jump_volume
	audioPlayer.stream = jumpSound
	audioPlayer.play()
	
	chargedDirectionPower = 0
	chargedJumpPower = 0


func _on_area_2d_area_entered(area):
	#Differentier mellem layersne/ areasne kan ikke få det til at virke uden en lang refference til coins altså noget son $//coins blalbla
	
	# Hvis man har kollideret med en enemy
	if area.is_in_group("GroupEnemy"):
		if !invincibility:
			if health <= 1:
				youDied()
			else:
				health -= 1
				invincibility = true
				# Timeren styrer, hvor lang tid man er uovervindelig
				timer.start()
				
				# Får spriten til at flashe hvidt. Man kunne have brugt dens modulate parameter, men det glemte jeg
				sprite.material.set_shader_parameter("invincible", true)
				$CPUParticles2D.emitting = true
				
				audioPlayer.volume_db = hurt_volume
				audioPlayer.stream = hurtSound
				audioPlayer.play()
	
	# Hvis man kolliderer med en coin
	if area.is_in_group("GroupCoins"):
		get_parent().coinCollected() # Opdaterer coins i levellet
		Globals.coinCollected() # Opdaterer coins i Globals
		area.get_parent().queue_free() # Fjerner coinen (areaen er et child a coinen)
		
		# Lyd
		audioPlayer.volume_db = coin_volume
		audioPlayer.stream = coinSound
		audioPlayer.play()
	
	# Hvis man kolliderer med en health potion
	if area.is_in_group("GroupPotion"):
		# Man skal ikke kunne samle health potions op, hvis man ikke kan bruge dem til noget
		if health < 3:
			health += 1
			audioPlayer.volume_db = heal_volume
			audioPlayer.stream = healthSound
			audioPlayer.play()
			area.get_parent().queue_free()
		
		
	# Opdateren animations. Hvis man har ramt en enemy eller en health potion, bruger man jo en anderledes én
	var AnimationUpdate = sprite.animation
	AnimationUpdate = AnimationUpdate.left(-1)
	AnimationUpdate += str(health)
	sprite.animation = AnimationUpdate

func youDied() -> void:
	set_process(false)
	set_physics_process(false)
	Globals.nextLevel("res://scener/game_over.tscn")

# Når ens invincibility løber ud
func _on_timer_timeout():
	invincibility = false
	sprite.material.set_shader_parameter("invincible", false)
	sprite.material.set_shader_parameter("pulse_speed", invincible_pulse_speed)
