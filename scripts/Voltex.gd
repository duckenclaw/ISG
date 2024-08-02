extends VBoxContainer

var hp = 25
var weaponPP = 5
var weaponDices = 2
var weaponDiceCategory = 6
var weaponRollResults = []
var defensePP = 5
var defenseDiceCategory = 6
var defenseDices = 2
var defenseRollResults = []


func _ready():
	recalculate_defense()

func recalculate_defense():
	defenseDices = (defensePP + 1) / (defenseDiceCategory / 2)
	
func calculate_hp(hp):
	$EnemyHealth.value = hp

func roll_defense():
	defenseRollResults.clear()
	print("Voltex defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + "dice rolled a " + str(roll))
		defenseRollResults.append(roll)
	return defenseRollResults
	
func roll_damage():
	print("Voltex attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		weaponRollResults.append(roll)
		

func end_turn(attackRollResults):
	var newRollResults = []
	roll_defense()
	roll_damage()
	# Check if any defense roll matches the attack roll and remove them
	for roll in attackRollResults:
		if roll in defenseRollResults:
			defenseRollResults.erase(roll)
		else:
			newRollResults.append(roll)
	
	# Adjust HP for every remaining roll result
	for roll in newRollResults:
		hp -= roll
		calculate_hp(hp)
	
	# Print current HP for debugging
	print("Voltex HP: ", hp)

	return weaponRollResults

