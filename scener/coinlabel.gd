extends Label

var coins: int = 0

var maxCoins: int = 0

func _ready() -> void:
	Globals.current_level().coinsUpdated.connect(updateCoinTally)
	text = str(coins) + "/" + str(maxCoins)

func updateCoinTally(coinsIn, maxCoinsIn) -> void:
	coins = coinsIn
	maxCoins = maxCoinsIn
	text = str(coins) + "/" + str(maxCoins)
