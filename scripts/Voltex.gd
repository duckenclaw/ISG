extends VBoxContainer

var hp = 100
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
	var battle_log = get_node("../ScrollContainer/BattleLog")
	print("Voltex defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	battle_log.text += "\nVoltex defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory) + " dices"
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll))
		battle_log.text += "\n" + str(dice+1) + " dice rolled a " + str(roll)
		defenseRollResults.append(roll)
	return defenseRollResults

func roll_damage():
	weaponRollResults.clear()
	var battle_log = get_node("../ScrollContainer/BattleLog")
	print("Voltex attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	battle_log.text += "\nVoltex attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices"
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		battle_log.text += "\n" + str(dice+1) + " dice rolled a " + str(roll)
		weaponRollResults.append(roll)
	return weaponRollResults
