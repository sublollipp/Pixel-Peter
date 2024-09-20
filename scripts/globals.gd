extends Node

signal coinsUpdated(coins)

var coins: int = 0:
	set(value):
		coinsUpdated.emit(value)
		coins = value

func coinCollected() -> void:
	coins += 1
