extends Control

var particlePoints = 1
var hp = 25

var weaponPP = 5
var weaponDices = 2
var weaponDiceCategory = 6
var weaponRollResults = []

var defensePP = 1
var defenseDiceCategory = 6
var defenseDices = 2
var defenseRollResults = []

# Called when the node enters the scene tree for the first time.
func _ready():
	recalculateWeapon()
	

func recalculateWeapon():
	weaponDices = (weaponPP + 1) / (weaponDiceCategory / 2)
	$Panel/VBoxContainer/ParticlePointsCounter.text = str("Particles: ", particlePoints)
	$Panel/VBoxContainer/WeaponContainer/ParticlePoints/WeaponPP.text = str(weaponPP)
	$Panel/VBoxContainer/WeaponContainer/DamageDiceContainer/WeaponDice.text = str("d", weaponDiceCategory)
	$Panel/VBoxContainer/WeaponContainer/Damage.text = str(weaponDices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_weapon_pp_up_pressed():
	if particlePoints > 0:
		particlePoints -= 1
		weaponPP += 1
	recalculateWeapon()

func _on_weapon_pp_down_pressed():
	if weaponPP > 1:
		particlePoints += 1
		weaponPP -= 1
	recalculateWeapon()

func _on_weapon_dd_up_pressed():
	if weaponDiceCategory < 12:
		weaponDiceCategory += 2
	recalculateWeapon()

func _on_weapon_dd_down_pressed():
	if weaponDiceCategory > 4:
		weaponDiceCategory -= 2
	recalculateWeapon()

func roll_damage():
	weaponRollResults.clear()
	print("Player attack roll " + str(weaponDices) + "d" + str(weaponDiceCategory) + " dices")
	for dice in range(int(weaponDices)):
		var roll = randi_range(1, weaponDiceCategory)
		print(str(dice+1) + " dice rolled a " + str(roll))
		weaponRollResults.append(roll)
		create_dice_image(roll)
		
func roll_defense():
	defenseRollResults.clear()
	print("Player defense roll " + str(defenseDices) + "d" + str(defenseDiceCategory))
	for dice in range(defenseDices):
		var roll = randi_range(1, defenseDiceCategory)
		print(str(dice+1) + " d" + str(defenseDiceCategory) + "dice rolled a " + str(roll))
		defenseRollResults.append(roll)
	return defenseRollResults

func end_turn():
	var newRollResults = []
	roll_damage()
	roll_defense()

	# Call Voltex end_turn function
	var voltex = $EnemyContainer
	var attackRollResults = voltex.end_turn(weaponRollResults)

	for roll in attackRollResults:
		if roll in defenseRollResults:
			defenseRollResults.erase(roll)
		else:
			newRollResults.append(roll)
			
	for roll in newRollResults:
		hp -= roll
	
	print("Player HP: ", hp)
	

func create_dice_image(roll_value):
	var diceImagePath = "res://art/dice" + str(weaponDiceCategory) + ".png"
	var diceTexture = load(diceImagePath)

	if diceTexture:
		var diceImage = Sprite2D.new()
		diceImage.texture = diceTexture

		var diceLabel = Label.new()
		diceLabel.text = str(roll_value)
		diceLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		diceLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		diceLabel.grow_horizontal = Control.GROW_DIRECTION_BOTH
		diceLabel.grow_vertical = Control.GROW_DIRECTION_BOTH

		diceImage.add_child(diceLabel)
		$DiceImagesContainer.add_child(diceImage)
	else:
		print("Failed to load dice image:", diceImagePath)
