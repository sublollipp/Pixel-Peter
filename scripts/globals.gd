extends Node

const debug_mode = false

var save_data: SaveData

var musicPercentage: int = 100
var sfxPercentage: int = 100
var mainPercentage: int = 100

var firstLevel := "res://scener/level_easy.tscn"

var musicPlaying: bool = false

var musicPlayer = preload("res://scener/music_player.tscn")
var transitionMaker = preload("res://scener/transitionmaker.tscn")
var runTimer = preload("res://scener/run.tscn")

const startMusic = preload("res://sounds/PixelPeter-full.mp3")
const loopMusic = preload("res://sounds/PixelPeter-loop.mp3")

var easyMode: bool = false

func _ready() -> void:
	add_child(musicPlayer.instantiate())
	add_child(transitionMaker.instantiate())
	add_child(runTimer.instantiate())
	musicPlayer = get_node("MusicPlayer") # Hvem bekymrer sig også om type safety??
	transitionMaker = get_node("Transitionmaker") # Ja, hvem bekymrer sig også om type safety??
	runTimer = get_node("Run")
	musicPlayer.stream = startMusic
	musicPlayer.finished.connect(startLooping)
	save_data = SaveData.load_or_create()

func startLooping() -> void:
	musicPlayer.stop()
	musicPlayer.get_node("LoopPlayer").play()

func exit() -> void: # Kører fade-out animationen når man går ud af et level
	transitionMaker.get_child(0).play("Exit")

func enter() -> void: # Kører fade-ind animationen når man går ind i et level
	transitionMaker.get_child(0).play("Enter")

func play() -> void:
	musicPlayer.play()

func stop() -> void:
	musicPlayer.stop()
	musicPlayer.get_node("LoopPlayer").stop()
	
func _process(delta):
	if easyMode:
		runTimer.wentEasy()

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
	startNewRun(firstLevel, runTimer.runName)

func startNewRun(firstLevelPath: String, runAlias: String) -> void:
	firstLevel = firstLevelPath
	runTimer.runName = runAlias
	runTimer.reset()

func runTime() -> String:
	return runTimer.timeToString()

func runName() -> String:
	return runTimer.runName

func cheated() -> bool:
	return runTimer.wasEasyMode
