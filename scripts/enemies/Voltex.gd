extends Control

var hp = 12

var weaponPP = 5
var weaponDices = 2
var weaponDiceCategory = 6
var weaponRollResults = []

var defensePP = 5
var defenseDices = 2
var defenseDiceCategory = 6
var defenseRollResults = []

func _init():
	print("Voltex ready for battle")
	recalculate_attack()
	recalculate_defense()

func recalculate_attack():
	weaponDices = (weaponPP + 1) / (weaponDiceCategory / 2)

func recalculate_defense():
	defenseDices = (defensePP + 1) / (defenseDiceCategory / 2)
	
func roll_damage():
	weaponRollResults.clear()
	print("Voltex attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		weaponRollResults.append(roll)
	return weaponRollResults

func roll_defense():
	defenseRollResults.clear()
	print("Voltex defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll))
		defenseRollResults.append(roll)
	return defenseRollResults
