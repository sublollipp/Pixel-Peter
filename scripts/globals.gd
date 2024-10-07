extends Node

const debug_mode = true

var musicPercentage: int = 100
var sfxPercentage: int = 100
var mainPercentage: int = 100

const firstLevel := "res://scener/level_easy.tscn"

var musicPlaying: bool = false

var musicPlayer = preload("res://scener/music_player.tscn")
var transitionMaker = preload("res://scener/transitionmaker.tscn")

const startMusic = preload("res://sounds/PixelPeter-full.mp3")
const loopMusic = preload("res://sounds/PixelPeter-loop.mp3")

func _ready() -> void:
	add_child(musicPlayer.instantiate())
	add_child(transitionMaker.instantiate())
	musicPlayer = get_node("MusicPlayer") # Hvem bekymrer sig også om type safety??
	transitionMaker = get_node("Transitionmaker") # Ja, hvem bekymrer sig også om type safety??
	musicPlayer.stream = startMusic
	musicPlayer.get_node("Timer").timeout.connect(startLooping)

func startLooping() -> void:
	musicPlayer.stop()
	musicPlayer.get_node("LoopPlayer").play()

func exit() -> void: # Kører fade-out animationen når man går ud af et level
	transitionMaker.get_child(0).play("Exit")

func enter() -> void: # Kører fade-ind animationen når man går ind i et level
	transitionMaker.get_child(0).play("Enter")

func play() -> void:
	musicPlayer.play()
	musicPlayer.get_node("Timer").start()

func stop() -> void:
	musicPlayer.stop()
	musicPlayer.get_node("LoopPlayer").stop()

var totalCoins = 0

var coins: int = 0

func current_level() -> Level:
	return get_tree().get_nodes_in_group("Levels")[0]

func nextLevel(next_level: String) -> void:
	exit()
	if get_tree().get_nodes_in_group("Levels").size() > 0:
		current_level().exit()
	await transitionMaker.get_child(0).animation_finished
	get_tree().change_scene_to_file(next_level)
	enter()

func coinCollected() -> void:
	coins += 1

func setCoins(amount: int) -> void:
	coins = amount

func start_game_over() -> void:
	coins = 0
	exit()
	get_tree().change_scene_to_file(firstLevel)
	enter()
