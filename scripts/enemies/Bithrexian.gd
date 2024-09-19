extends Control

var hp = 8

var weaponPP = 7
var weaponDices = 2
var weaponDiceCategory = 8
var weaponRollResults = []

var defensePP = 3
var defenseDices = 2
var defenseDiceCategory = 4
var defenseRollResults = []

# Called when the node enters the scene tree for the first time.
func _init():
	print("Bithrexian ready for battle")
	recalculate_attack()
	recalculate_defense()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func recalculate_attack():
	weaponDices = (weaponPP + 1) / (weaponDiceCategory / 2)

func recalculate_defense():
	defenseDices = (defensePP + 1) / (defenseDiceCategory / 2)

func roll_damage():
	weaponRollResults.clear()
	print("Bithrexian attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		weaponRollResults.append(roll)
	return weaponRollResults

func roll_defense():
	defenseRollResults.clear()
	print("Bithrexian defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll))
		defenseRollResults.append(roll)
	return defenseRollResults

