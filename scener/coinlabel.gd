extends Label

var coins: int = 0

func _ready() -> void:
	Globals.coinsUpdated.connect(updateCoinTally)

func updateCoinTally(coinsIn) -> void:
	coins = coinsIn
	text = str(coins)
