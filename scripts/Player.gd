extends VBoxContainer

var hp = 100
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
	var weaponPP_UI = get_node("../Panel/VBoxContainer/WeaponContainer/ParticlePoints/WeaponPP")
	var weaponDices_UI = get_node("../Panel/VBoxContainer/WeaponContainer/DiceAmount")
	var weaponDiceCategory_UI = get_node("../Panel/VBoxContainer/WeaponContainer/DiceCategory/WeaponDice")
	var particlePoints_UI = get_node("../Panel/VBoxContainer/ParticlePointsCounter")
	weaponDices = (weaponPP + 1) / (weaponDiceCategory / 2)
	particlePoints_UI.text = str(particlePoints)
	weaponPP_UI.text = str(weaponPP)
	weaponDices_UI.text = str(weaponDices)
	weaponDiceCategory_UI.text = str(weaponDiceCategory)
	
func recalculate_defense():
	var defensePP_UI = get_node("../Panel/VBoxContainer/DefenseContainer/ParticlePoints/DefensePP")
	var defenseDices_UI = get_node("../Panel/VBoxContainer/DefenseContainer/DiceAmount")
	var defenseDiceCategory_UI = get_node("../Panel/VBoxContainer/DefenseContainer/DiceCategory/DefenseDice")
	var particlePoints_UI = get_node("../Panel/VBoxContainer/ParticlePointsCounter")
	defenseDices = (defensePP + 1) / (defenseDiceCategory / 2)
	particlePoints_UI.text = str(particlePoints)
	defensePP_UI.text = str(defensePP)
	defenseDices_UI.text = str(defenseDices)
	defenseDiceCategory_UI.text = str(defenseDiceCategory)

func calculate_hp():
	$PlayerHealth.value = hp

func roll_damage():
	weaponRollResults.clear()
	var battle_log = get_node("../ScrollContainer/BattleLog")
	print("Player attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	battle_log.text += "\nPlayer attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices"
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		battle_log.text += "\n" + str(dice+1) + " dice rolled a " + str(roll)
		weaponRollResults.append(roll)
	return weaponRollResults

func roll_defense():
	defenseRollResults.clear()
	var battle_log = get_node("../ScrollContainer/BattleLog")
	print("Player defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	battle_log.text += "\nPlayer defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory)
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll))
		battle_log.text += "\n" + str(dice+1) + " d" + str(defenseDiceCategory) + " dice rolled a " + str(roll)
		defenseRollResults.append(roll)
	return defenseRollResults
