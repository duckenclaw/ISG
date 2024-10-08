extends Control

var hp = 10
var particlePoints = 5

var weaponPP = 1
var weaponDices = 1
var weaponDiceCategory = 4
var weaponRollResults = []

var defensePP = 1
var defenseDiceCategory = 4
var defenseDices = 1
var defenseRollResults = []

func _ready():
	recalculate_attack()
	recalculate_defense()

func recalculate_attack():
	weaponDices = (weaponPP + 1) / (weaponDiceCategory / 2)
	
func recalculate_defense():
	defenseDices = (defensePP + 1) / (defenseDiceCategory / 2)

func roll_damage():
	weaponRollResults.clear()
	print("Player attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		weaponRollResults.append(roll)
	return weaponRollResults

func roll_defense():
	defenseRollResults.clear()
	print("Player defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll))
		defenseRollResults.append(roll)
	return defenseRollResults
