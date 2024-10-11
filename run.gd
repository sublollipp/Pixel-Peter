# Denne node repræsenterer ét run af pixel peter. Den tracker om man har aktiveret easy mode på noget tidspunkt og holder styr på tiden.
# Den holder også styr på, hvilket run man er i gang med (tutorial/normal/boss)

extends Node

var time: float = 0 # Hvor lang tid der er gået, i sekunder

var runName: String = ""

var wasEasyMode: bool = false

func _physics_process(delta: float) -> void:
	time += delta # Sørger for, at speedrun timeren ikke tæller, når spillet er pauset ved at køre den i physics process

func timeToString() -> String:
	var m: int = int(time/60)
	var h: int = int(m/60)
	var hours: String = str(h)
	var minutes: String = str(m - h * 60) # Timerne skal ikke tælles med to gange, så de trækkes her fra
	var seconds: String = str(snapped(time - m * 60, 0.01)) # Snapped afrunder
	if seconds.length() < 4:
		seconds = "0" + seconds
	if minutes.length() < 2:
		minutes = "0" + minutes
	return(hours + ":" + minutes + ":" + seconds)
	

func wentEasy() -> void:
	wasEasyMode = true

func reset() -> void:
	time = 0
	wasEasyMode = false
