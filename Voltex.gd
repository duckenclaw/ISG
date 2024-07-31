extends VBoxContainer

var hp = 50
var defensePP = 5
var defense_dice_category = 6
var defense_dices = 2
var defense_roll_results = []

func _ready():
	recalculate_defense()

func recalculate_defense():
	defense_dices = (defensePP + 1) / (defense_dice_category / 2)
	
func calculate_hp(hp):
	$EnemyHealth.value = hp

func roll_defense():
	defense_roll_results.clear()
	print("Voltex defense roll " + str(defense_dices) + "d" + str(defense_dice_category))
	for dice in range(defense_dices):
		var roll = randi_range(1, defense_dice_category)
		print(str(dice) + " d" + str(defense_dice_category) + "dice rolled a " + str(roll))
		defense_roll_results.append(roll)
	return defense_roll_results

func end_turn(roll_results):
	var new_roll_results = []
	roll_defense()
	# Check if any defense roll matches the attack roll and remove them
	for roll in roll_results:
		if roll in defense_roll_results:
			defense_roll_results.erase(roll)
		else:
			new_roll_results.append(roll)

	# Adjust HP for every remaining roll result
	for roll in new_roll_results:
		hp -= roll
		calculate_hp(hp)
	
	# Print current HP for debugging
	print("Voltex HP: ", hp)

	return new_roll_results

